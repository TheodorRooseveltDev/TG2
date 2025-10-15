import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';
import '../models/user_stats.dart';
import '../models/achievement.dart';
import '../models/recipe.dart';
import 'achievement_service.dart';

class DataService {
  static const String _prefsKey = 'user_preferences';
  static const String _statsKey = 'user_stats';
  static const String _onboardingKey = 'onboarding_complete';

  Future<UserPreferences> getUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString != null) {
      return UserPreferences.fromJson(json.decode(jsonString));
    }
    return UserPreferences();
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, json.encode(preferences.toJson()));
  }

  Future<UserStats> getUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_statsKey);
    if (jsonString != null) {
      return UserStats.fromJson(json.decode(jsonString));
    }
    return UserStats();
  }

  Future<void> saveUserStats(UserStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, json.encode(stats.toJson()));
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete(bool complete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, complete);
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
    await prefs.remove(_prefsKey);
    await prefs.remove(_onboardingKey);
  }

  Future<UserStats> completeRecipe(String recipeId, int points, String cuisine) async {
    final stats = await getUserStats();
    final previousStats = stats;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayKey = today.toIso8601String().split('T')[0];

    // Update stats
    int newStreak = stats.currentStreak;
    if (stats.lastCookedDate != null) {
      final lastCooked = DateTime(
        stats.lastCookedDate!.year,
        stats.lastCookedDate!.month,
        stats.lastCookedDate!.day,
      );
      final daysDiff = today.difference(lastCooked).inDays;
      if (daysDiff == 1) {
        newStreak++;
      } else if (daysDiff > 1) {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    final updatedHistory = Map<String, int>.from(stats.weeklyHistory);
    updatedHistory[todayKey] = (updatedHistory[todayKey] ?? 0) + 1;

    final updatedCookedIds = List<String>.from(stats.cookedRecipeIds);
    if (!updatedCookedIds.contains(recipeId)) {
      updatedCookedIds.add(recipeId);
    }

    // Update cuisine count
    final updatedCuisineCount = Map<String, int>.from(stats.cuisineCount);
    updatedCuisineCount[cuisine] = (updatedCuisineCount[cuisine] ?? 0) + 1;

    // Check if it's recipe of the day
    bool isRecipeOfDay = stats.recipeOfTheDayId == recipeId;
    int recipeOfDayCount = stats.recipeOfDayCooked;
    if (isRecipeOfDay) {
      recipeOfDayCount++;
      points = points * 2; // Double points for recipe of the day!
    }

    final newStats = stats.copyWith(
      totalRecipesCooked: stats.totalRecipesCooked + 1,
      mealsToday: stats.mealsToday + 1,
      mealsThisWeek: stats.mealsThisWeek + 1,
      currentStreak: newStreak,
      longestStreak: newStreak > stats.longestStreak ? newStreak : stats.longestStreak,
      totalPoints: stats.totalPoints + points,
      cookedRecipeIds: updatedCookedIds,
      lastCookedDate: now,
      weeklyHistory: updatedHistory,
      cuisineCount: updatedCuisineCount,
      recipeOfDayCooked: recipeOfDayCount,
    );

    // Check for new achievements
    final newAchievements = AchievementService.checkForNewAchievements(newStats, previousStats);
    if (newAchievements.isNotEmpty) {
      final updatedAchievements = List<UserAchievement>.from(newStats.achievements);
      int bonusPoints = 0;
      
      for (final achievement in newAchievements) {
        updatedAchievements.add(UserAchievement(
          achievementId: achievement.id,
          unlockedAt: DateTime.now(),
          seen: false,
        ));
        bonusPoints += achievement.pointsReward;
      }

      final finalStats = newStats.copyWith(
        achievements: updatedAchievements,
        totalPoints: newStats.totalPoints + bonusPoints,
      );

      await saveUserStats(finalStats);
      return finalStats;
    }

    await saveUserStats(newStats);
    return newStats;
  }

  Future<void> incrementSpins() async {
    final stats = await getUserStats();
    final previousStats = stats;
    final newStats = stats.copyWith(totalSpins: stats.totalSpins + 1);

    // Check for spin achievements
    final newAchievements = AchievementService.checkForNewAchievements(newStats, previousStats);
    if (newAchievements.isNotEmpty) {
      final updatedAchievements = List<UserAchievement>.from(newStats.achievements);
      int bonusPoints = 0;
      
      for (final achievement in newAchievements) {
        updatedAchievements.add(UserAchievement(
          achievementId: achievement.id,
          unlockedAt: DateTime.now(),
          seen: false,
        ));
        bonusPoints += achievement.pointsReward;
      }

      final finalStats = newStats.copyWith(
        achievements: updatedAchievements,
        totalPoints: newStats.totalPoints + bonusPoints,
      );

      await saveUserStats(finalStats);
      return;
    }

    await saveUserStats(newStats);
  }

  Future<void> incrementGuideVisits() async {
    final stats = await getUserStats();
    final newStats = stats.copyWith(guideVisits: stats.guideVisits + 1);
    await saveUserStats(newStats);
  }

  Future<String> getRecipeOfTheDay(List<Recipe> allRecipes) async {
    final stats = await getUserStats();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if we already have a recipe for today
    if (stats.recipeOfTheDayDate != null) {
      final recipeDay = DateTime(
        stats.recipeOfTheDayDate!.year,
        stats.recipeOfTheDayDate!.month,
        stats.recipeOfTheDayDate!.day,
      );

      if (recipeDay == today && stats.recipeOfTheDayId != null) {
        return stats.recipeOfTheDayId!;
      }
    }

    // Generate new recipe of the day
    // Use a seed based on the date for consistent daily recipe
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final random = Random(seed);
    
    // Filter to unlocked recipes only
    final availableRecipes = allRecipes.where((r) => !r.isLocked).toList();
    if (availableRecipes.isEmpty) return allRecipes.first.id;

    final selectedRecipe = availableRecipes[random.nextInt(availableRecipes.length)];

    final newStats = stats.copyWith(
      recipeOfTheDayId: selectedRecipe.id,
      recipeOfTheDayDate: today,
    );

    await saveUserStats(newStats);
    return selectedRecipe.id;
  }

  Future<void> markAchievementAsSeen(String achievementId) async {
    final stats = await getUserStats();
    final updatedAchievements = stats.achievements.map((a) {
      if (a.achievementId == achievementId) {
        return a.copyWith(seen: true);
      }
      return a;
    }).toList();

    final newStats = stats.copyWith(achievements: updatedAchievements);
    await saveUserStats(newStats);
  }

  Future<void> claimAchievement(String achievementId, int pointsReward) async {
    final stats = await getUserStats();
    final updatedAchievements = stats.achievements.map((a) {
      if (a.achievementId == achievementId) {
        return a.copyWith(claimed: true, seen: true);
      }
      return a;
    }).toList();

    final newStats = stats.copyWith(
      achievements: updatedAchievements,
      totalPoints: stats.totalPoints + pointsReward,
    );
    await saveUserStats(newStats);
  }

  bool hasUnclaimedAchievements(UserStats stats) {
    return stats.achievements.any((a) => !a.claimed);
  }
}

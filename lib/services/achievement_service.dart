import '../models/achievement.dart';
import '../models/user_stats.dart';

class AchievementService {
  /// Check and unlock achievements based on current stats
  static List<Achievement> checkForNewAchievements(
    UserStats stats,
    UserStats previousStats,
  ) {
    final newlyUnlocked = <Achievement>[];
    final allAchievements = Achievement.getAllAchievements();
    final unlockedIds = stats.achievements.map((a) => a.achievementId).toSet();

    for (final achievement in allAchievements) {
      // Skip if already unlocked
      if (unlockedIds.contains(achievement.id)) continue;

      bool shouldUnlock = false;

      switch (achievement.type) {
        case AchievementType.spins:
          shouldUnlock = stats.totalSpins >= achievement.requiredCount;
          break;

        case AchievementType.recipes:
          shouldUnlock =
              stats.cookedRecipeIds.length >= achievement.requiredCount;
          break;

        case AchievementType.streak:
          shouldUnlock = stats.currentStreak >= achievement.requiredCount;
          break;

        case AchievementType.cuisines:
          shouldUnlock = stats.cuisineCount.length >= achievement.requiredCount;
          break;

        case AchievementType.speed:
          // This is checked during cooking completion
          break;

        case AchievementType.guideVisits:
          shouldUnlock = stats.guideVisits >= achievement.requiredCount;
          break;

        case AchievementType.recipeOfDay:
          shouldUnlock = stats.recipeOfDayCooked >= achievement.requiredCount;
          break;
      }

      if (shouldUnlock) {
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  /// Get progress for a specific achievement
  static double getAchievementProgress(Achievement achievement, UserStats stats) {
    int current = 0;

    switch (achievement.type) {
      case AchievementType.spins:
        current = stats.totalSpins;
        break;
      case AchievementType.recipes:
        current = stats.cookedRecipeIds.length;
        break;
      case AchievementType.streak:
        current = stats.currentStreak;
        break;
      case AchievementType.cuisines:
        current = stats.cuisineCount.length;
        break;
      case AchievementType.speed:
        current = 0; // Special case
        break;
      case AchievementType.guideVisits:
        current = stats.guideVisits;
        break;
      case AchievementType.recipeOfDay:
        current = stats.recipeOfDayCooked;
        break;
    }

    return (current / achievement.requiredCount).clamp(0.0, 1.0);
  }

  /// Get the next achievement to unlock for motivation
  static Achievement? getNextAchievement(UserStats stats) {
    final allAchievements = Achievement.getAllAchievements();
    final unlockedIds = stats.achievements.map((a) => a.achievementId).toSet();

    Achievement? closest;
    double closestProgress = 0;

    for (final achievement in allAchievements) {
      if (unlockedIds.contains(achievement.id)) continue;

      final progress = getAchievementProgress(achievement, stats);
      if (progress > closestProgress && progress < 1.0) {
        closestProgress = progress;
        closest = achievement;
      }
    }

    return closest;
  }

  /// Get motivational message based on stats
  static String getMotivationalMessage(UserStats stats) {
    final messages = <String>[];

    // Streak messages
    if (stats.currentStreak >= 7) {
      messages.add("You're on fire! 🔥 ${stats.currentStreak} day streak!");
    } else if (stats.currentStreak >= 3) {
      messages.add("Great momentum! Keep that ${stats.currentStreak} day streak going!");
    } else if (stats.currentStreak == 1) {
      messages.add("Day 1 of your streak! Cook again tomorrow!");
    }

    // Weekly goal messages
    if (stats.mealsThisWeek >= 7) {
      messages.add("Amazing! You cooked every day this week! 🎉");
    } else if (stats.mealsThisWeek >= 5) {
      messages.add("${7 - stats.mealsThisWeek} more meal${7 - stats.mealsThisWeek == 1 ? '' : 's'} for your weekly goal!");
    } else if (stats.mealsThisWeek >= 1) {
      messages.add("Keep going! ${stats.mealsThisWeek} meal${stats.mealsThisWeek == 1 ? '' : 's'} cooked this week!");
    }

    // Recipe count messages
    if (stats.cookedRecipeIds.length >= 25) {
      messages.add("Master Chef vibes! ${stats.cookedRecipeIds.length} recipes conquered!");
    } else if (stats.cookedRecipeIds.length >= 10) {
      messages.add("You're becoming a pro! ${stats.cookedRecipeIds.length} recipes cooked!");
    } else if (stats.cookedRecipeIds.length >= 5) {
      messages.add("Nice progress! ${stats.cookedRecipeIds.length} recipes down!");
    }

    // Today's meals
    if (stats.mealsToday >= 3) {
      messages.add("Three meals today! You're crushing it! 💪");
    } else if (stats.mealsToday >= 2) {
      messages.add("Two meals down today! Looking good!");
    } else if (stats.mealsToday == 1) {
      messages.add("First meal of the day complete! 👨‍🍳");
    }

    // Recent achievement
    if (stats.achievements.isNotEmpty) {
      final recentAchievement = stats.achievements.last;
      final now = DateTime.now();
      final diff = now.difference(recentAchievement.unlockedAt);
      
      if (diff.inHours < 24) {
        final achievement = Achievement.getAllAchievements()
            .firstWhere((a) => a.id == recentAchievement.achievementId);
        messages.add("${achievement.icon} New: ${achievement.title}!");
      }
    }

    // Default messages
    if (messages.isEmpty) {
      final defaults = [
        "Ready to cook something amazing?",
        "What delicious meal will you create today?",
        "Time to spin the wheel of flavor!",
        "Let's make something tasty!",
        "Your kitchen awaits! 🍳",
      ];
      messages.add(defaults[DateTime.now().millisecond % defaults.length]);
    }

    return messages.first;
  }

  /// Get user's cooking level based on points
  static Map<String, dynamic> getUserLevel(int totalPoints) {
    if (totalPoints >= 1000) {
      return {
        'level': 'Culinary Expert',
        'icon': '🏆',
        'nextLevel': null,
        'pointsToNext': 0,
        'progress': 1.0,
      };
    } else if (totalPoints >= 600) {
      return {
        'level': 'Master Chef',
        'icon': '⭐',
        'nextLevel': 'Culinary Expert',
        'pointsToNext': 1000 - totalPoints,
        'progress': (totalPoints - 600) / 400,
      };
    } else if (totalPoints >= 300) {
      return {
        'level': 'Skilled Chef',
        'icon': '👨‍🍳',
        'nextLevel': 'Master Chef',
        'pointsToNext': 600 - totalPoints,
        'progress': (totalPoints - 300) / 300,
      };
    } else if (totalPoints >= 100) {
      return {
        'level': 'Home Cook',
        'icon': '🍳',
        'nextLevel': 'Skilled Chef',
        'pointsToNext': 300 - totalPoints,
        'progress': (totalPoints - 100) / 200,
      };
    } else {
      return {
        'level': 'Beginner',
        'icon': '🥘',
        'nextLevel': 'Home Cook',
        'pointsToNext': 100 - totalPoints,
        'progress': totalPoints / 100,
      };
    }
  }
}

import 'achievement.dart';

class UserStats {
  final int totalRecipesCooked;
  final int mealsToday;
  final int mealsThisWeek;
  final int currentStreak;
  final int totalPoints;
  final List<String> cookedRecipeIds;
  final List<String> unlockedRecipeIds; // Track manually unlocked recipes
  final DateTime? lastCookedDate;
  final Map<String, int> weeklyHistory; // date -> count
  final int totalSpins;
  final List<UserAchievement> achievements;
  final Map<String, int> cuisineCount; // cuisine -> count
  final int guideVisits;
  final String? recipeOfTheDayId;
  final DateTime? recipeOfTheDayDate;
  final int recipeOfDayCooked;
  final int longestStreak;

  UserStats({
    this.totalRecipesCooked = 0,
    this.mealsToday = 0,
    this.mealsThisWeek = 0,
    this.currentStreak = 0,
    this.totalPoints = 0,
    this.cookedRecipeIds = const [],
    this.unlockedRecipeIds = const [],
    this.lastCookedDate,
    this.weeklyHistory = const {},
    this.totalSpins = 0,
    this.achievements = const [],
    this.cuisineCount = const {},
    this.guideVisits = 0,
    this.recipeOfTheDayId,
    this.recipeOfTheDayDate,
    this.recipeOfDayCooked = 0,
    this.longestStreak = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalRecipesCooked': totalRecipesCooked,
      'mealsToday': mealsToday,
      'mealsThisWeek': mealsThisWeek,
      'currentStreak': currentStreak,
      'totalPoints': totalPoints,
      'cookedRecipeIds': cookedRecipeIds,
      'unlockedRecipeIds': unlockedRecipeIds,
      'lastCookedDate': lastCookedDate?.toIso8601String(),
      'weeklyHistory': weeklyHistory,
      'totalSpins': totalSpins,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'cuisineCount': cuisineCount,
      'guideVisits': guideVisits,
      'recipeOfTheDayId': recipeOfTheDayId,
      'recipeOfTheDayDate': recipeOfTheDayDate?.toIso8601String(),
      'recipeOfDayCooked': recipeOfDayCooked,
      'longestStreak': longestStreak,
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalRecipesCooked: json['totalRecipesCooked'] ?? 0,
      mealsToday: json['mealsToday'] ?? 0,
      mealsThisWeek: json['mealsThisWeek'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      cookedRecipeIds: List<String>.from(json['cookedRecipeIds'] ?? []),
      unlockedRecipeIds: List<String>.from(json['unlockedRecipeIds'] ?? []),
      lastCookedDate: json['lastCookedDate'] != null
          ? DateTime.parse(json['lastCookedDate'])
          : null,
      weeklyHistory: Map<String, int>.from(json['weeklyHistory'] ?? {}),
      totalSpins: json['totalSpins'] ?? 0,
      achievements: (json['achievements'] as List<dynamic>?)
              ?.map((a) => UserAchievement.fromJson(a))
              .toList() ??
          [],
      cuisineCount: Map<String, int>.from(json['cuisineCount'] ?? {}),
      guideVisits: json['guideVisits'] ?? 0,
      recipeOfTheDayId: json['recipeOfTheDayId'],
      recipeOfTheDayDate: json['recipeOfTheDayDate'] != null
          ? DateTime.parse(json['recipeOfTheDayDate'])
          : null,
      recipeOfDayCooked: json['recipeOfDayCooked'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
    );
  }

  UserStats copyWith({
    int? totalRecipesCooked,
    int? mealsToday,
    int? mealsThisWeek,
    int? currentStreak,
    int? totalPoints,
    List<String>? cookedRecipeIds,
    List<String>? unlockedRecipeIds,
    DateTime? lastCookedDate,
    Map<String, int>? weeklyHistory,
    int? totalSpins,
    List<UserAchievement>? achievements,
    Map<String, int>? cuisineCount,
    int? guideVisits,
    String? recipeOfTheDayId,
    DateTime? recipeOfTheDayDate,
    int? recipeOfDayCooked,
    int? longestStreak,
  }) {
    return UserStats(
      totalRecipesCooked: totalRecipesCooked ?? this.totalRecipesCooked,
      mealsToday: mealsToday ?? this.mealsToday,
      mealsThisWeek: mealsThisWeek ?? this.mealsThisWeek,
      currentStreak: currentStreak ?? this.currentStreak,
      totalPoints: totalPoints ?? this.totalPoints,
      cookedRecipeIds: cookedRecipeIds ?? this.cookedRecipeIds,
      unlockedRecipeIds: unlockedRecipeIds ?? this.unlockedRecipeIds,
      lastCookedDate: lastCookedDate ?? this.lastCookedDate,
      weeklyHistory: weeklyHistory ?? this.weeklyHistory,
      totalSpins: totalSpins ?? this.totalSpins,
      achievements: achievements ?? this.achievements,
      cuisineCount: cuisineCount ?? this.cuisineCount,
      guideVisits: guideVisits ?? this.guideVisits,
      recipeOfTheDayId: recipeOfTheDayId ?? this.recipeOfTheDayId,
      recipeOfTheDayDate: recipeOfTheDayDate ?? this.recipeOfTheDayDate,
      recipeOfDayCooked: recipeOfDayCooked ?? this.recipeOfDayCooked,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }
}

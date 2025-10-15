class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredCount;
  final AchievementType type;
  final int pointsReward;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredCount,
    required this.type,
    this.pointsReward = 50,
  });

  static List<Achievement> getAllAchievements() {
    return [
      // First time achievements
      Achievement(
        id: 'first_spin',
        title: 'First Spin',
        description: 'Spin the wheel for the first time',
        icon: '🎡',
        requiredCount: 1,
        type: AchievementType.spins,
        pointsReward: 25,
      ),
      Achievement(
        id: 'first_cook',
        title: 'First Cook',
        description: 'Complete your first recipe',
        icon: '👨‍🍳',
        requiredCount: 1,
        type: AchievementType.recipes,
        pointsReward: 50,
      ),
      
      // Recipe milestones
      Achievement(
        id: 'chef_apprentice',
        title: 'Chef Apprentice',
        description: 'Cook 5 different recipes',
        icon: '🥘',
        requiredCount: 5,
        type: AchievementType.recipes,
        pointsReward: 100,
      ),
      Achievement(
        id: 'home_cook',
        title: 'Home Cook',
        description: 'Cook 10 different recipes',
        icon: '🍳',
        requiredCount: 10,
        type: AchievementType.recipes,
        pointsReward: 150,
      ),
      Achievement(
        id: 'skilled_chef',
        title: 'Skilled Chef',
        description: 'Cook 25 different recipes',
        icon: '👨‍🍳',
        requiredCount: 25,
        type: AchievementType.recipes,
        pointsReward: 300,
      ),
      Achievement(
        id: 'master_chef',
        title: 'Master Chef',
        description: 'Cook 50 different recipes',
        icon: '⭐',
        requiredCount: 50,
        type: AchievementType.recipes,
        pointsReward: 500,
      ),
      
      // Streak achievements
      Achievement(
        id: 'streak_3',
        title: 'Getting Started',
        description: 'Cook for 3 days in a row',
        icon: '🔥',
        requiredCount: 3,
        type: AchievementType.streak,
        pointsReward: 75,
      ),
      Achievement(
        id: 'streak_7',
        title: 'Week Warrior',
        description: 'Cook for 7 days in a row',
        icon: '🔥',
        requiredCount: 7,
        type: AchievementType.streak,
        pointsReward: 150,
      ),
      Achievement(
        id: 'streak_14',
        title: 'Dedicated Chef',
        description: 'Cook for 14 days in a row',
        icon: '🔥',
        requiredCount: 14,
        type: AchievementType.streak,
        pointsReward: 300,
      ),
      Achievement(
        id: 'streak_30',
        title: 'Cooking Legend',
        description: 'Cook for 30 days in a row',
        icon: '🏆',
        requiredCount: 30,
        type: AchievementType.streak,
        pointsReward: 500,
      ),
      
      // Cuisine diversity
      Achievement(
        id: 'world_explorer',
        title: 'World Explorer',
        description: 'Cook recipes from 5 different cuisines',
        icon: '🌍',
        requiredCount: 5,
        type: AchievementType.cuisines,
        pointsReward: 200,
      ),
      Achievement(
        id: 'global_chef',
        title: 'Global Chef',
        description: 'Cook recipes from 8 different cuisines',
        icon: '🌎',
        requiredCount: 8,
        type: AchievementType.cuisines,
        pointsReward: 350,
      ),
      
      // Speed achievements
      Achievement(
        id: 'speed_demon',
        title: 'Speed Demon',
        description: 'Complete a recipe 5 minutes faster than estimated',
        icon: '⚡',
        requiredCount: 1,
        type: AchievementType.speed,
        pointsReward: 100,
      ),
      
      // Guide usage
      Achievement(
        id: 'knowledge_seeker',
        title: 'Knowledge Seeker',
        description: 'Visit the Kitchen Guide 10 times',
        icon: '📚',
        requiredCount: 10,
        type: AchievementType.guideVisits,
        pointsReward: 100,
      ),
      
      // Recipe of the day
      Achievement(
        id: 'daily_chef',
        title: 'Daily Chef',
        description: 'Cook 5 Recipes of the Day',
        icon: '⭐',
        requiredCount: 5,
        type: AchievementType.recipeOfDay,
        pointsReward: 200,
      ),
    ];
  }
}

enum AchievementType {
  spins,
  recipes,
  streak,
  cuisines,
  speed,
  guideVisits,
  recipeOfDay,
}

class UserAchievement {
  final String achievementId;
  final DateTime unlockedAt;
  final bool seen;
  final bool claimed;

  UserAchievement({
    required this.achievementId,
    required this.unlockedAt,
    this.seen = false,
    this.claimed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'achievementId': achievementId,
      'unlockedAt': unlockedAt.toIso8601String(),
      'seen': seen,
      'claimed': claimed,
    };
  }

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      achievementId: json['achievementId'],
      unlockedAt: DateTime.parse(json['unlockedAt']),
      seen: json['seen'] ?? false,
      claimed: json['claimed'] ?? false,
    );
  }

  UserAchievement copyWith({bool? seen, bool? claimed}) {
    return UserAchievement(
      achievementId: achievementId,
      unlockedAt: unlockedAt,
      seen: seen ?? this.seen,
      claimed: claimed ?? this.claimed,
    );
  }
}

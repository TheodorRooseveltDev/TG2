import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/achievement.dart';
import '../models/user_stats.dart';
import '../services/data_service.dart';
import '../services/achievement_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  UserStats _stats = UserStats();
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _dataService.getUserStats();
    setState(() {
      _stats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allAchievements = Achievement.getAllAchievements();
    final unlockedIds = _stats.achievements.map((a) => a.achievementId).toSet();
    
    final unlockedAchievements = allAchievements
        .where((a) => unlockedIds.contains(a.id))
        .toList();
    
    final lockedAchievements = allAchievements
        .where((a) => !unlockedIds.contains(a.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Summary
            Container(
              margin: const EdgeInsets.all(AppTheme.spacingL),
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.secondary.withOpacity(0.15),
                    AppTheme.accent.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(
                  color: AppTheme.secondary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    context,
                    icon: '🏆',
                    value: '${unlockedAchievements.length}',
                    label: 'Unlocked',
                    color: AppTheme.secondary,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppTheme.divider,
                  ),
                  _buildSummaryItem(
                    context,
                    icon: '🔒',
                    value: '${lockedAchievements.length}',
                    label: 'Locked',
                    color: AppTheme.textSecondary,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppTheme.divider,
                  ),
                  _buildSummaryItem(
                    context,
                    icon: '⭐',
                    value: '${_stats.totalPoints}',
                    label: 'Total Points',
                    color: AppTheme.warning,
                  ),
                ],
              ),
            ),

            // Achievements List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                children: [
                  if (unlockedAchievements.isNotEmpty) ...[
                    Text(
                      'Unlocked',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    ...unlockedAchievements.map((achievement) {
                      final userAchievement = _stats.achievements.firstWhere(
                        (a) => a.achievementId == achievement.id,
                      );
                      return _buildAchievementCard(
                        achievement,
                        isUnlocked: true,
                        isClaimed: userAchievement.claimed,
                        unlockedAt: userAchievement.unlockedAt,
                      );
                    }),
                    const SizedBox(height: AppTheme.spacingL),
                  ],
                  if (lockedAchievements.isNotEmpty) ...[
                    Text(
                      'Locked',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    ...lockedAchievements.map((achievement) {
                      final progress = AchievementService.getAchievementProgress(
                        achievement,
                        _stats,
                      );
                      return _buildAchievementCard(
                        achievement,
                        isUnlocked: false,
                        progress: progress,
                      );
                    }),
                  ],
                  const SizedBox(height: AppTheme.spacingXL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(
    Achievement achievement, {
    required bool isUnlocked,
    bool isClaimed = false,
    DateTime? unlockedAt,
    double? progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: BoxDecoration(
        color: isUnlocked ? AppTheme.surface : AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.secondary.withOpacity(0.3)
              : AppTheme.divider,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: AppTheme.secondary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppTheme.secondary.withOpacity(0.15)
                    : AppTheme.divider,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 32,
                    color: isUnlocked ? null : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isUnlocked
                                    ? AppTheme.textPrimary
                                    : AppTheme.textSecondary,
                              ),
                        ),
                      ),
                      if (isUnlocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingS,
                            vertical: AppTheme.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.success,
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    achievement.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isUnlocked
                              ? AppTheme.textSecondary
                              : AppTheme.textLight,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  
                  if (isUnlocked) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppTheme.warning,
                        ),
                        const SizedBox(width: AppTheme.spacingXS),
                        Text(
                          '+${achievement.pointsReward} points',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.warning,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        if (unlockedAt != null)
                          Text(
                            _formatDate(unlockedAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                      ],
                    ),
                    if (!isClaimed) ...[
                      const SizedBox(height: AppTheme.spacingM),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _dataService.claimAchievement(
                              achievement.id,
                              achievement.pointsReward,
                            );
                            await _loadStats();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.white),
                                      const SizedBox(width: AppTheme.spacingS),
                                      Text(
                                        'Claimed +${achievement.pointsReward} points!',
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppTheme.success,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacingM,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, size: 20),
                              const SizedBox(width: AppTheme.spacingS),
                              Text(
                                'Claim ${achievement.pointsReward} Points',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ] else if (progress != null) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  backgroundColor: AppTheme.divider,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingS),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: AppTheme.spacingXS),
                            Text(
                              '${achievement.pointsReward} points when unlocked',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

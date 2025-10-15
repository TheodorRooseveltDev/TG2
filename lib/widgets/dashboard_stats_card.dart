import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_stats.dart';
import '../widgets/custom_icon.dart';

class DashboardStatsCard extends StatelessWidget {
  final UserStats stats;

  const DashboardStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              icon: CustomIcon.trophy,
              value: '${stats.cookedRecipeIds.length}',
              label: 'Recipes',
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: _buildStatCard(
              context,
              icon: CustomIcon.fire,
              value: '${stats.currentStreak}',
              label: 'Day Streak',
              color: AppTheme.warning,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: _buildStatCard(
              context,
              icon: CustomIcon.star,
              value: '${stats.mealsThisWeek}',
              label: 'This Week',
              color: AppTheme.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          CustomIcon(
            iconName: icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

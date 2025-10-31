import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_preferences.dart';
import '../models/user_stats.dart';
import '../services/data_service.dart';
import '../screens/achievements_screen.dart';
import 'webview_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DataService _dataService = DataService();
  UserPreferences _preferences = UserPreferences();
  UserStats _stats = UserStats();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadStats();
  }

  Future<void> _loadPreferences() async {
    final prefs = await _dataService.getUserPreferences();
    setState(() {
      _preferences = prefs;
    });
  }

  Future<void> _loadStats() async {
    final stats = await _dataService.getUserStats();
    setState(() {
      _stats = stats;
    });
  }

  Future<void> _savePreferences(UserPreferences prefs) async {
    await _dataService.saveUserPreferences(prefs);
    setState(() {
      _preferences = prefs;
    });
  }

  Future<void> _resetProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        contentPadding: const EdgeInsets.all(AppTheme.spacingL),
        title: const Text('Reset Progress'),
        content: const SizedBox(
          width: 700,
          child: Text(
            'Are you sure you want to reset all your cooking progress? This action cannot be undone.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dataService.resetProgress();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progress reset successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          children: [
            // Achievements Section
            Text('Progress', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppTheme.spacingM),

            _buildSettingCard(
              'Achievements',
              '${_stats.achievements.where((a) => a.claimed).length}/${_stats.achievements.length} claimed',
              Stack(
                children: [
                  const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textSecondary,
                  ),
                  if (_dataService.hasUnclaimedAchievements(_stats))
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => const AchievementsScreen(),
                      ),
                    )
                    .then((_) {
                      _loadStats();
                    });
              },
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Preferences Section
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),

            _buildSettingCard(
              'Sound Effects',
              'Play sounds during interactions',
              Switch(
                value: _preferences.soundEffects,
                onChanged: (value) {
                  _savePreferences(_preferences.copyWith(soundEffects: value));
                },
                activeThumbColor: AppTheme.secondary,
              ),
            ),

            const SizedBox(height: AppTheme.spacingS),

            _buildSettingCard(
              'Vibration',
              'Vibrate on notifications and timers',
              Switch(
                value: _preferences.vibration,
                onChanged: (value) {
                  _savePreferences(_preferences.copyWith(vibration: value));
                },
                activeThumbColor: AppTheme.secondary,
              ),
            ),

            const SizedBox(height: AppTheme.spacingS),

            _buildSettingCard(
              'Notifications',
              'Receive push notifications',
              Switch(
                value: _preferences.notifications,
                onChanged: (value) {
                  _savePreferences(_preferences.copyWith(notifications: value));
                },
                activeThumbColor: AppTheme.secondary,
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Profile Section
            Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppTheme.spacingM),

            _buildSettingCard(
              'Skill Level',
              _preferences.skillLevel,
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () => _showSkillLevelDialog(),
            ),

            const SizedBox(height: AppTheme.spacingS),

            _buildSettingCard(
              'Dietary Preferences',
              _preferences.dietaryTypes.isEmpty
                  ? 'Not set'
                  : _preferences.dietaryTypes.join(', '),
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () => _showDietaryPreferencesDialog(),
            ),

            const SizedBox(height: AppTheme.spacingS),

            _buildSettingCard(
              'Allergens',
              _preferences.allergens.isEmpty
                  ? 'None'
                  : _preferences.allergens.join(', '),
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () => _showAllergensDialog(),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Data Section
            Text('Data', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppTheme.spacingM),

            _buildDangerButton(
              'Reset Progress',
              'Clear all cooking history and statistics',
              Icons.delete_forever,
              _resetProgress,
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // About Section
            Text('About', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppTheme.spacingM),

            _buildSettingCard('Version', '1.0.0', const SizedBox()),

            const SizedBox(height: AppTheme.spacingS),

            _buildSettingCard(
              'Privacy Policy',
              'View our privacy policy',
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () => _showPrivacyPolicy(),
            ),

            const SizedBox(height: AppTheme.spacingS),

            _buildSettingCard(
              'Terms & Conditions',
              'View terms and conditions',
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () => _showTermsAndConditions(),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Footer
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 48,
                    color: AppTheme.secondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Sweet Spin \'n\' Cook',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    'Making cooking fun and spontaneous',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    String title,
    String subtitle,
    Widget trailing, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDangerButton(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(color: AppTheme.error.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.error),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: AppTheme.error),
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.error),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppTheme.error),
          ],
        ),
      ),
    );
  }

  Future<void> _showSkillLevelDialog() async {
    final options = ['Beginner', 'Intermediate', 'Expert'];
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        contentPadding: const EdgeInsets.all(AppTheme.spacingL),
        title: const Text('Select Skill Level'),
        content: SizedBox(
          width: 700,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _preferences.skillLevel,
                onChanged: (value) {
                  Navigator.of(context).pop(value);
                },
                activeColor: AppTheme.secondary,
              );
            }).toList(),
          ),
        ),
      ),
    );

    if (selected != null) {
      _savePreferences(_preferences.copyWith(skillLevel: selected));
    }
  }

  Future<void> _showDietaryPreferencesDialog() async {
    final options = [
      'Vegetarian',
      'Vegan',
      'Pescatarian',
      'Gluten-Free',
      'Dairy-Free',
      'Keto',
      'Paleo',
      'Low-Carb',
    ];

    final selectedItems = List<String>.from(_preferences.dietaryTypes);

    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          contentPadding: const EdgeInsets.all(AppTheme.spacingL),
          title: const Text('Dietary Preferences'),
          content: SizedBox(
            width: 750,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((option) {
                  return CheckboxListTile(
                    title: Text(option),
                    value: selectedItems.contains(option),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          selectedItems.add(option);
                        } else {
                          selectedItems.remove(option);
                        }
                      });
                    },
                    activeColor: AppTheme.secondary,
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(selectedItems),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      _savePreferences(_preferences.copyWith(dietaryTypes: result));
    }
  }

  Future<void> _showAllergensDialog() async {
    final options = [
      'Peanuts',
      'Tree Nuts',
      'Milk',
      'Eggs',
      'Wheat',
      'Soy',
      'Fish',
      'Shellfish',
      'Sesame',
    ];

    final selectedItems = List<String>.from(_preferences.allergens);

    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          contentPadding: const EdgeInsets.all(AppTheme.spacingL),
          title: const Text('Allergens'),
          content: SizedBox(
            width: 750,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((option) {
                  return CheckboxListTile(
                    title: Text(option),
                    value: selectedItems.contains(option),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          selectedItems.add(option);
                        } else {
                          selectedItems.remove(option);
                        }
                      });
                    },
                    activeColor: AppTheme.error,
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(selectedItems),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      _savePreferences(_preferences.copyWith(allergens: result));
    }
  }

  void _showPrivacyPolicy() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WebViewScreen(
          title: 'Privacy Policy',
          url: 'https://sweetspinandcook.com/privacy/',
        ),
      ),
    );
  }

  void _showTermsAndConditions() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WebViewScreen(
          title: 'Terms & Conditions',
          url: 'https://sweetspinandcook.com/terms/',
        ),
      ),
    );
  }
}

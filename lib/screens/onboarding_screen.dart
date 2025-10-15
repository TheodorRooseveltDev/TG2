import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_preferences.dart';
import '../services/data_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Preferences
  final List<String> _selectedDietaryTypes = [];
  final List<String> _selectedAllergens = [];
  String _skillLevel = 'Beginner';
  final List<String> _selectedCuisines = [];

  final List<String> _dietaryOptions = [
    'Vegan',
    'Vegetarian',
    'Pescatarian',
    'Gluten-Free',
    'Dairy-Free',
    'Keto',
    'Paleo',
  ];

  final List<String> _allergenOptions = [
    'Eggs',
    'Dairy',
    'Gluten',
    'Nuts',
    'Soy',
    'Shellfish',
    'Fish',
    'Sesame',
  ];

  final List<String> _cuisineOptions = [
    'Italian',
    'Asian',
    'Chinese',
    'Indian',
    'Mediterranean',
    'Mexican',
    'French',
    'Greek',
    'Healthy',
    'Dessert',
  ];

  final List<String> _skillOptions = ['Beginner', 'Intermediate', 'Expert'];

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    final preferences = UserPreferences(
      dietaryTypes: _selectedDietaryTypes.map((e) => e.toLowerCase()).toList(),
      allergens: _selectedAllergens.map((e) => e.toLowerCase()).toList(),
      skillLevel: _skillLevel,
      preferredCuisines: _selectedCuisines,
    );

    final dataService = DataService();
    await dataService.saveUserPreferences(preferences);
    await dataService.setOnboardingComplete(true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(
                        right: index < 3 ? AppTheme.spacingS : 0,
                      ),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? AppTheme.secondary
                            : AppTheme.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildDietaryPage(),
                  _buildAllergensPage(),
                  _buildSkillAndCuisinePage(),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    OutlinedButton(
                      onPressed: _previousPage,
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(_currentPage == 3 ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppTheme.spacingL),
            // Welcome chef illustration
            Image.asset(
              'assets/images/illustrations/welcome_chef.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to icon if image not found
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 60,
                    color: AppTheme.secondary,
                  ),
                );
              },
            ),
            const SizedBox(height: AppTheme.spacingXL),
            Text(
              'Welcome to Sweet Spin \'n\' Cook',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Turn cooking into a game of chance!\nSpin, discover, and cook delicious recipes.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXL),
            _buildFeatureItem(
              Icons.refresh,
              'Spin the Wheel',
              'Discover random recipes with every spin',
            ),
            const SizedBox(height: AppTheme.spacingM),
            _buildFeatureItem(
              Icons.timer,
              'Step-by-Step Cooking',
              'Follow guided instructions with built-in timers',
            ),
            const SizedBox(height: AppTheme.spacingM),
            _buildFeatureItem(
              Icons.trending_up,
              'Track Progress',
              'Build streaks and unlock new recipes',
            ),
            const SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(icon, color: AppTheme.secondary, size: 24),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDietaryPage() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dietary Preferences',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Select any dietary types that apply to you (optional)',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Expanded(
            child: Wrap(
              spacing: AppTheme.spacingM,
              runSpacing: AppTheme.spacingM,
              children: _dietaryOptions.map((option) {
                final isSelected = _selectedDietaryTypes.contains(option);
                return _buildOptionChip(
                  option,
                  isSelected,
                  () {
                    setState(() {
                      if (isSelected) {
                        _selectedDietaryTypes.remove(option);
                      } else {
                        _selectedDietaryTypes.add(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergensPage() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Allergens',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Select any allergens to avoid in recipes',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Expanded(
            child: Wrap(
              spacing: AppTheme.spacingM,
              runSpacing: AppTheme.spacingM,
              children: _allergenOptions.map((option) {
                final isSelected = _selectedAllergens.contains(option);
                return _buildOptionChip(
                  option,
                  isSelected,
                  () {
                    setState(() {
                      if (isSelected) {
                        _selectedAllergens.remove(option);
                      } else {
                        _selectedAllergens.add(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillAndCuisinePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cooking Skill Level',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'This helps us recommend appropriate recipes',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingM,
            children: _skillOptions.map((option) {
              final isSelected = _skillLevel == option;
              return _buildOptionChip(
                option,
                isSelected,
                () {
                  setState(() {
                    _skillLevel = option;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Text(
            'Preferred Cuisines',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Select your favorite cuisines (optional)',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            children: _cuisineOptions.map((option) {
              final isSelected = _selectedCuisines.contains(option);
              return _buildOptionChip(
                option,
                isSelected,
                () {
                  setState(() {
                    if (isSelected) {
                      _selectedCuisines.remove(option);
                    } else {
                      _selectedCuisines.add(option);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.secondary : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: isSelected ? AppTheme.secondary : AppTheme.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

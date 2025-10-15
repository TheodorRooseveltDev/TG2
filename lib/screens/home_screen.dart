import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_stats.dart';
import '../models/recipe.dart';
import '../services/data_service.dart';
import '../services/recipe_service.dart';
import '../services/achievement_service.dart';
import 'spin_screen.dart';
import 'recipes_screen.dart';
import 'kitchen_guide_screen.dart';
import 'settings_screen.dart';
import '../widgets/custom_icon.dart';
import '../widgets/dashboard_stats_card.dart';
import '../widgets/recipe_of_day_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  UserStats _stats = UserStats();
  final DataService _dataService = DataService();
  late AnimationController _blob1Controller;
  late AnimationController _blob2Controller;
  late AnimationController _blob3Controller;
  Recipe? _recipeOfTheDay;
  bool _isLoadingRecipe = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
    
    // Initialize animation controllers for blobs
    _blob1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    
    _blob2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    
    _blob3Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blob1Controller.dispose();
    _blob2Controller.dispose();
    _blob3Controller.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final stats = await _dataService.getUserStats();
    
    // Load recipe of the day
    final allRecipes = RecipeService.getAllRecipes();
    final recipeId = await _dataService.getRecipeOfTheDay(allRecipes);
    final recipe = allRecipes.firstWhere((r) => r.id == recipeId);
    
    setState(() {
      _stats = stats;
      _recipeOfTheDay = recipe;
      _isLoadingRecipe = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeTab(),
      const RecipesScreen(),
      const KitchenGuideScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.divider, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              _loadStats();
            }
            if (index == 3) {
              _loadStats();
            }
          },
          selectedItemColor: AppTheme.secondary,
          unselectedItemColor: AppTheme.textSecondary,
          backgroundColor: AppTheme.surface,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Recipes',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Guide',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.settings),
                  if (_dataService.hasUnclaimedAchievements(_stats))
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppTheme.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Stack(
      children: [
        // Animated background blobs
        AnimatedBuilder(
          animation: _blob1Controller,
          builder: (context, child) {
            return Positioned(
              top: -100 + (_blob1Controller.value * 50),
              right: -50 + (_blob1Controller.value * 30),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.secondary.withOpacity(0.15),
                      AppTheme.secondary.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _blob2Controller,
          builder: (context, child) {
            return Positioned(
              bottom: -80 + (_blob2Controller.value * 40),
              left: -80 + (_blob2Controller.value * 60),
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accent.withOpacity(0.15),
                      AppTheme.accent.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _blob3Controller,
          builder: (context, child) {
            return Positioned(
              top: 200 + (_blob3Controller.value * 80),
              left: -30 + (_blob3Controller.value * 40),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.success.withOpacity(0.1),
                      AppTheme.success.withOpacity(0.03),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        
        // Main content
        SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.divider, width: 1),
                  ),
                ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sweet Spin \'n\' Cook',
                          style: Theme.of(context).textTheme.displayMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Text(
                          'What will you cook today?',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  // Points Display
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    ),
                    child: Row(
                      children: [
                        const CustomIcon(
                          iconName: CustomIcon.star,
                          size: 24,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Text(
                          '${_stats.totalPoints}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Motivational Message
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.secondary.withOpacity(0.1),
                            AppTheme.accent.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(
                          color: AppTheme.secondary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacingS),
                            decoration: BoxDecoration(
                              color: AppTheme.secondary.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: AppTheme.secondary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                          Expanded(
                            child: Text(
                              AchievementService.getMotivationalMessage(_stats),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Dashboard Stats Cards
                  DashboardStatsCard(stats: _stats),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Main CTA - Spin & Cook Button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SpinScreen(),
                        ),
                      ).then((_) => _loadStats());
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.secondary,
                            AppTheme.secondaryLight,
                            AppTheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.secondary.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.refresh_rounded,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Text(
                              'SPIN &',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                            ),
                            Text(
                              'COOK',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  Text(
                    'Discover your next delicious meal!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Recipe of the Day
                  if (!_isLoadingRecipe && _recipeOfTheDay != null)
                    RecipeOfTheDayCard(
                      recipe: _recipeOfTheDay!,
                      isCompleted: _stats.cookedRecipeIds.contains(_recipeOfTheDay!.id),
                      onRefresh: _loadStats,
                    ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Level Progress
                  _buildLevelProgress(),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ],
);
}

Widget _buildLevelProgress() {
  final levelInfo = AchievementService.getUserLevel(_stats.totalPoints);
  
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
    padding: const EdgeInsets.all(AppTheme.spacingL),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      border: Border.all(color: AppTheme.divider),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  levelInfo['icon'],
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      levelInfo['level'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (levelInfo['nextLevel'] != null)
                      Text(
                        '${levelInfo['pointsToNext']} pts to ${levelInfo['nextLevel']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                  ],
                ),
              ],
            ),
            Text(
              '${_stats.totalPoints} pts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        if (levelInfo['nextLevel'] != null) ...[
          const SizedBox(height: AppTheme.spacingM),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            child: LinearProgressIndicator(
              value: levelInfo['progress'],
              minHeight: 8,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondary),
            ),
          ),
        ],
      ],
    ),
  );
}
}

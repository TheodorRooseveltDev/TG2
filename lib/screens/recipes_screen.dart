import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/recipe.dart';
import '../models/user_stats.dart';
import '../services/recipe_service.dart';
import '../services/data_service.dart';
import 'recipe_detail_screen.dart';
import '../widgets/custom_icon.dart';
import '../widgets/unlock_animation.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<Recipe> _recipes = [];
  UserStats _stats = UserStats();
  bool _showUnlockAnimation = false;
  Offset _animationStartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dataService = DataService();
    final stats = await dataService.getUserStats();
    final recipes = RecipeService.getAllRecipes();

    setState(() {
      _stats = stats;
      _recipes = recipes;
    });
  }

  Future<void> _unlockRecipe(Recipe recipe, BuildContext buttonContext) async {
    // Get the button position
    final RenderBox box = buttonContext.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    
    setState(() {
      _animationStartPosition = Offset(
        position.dx + box.size.width / 2 - 30, // Center the lock icon
        position.dy,
      );
      _showUnlockAnimation = true;
    });

    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 1000));

    // Update user stats - deduct points and add to unlocked recipes
    final dataService = DataService();
    final updatedUnlockedIds = List<String>.from(_stats.unlockedRecipeIds)
      ..add(recipe.id);
    
    final newStats = _stats.copyWith(
      totalPoints: _stats.totalPoints - recipe.pointsRequired,
      unlockedRecipeIds: updatedUnlockedIds,
    );
    await dataService.saveUserStats(newStats);

    setState(() {
      _showUnlockAnimation = false;
    });

    // Reload data to reflect changes
    await _loadData();

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.lock_open, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text('${recipe.name} unlocked! 🎉'),
              ),
            ],
          ),
          backgroundColor: AppTheme.success,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _recipes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      
                      // Recipe is unlocked if: 
                      // 1. It's not locked by default, OR
                      // 2. User has manually unlocked it
                      final isUnlocked = !recipe.isLocked || 
                          _stats.unlockedRecipeIds.contains(recipe.id);
                      
                      final isCooked = _stats.cookedRecipeIds.contains(recipe.id);
                      
                      // Can unlock if: has enough points AND hasn't unlocked yet
                      final canUnlock = recipe.isLocked &&
                          !_stats.unlockedRecipeIds.contains(recipe.id) &&
                          _stats.totalPoints >= recipe.pointsRequired;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                        child: _buildRecipeCard(recipe, isUnlocked, isCooked, canUnlock),
                      );
                    },
                  ),
            
            // Unlock animation overlay
            if (_showUnlockAnimation)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: UnlockAnimation(
                    startPosition: _animationStartPosition,
                    onComplete: () {},
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe, bool isUnlocked, bool isCooked, bool canUnlock) {
    return GestureDetector(
      onTap: isUnlocked
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipe: recipe),
                ),
              ).then((_) => _loadData());
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: isUnlocked ? AppTheme.divider : AppTheme.textLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Stack(
              children: [
                Image.asset(
                  recipe.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback gradient if image not found
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.secondary.withOpacity(0.2),
                            AppTheme.accent.withOpacity(0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: isUnlocked
                                  ? const Icon(
                                      Icons.restaurant,
                                      size: 48,
                                      color: AppTheme.secondary,
                                    )
                                  : const CustomIcon(
                                      iconName: CustomIcon.lock,
                                      size: 48,
                                    ),
                            ),
                            const SizedBox(height: 8),
                            if (isUnlocked)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  recipe.cuisines.isNotEmpty ? recipe.cuisines.first : 'Delicious',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (isCooked)
                  Positioned(
                    top: AppTheme.spacingS,
                    right: AppTheme.spacingS,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: AppTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: AppTheme.spacingXS),
                          Text(
                            'Cooked',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!isUnlocked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.radiusSmall),
                          topRight: Radius.circular(AppTheme.radiusSmall),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CustomIcon(
                            iconName: CustomIcon.lock,
                            size: 64,
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Text(
                            '${recipe.pointsRequired} points required',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          if (canUnlock) ...[
                            const SizedBox(height: AppTheme.spacingS),
                            Builder(
                              builder: (buttonContext) => ElevatedButton.icon(
                                onPressed: () => _unlockRecipe(recipe, buttonContext),
                                icon: const Icon(Icons.lock_open, size: 20),
                                label: const Text(
                                  'Unlock Now!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.secondary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 8,
                                  shadowColor: AppTheme.secondary.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ] else
                            Text(
                              'You have ${_stats.totalPoints} points',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Recipe info
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Row(
                    children: [
                      _buildInfoChip(
                        CustomIcon.timer,
                        '${recipe.totalTime} min',
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      _buildInfoChip(
                        Icons.signal_cellular_alt,
                        recipe.difficulty,
                      ),
                      if (recipe.cuisines.isNotEmpty) ...[
                        const SizedBox(width: AppTheme.spacingS),
                        _buildInfoChip(
                          Icons.public,
                          recipe.cuisines.first,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(dynamic icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon is String
              ? CustomIcon(
                  iconName: icon,
                  size: 14,
                )
              : Icon(icon as IconData, size: 14, color: AppTheme.textSecondary),
          const SizedBox(width: AppTheme.spacingXS),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

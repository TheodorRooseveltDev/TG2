import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../services/data_service.dart';
import 'cooking_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/custom_icon.dart';

class SpinScreen extends StatefulWidget {
  const SpinScreen({super.key});

  @override
  State<SpinScreen> createState() => _SpinScreenState();
}

class _SpinScreenState extends State<SpinScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _cardController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  List<Recipe> _recipes = [];
  Recipe? _selectedRecipe;
  bool _isSpinning = false;
  bool _showResult = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    final dataService = DataService();
    final prefs = await dataService.getUserPreferences();
    final stats = await dataService.getUserStats();
    
    final allRecipes = RecipeService.getAllRecipes();
    
    List<Recipe> filtered = RecipeService.getFilteredRecipes(
      allRecipes,
      prefs.allergens,
      prefs.dietaryTypes,
      prefs.preferredCuisines.isEmpty ? [] : prefs.preferredCuisines,
    );

    // Only include recipes that are:
    // 1. Not locked, OR
    // 2. Have been manually unlocked by the user
    filtered = filtered.where((recipe) {
      if (recipe.isLocked) {
        return stats.unlockedRecipeIds.contains(recipe.id);
      }
      return true;
    }).toList();

    if (filtered.isEmpty) {
      filtered = allRecipes.where((r) => !r.isLocked).toList();
    }

    setState(() {
      _recipes = filtered;
    });
  }

  void _spinWheel() {
    if (_isSpinning || _recipes.isEmpty) return;

    // Track spin
    final dataService = DataService();
    dataService.incrementSpins();

    final numSlices = _recipes.length;
    final targetIndex = _random.nextInt(numSlices);
    
    final displayRecipes = _recipes.length >= 8 
        ? _recipes 
        : List<Recipe>.generate(
            8, 
            (index) => _recipes[index % _recipes.length]
          );
    
    final displayNumSlices = displayRecipes.length;
    final displayAnglePerSlice = (2 * pi) / displayNumSlices;
    
    int visualTargetIndex = targetIndex;
    for (int i = 0; i < displayRecipes.length; i++) {
      if (displayRecipes[i].id == _recipes[targetIndex].id) {
        visualTargetIndex = i;
        break;
      }
    }
    
    final targetRotation = (2 * pi) - (displayAnglePerSlice * (visualTargetIndex + 0.5));
    
    final extraSpins = 5 + _random.nextDouble() * 2;
    final finalRotation = (extraSpins * 2 * pi) + targetRotation;

    setState(() {
      _isSpinning = true;
      _showResult = false;
      _selectedRecipe = null;
    });
    
    _cardController.reset();

    _animation = Tween<double>(
      begin: 0.0,
      end: finalRotation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.reset();
    _controller.forward().then((_) {
      final finalAngle = finalRotation % (2 * pi);
      final rawSliceValue = ((2 * pi - finalAngle) / displayAnglePerSlice) - 0.5;
      final sliceAtPointer = rawSliceValue.round() % displayNumSlices;
      
      setState(() {
        _selectedRecipe = displayRecipes[sliceAtPointer];
        _isSpinning = false;
        _showResult = true;
      });
      
      _cardController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spin & Cook'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _recipes.isEmpty
            ? EmptyStateWidget(
                title: 'No Recipes Available',
                message: 'We could not find any recipes matching your preferences. Try adjusting your settings.',
                actionLabel: 'Go to Settings',
                onAction: () {
                  Navigator.pop(context);
                },
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: AppTheme.spacingL),
                      
                      if (!_showResult) ...[
                        Text(
                          '${_recipes.length} Unlocked Recipes',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap the wheel to spin!',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textLight,
                              ),
                        ),
                      ],
                      
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 320,
                            height: 320,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _animation.value,
                                      child: child,
                                    );
                                  },
                                  child: _buildWheel(),
                                ),
                                
                                Positioned(
                                  top: -5,
                                  child: CustomPaint(
                                    size: const Size(40, 50),
                                    painter: _PointerPainter(),
                                  ),
                                ),
                                
                                _buildCenterButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      if (!_showResult)
                        _buildSpinButton(),
                    ],
                  ),
                  
                  if (_showResult && _selectedRecipe != null)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: _buildResultCard(),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Center(
      child: GestureDetector(
        onTap: _spinWheel,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondary.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWheel() {
    // Use either actual recipes or padded list for visual appeal
    final displayRecipes = _recipes.length >= 8 
        ? _recipes 
        : List<Recipe>.generate(
            8, 
            (index) => _recipes[index % _recipes.length]
          );
    
    final numSlices = displayRecipes.length;
    
    return Container(
      width: 320,
      height: 320,
      child: Stack(
        children: [
          // Draw all slices with images
          ...List.generate(numSlices, (index) {
            final angle = (2 * pi / numSlices) * index;
            return Transform.rotate(
              angle: angle,
              child: ClipPath(
                clipper: _SliceClipper(numSlices),
                child: _buildImageSlice(displayRecipes[index]),
              ),
            );
          }),
          // Draw white borders on top
          CustomPaint(
            painter: _WheelBorderPainter(numSlices),
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlice(Recipe recipe) {
    return SizedBox(
      width: 320,
      height: 320,
      child: Image.asset(
        recipe.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.secondary.withOpacity(0.7),
                  AppTheme.accent.withOpacity(0.7),
                ],
              ),
            ),
            child: Center(
              child: Text(
                recipe.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpinButton() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isSpinning ? null : _spinWheel,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            elevation: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSpinning)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              if (_isSpinning)
                const SizedBox(width: 12),
              Text(
                _isSpinning ? 'Spinning...' : 'Spin the Wheel',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_selectedRecipe == null) return const SizedBox();

    return Container(
      constraints: BoxConstraints(
        maxWidth: 380,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusLarge),
                topRight: Radius.circular(AppTheme.radiusLarge),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    _selectedRecipe!.imagePath,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.secondary,
                              AppTheme.accent,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 60,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomIcon(
                            iconName: CustomIcon.star,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'New',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedRecipe!.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  Text(
                    _selectedRecipe!.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  Row(
                    children: [
                      _buildInfoChip(
                        CustomIcon.timer,
                        '${_selectedRecipe!.totalTime} min',
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      _buildInfoChip(
                        Icons.signal_cellular_alt,
                        _selectedRecipe!.difficulty,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _showResult = false;
                              _selectedRecipe = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.secondary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Spin Again',
                            style: TextStyle(
                              color: AppTheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CookingScreen(recipe: _selectedRecipe!),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Start Cooking',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildInfoChip(dynamic icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon is String
              ? CustomIcon(
                  iconName: icon,
                  size: 16,
                )
              : Icon(
                  icon as IconData,
                  size: 16,
                  color: AppTheme.secondary,
                ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _SliceClipper extends CustomClipper<Path> {
  final int numSlices;

  _SliceClipper(this.numSlices);

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final angle = (2 * pi) / numSlices;

    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx, center.dy - radius);
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_SliceClipper oldClipper) => numSlices != oldClipper.numSlices;
}

class _WheelBorderPainter extends CustomPainter {
  final int numSlices;

  _WheelBorderPainter(this.numSlices);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final anglePerSlice = (2 * pi) / numSlices;

    // Draw white borders between slices (thicker)
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6; // Increased from 3 to 6

    for (int i = 0; i < numSlices; i++) {
      final angle = (i * anglePerSlice) - (pi / 2);
      final borderPath = Path();
      borderPath.moveTo(center.dx, center.dy);
      borderPath.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawPath(borderPath, borderPaint);
    }

    // Draw outer circle border (thicker)
    final outerBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8; // Increased from 4 to 8

    canvas.drawCircle(center, radius, outerBorderPaint);
  }

  @override
  bool shouldRepaint(_WheelBorderPainter oldDelegate) => false;
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.secondary
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

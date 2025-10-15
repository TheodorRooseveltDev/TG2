import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../models/recipe.dart';
import '../models/achievement.dart';
import '../services/data_service.dart';
import '../services/achievement_service.dart';
import '../widgets/lottie_animation.dart';
import '../widgets/achievement_unlock_dialog.dart';
import '../widgets/custom_icon.dart';

class CookingScreen extends StatefulWidget {
  final Recipe recipe;

  const CookingScreen({super.key, required this.recipe});

  @override
  State<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> with SingleTickerProviderStateMixin {
  int _currentStepIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;
  final Set<int> _completedSteps = {};
  late AnimationController _celebrationController;

  RecipeStep get _currentStep => widget.recipe.steps[_currentStepIndex];

  @override
  void initState() {
    super.initState();
    // Initialize celebration animation controller for smooth playback
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 3 seconds for smooth celebration
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _celebrationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_currentStep.duration == 0) return;

    setState(() {
      _remainingSeconds = _currentStep.duration;
      _isTimerRunning = true;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _pauseTimer();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _finishStep() {
    setState(() {
      _completedSteps.add(_currentStepIndex);
    });
    _timer?.cancel();
    _isTimerRunning = false;

    if (_currentStepIndex < widget.recipe.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _remainingSeconds = 0;
      });
    } else {
      _completeRecipe();
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      _timer?.cancel();
      setState(() {
        _currentStepIndex--;
        _remainingSeconds = 0;
        _isTimerRunning = false;
      });
    }
  }

  Future<void> _completeRecipe() async {
    // Award points based on difficulty
    int points = 0;
    switch (widget.recipe.difficulty) {
      case 'Easy':
        points = 10;
        break;
      case 'Medium':
        points = 20;
        break;
      case 'Hard':
        points = 30;
        break;
    }

    final dataService = DataService();
    final previousStats = await dataService.getUserStats();
    final cuisine = widget.recipe.cuisines.isNotEmpty ? widget.recipe.cuisines.first : 'Other';
    final newStats = await dataService.completeRecipe(widget.recipe.id, points, cuisine);

    // Check for new achievements
    final newAchievements = <Achievement>[];
    for (final userAchievement in newStats.achievements) {
      final wasUnlocked = previousStats.achievements.any(
        (a) => a.achievementId == userAchievement.achievementId,
      );
      if (!wasUnlocked) {
        final achievement = Achievement.getAllAchievements().firstWhere(
          (a) => a.id == userAchievement.achievementId,
        );
        newAchievements.add(achievement);
      }
    }

    if (mounted) {
      // Trigger celebration animation
      _celebrationController.reset();
      _celebrationController.forward();
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingS),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.success,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              const Expanded(
                child: Text('Recipe Completed!'),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Celebration animation - plays once with smooth timing
              LottieAnimation(
                animationPath: AppAnimations.celebration,
                width: 200,
                height: 200,
                repeat: false, // Play once
                controller: _celebrationController,
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                'Congratulations! You\'ve successfully cooked ${widget.recipe.name}.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingL),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomIcon(
                      iconName: CustomIcon.star,
                      size: 32,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      '+$points Points',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                navigator.pop(); // Close dialog
                
                // Show achievement popups if any
                if (newAchievements.isNotEmpty) {
                  for (final achievement in newAchievements) {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) => AchievementUnlockDialog(
                        achievement: achievement,
                      ),
                    );
                  }
                }
                
                // Navigate back
                navigator.pop(); // Close cooking screen
                navigator.pop(); // Close spin screen
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentStepIndex + 1) / widget.recipe.steps.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondary),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step counter
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              color: AppTheme.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Step ${_currentStepIndex + 1} of ${widget.recipe.steps.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step title
                    Text(
                      _currentStep.title,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: AppTheme.spacingL),

                    // Step description
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Text(
                        _currentStep.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingXL),

                    // Cooking animation - show when timer is running
                    if (_isTimerRunning) ...[
                      Center(
                        child: LottieAnimation(
                          animationPath: AppAnimations.cookingProcess,
                          width: 180,
                          height: 180,
                          repeat: true,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                    ],

                    // Timer section
                    if (_currentStep.duration > 0) ...[
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingXL),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                          border: Border.all(color: AppTheme.divider),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomIcon(
                                  iconName: CustomIcon.timer,
                                  size: 40,
                                ),
                                const SizedBox(width: AppTheme.spacingM),
                                Text(
                                  _formatDuration(
                                    _isTimerRunning
                                        ? _remainingSeconds
                                        : _currentStep.duration,
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        color: AppTheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),

                            const SizedBox(height: AppTheme.spacingXL),

                            if (!_isTimerRunning)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _startTimer,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(AppTheme.spacingM),
                                  ),
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Start Timer'),
                                ),
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _pauseTimer,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.all(AppTheme.spacingM),
                                  ),
                                  icon: const Icon(Icons.pause),
                                  label: const Text('Pause Timer'),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXL),
                    ],

                    // Step navigation
                    Row(
                      children: [
                        if (_currentStepIndex > 0)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _previousStep,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(AppTheme.spacingM),
                              ),
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Prev'),
                            ),
                          ),
                        if (_currentStepIndex > 0)
                          const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _finishStep,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(AppTheme.spacingM),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentStepIndex == widget.recipe.steps.length - 1
                                      ? 'Finish Recipe'
                                      : 'Next Step',
                                ),
                                const SizedBox(width: AppTheme.spacingS),
                                Icon(
                                  _currentStepIndex == widget.recipe.steps.length - 1
                                      ? Icons.check
                                      : Icons.arrow_forward,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

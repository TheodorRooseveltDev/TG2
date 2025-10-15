import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/data_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'widgets/lottie_animation.dart';

void main() {
  runApp(const CookAndSpinApp());
}

class CookAndSpinApp extends StatelessWidget {
  const CookAndSpinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweet Spin \'n\' Cook',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final dataService = DataService();
    
    // Clear onboarding status to start fresh (comment out after testing)
    await dataService.setOnboardingComplete(false);
    
    final isComplete = await dataService.isOnboardingComplete();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => isComplete 
              ? const HomeScreen() 
              : const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading chef animation - loops continuously
            const LottieAnimation(
              animationPath: AppAnimations.loadingChef,
              width: 200,
              height: 200,
              repeat: true, // Loop continuously during loading
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              'Sweet Spin \'n\' Cook',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Loading your recipes...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/data_service.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();

    // Initialize rotation animation for the loader
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Navigate after 2.5 seconds
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted || _navigating) return;
    _navigating = true;

    final dataService = DataService();
    
    // Clear onboarding status to start fresh (comment out after testing)
    await dataService.setOnboardingComplete(false);
    
    final isComplete = await dataService.isOnboardingComplete();

    if (!mounted) return;

    // Create fade transition animation
    final targetScreen = isComplete ? const HomeScreen() : const OnboardingScreen();

    // Animate fade out then navigate
    await _controller.animateTo(1.0, duration: const Duration(milliseconds: 600));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Combined fade and scale animation
          final fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          );

          final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          );

          return FadeTransition(
            opacity: fadeInAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/splash/screen.png',
              fit: BoxFit.cover,
            ),
          ),
          // Animated Loader
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Complex animated loader with multiple rotating elements
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer rotating ring
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _controller.value * 2 * math.pi,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: CustomPaint(
                              painter: OuterRingPainter(),
                            ),
                          ),
                        ),
                        // Middle counter-rotating ring
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: -_controller.value * 1.5 * math.pi,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 2,
                              ),
                            ),
                            child: CustomPaint(
                              painter: MiddleRingPainter(),
                            ),
                          ),
                        ),
                        // Inner pulsing circle
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final pulseValue = (math.sin(_controller.value * 2 * math.pi) + 1) / 2;
                            final scale = 0.7 + (pulseValue * 0.3);
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      blurRadius: 15 * pulseValue,
                                      spreadRadius: 5 * pulseValue,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.restaurant_menu,
                                  color: Color(0xFFFF6B35),
                                  size: 24,
                                ),
                              ),
                            );
                          },
                        ),
                        // Orbiting dots
                        ...List.generate(3, (index) {
                          return AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final angle = (_controller.value * 2 * math.pi) + 
                                           (index * 2 * math.pi / 3);
                              final x = math.cos(angle) * 50;
                              final y = math.sin(angle) * 50;
                              final opacity = (math.sin(_controller.value * 2 * math.pi + index) + 1) / 2;
                              
                              return Transform.translate(
                                offset: Offset(x, y),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.6 + opacity * 0.4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Simple pulsing text with better visibility
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final pulseValue = (math.sin(_controller.value * 2 * math.pi) + 1) / 2;
                      return Opacity(
                        opacity: 0.85 + (pulseValue * 0.15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: const Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the outer ring
class OuterRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Draw multiple arcs for a more interesting pattern
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi,
      false,
      paint,
    );
    
    paint.color = Colors.white.withOpacity(0.5);
    canvas.drawArc(
      rect,
      math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for the middle ring
class MiddleRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Draw shorter arcs for variation
    canvas.drawArc(
      rect,
      0,
      math.pi * 0.7,
      false,
      paint,
    );
    
    paint.color = Colors.white.withOpacity(0.4);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * 0.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

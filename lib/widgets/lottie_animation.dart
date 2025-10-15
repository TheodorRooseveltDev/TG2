import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation extends StatelessWidget {
  final String animationPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeat;
  final bool reverse;
  final AnimationController? controller;
  final double? frameRate;
  final Duration? duration;

  const LottieAnimation({
    super.key,
    required this.animationPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.reverse = false,
    this.controller,
    this.frameRate,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animationPath,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
      options: LottieOptions(enableMergePaths: true),
      animate: true,
      errorBuilder: (context, error, stackTrace) {
        // Fallback if animation fails to load
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.animation,
            size: (width ?? 100) * 0.4,
            color: Colors.grey.shade400,
          ),
        );
      },
    );
  }
}

// Predefined animations for easy access
class AppAnimations {
  static const String celebration = 'assets/animations/celebration.json';
  static const String cookingProcess = 'assets/animations/cooking_process.json';
  static const String loadingChef = 'assets/animations/loading_chef.json';
}

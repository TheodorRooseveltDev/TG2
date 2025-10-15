import 'package:flutter/material.dart';
import '../widgets/custom_icon.dart';

class UnlockAnimation extends StatefulWidget {
  final VoidCallback onComplete;
  final Offset startPosition; // Where the lock icon starts (button position)

  const UnlockAnimation({
    super.key,
    required this.onComplete,
    required this.startPosition,
  });

  @override
  State<UnlockAnimation> createState() => _UnlockAnimationState();
}

class _UnlockAnimationState extends State<UnlockAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fallAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Fall animation - moves from start position to bottom of screen
    _fallAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Fade animation - fades out in the last 40% of animation
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    // Scale animation - gets smaller as it falls
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Start animation
    _controller.forward();

    // Call onComplete when animation finishes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate the current Y position
        final startY = widget.startPosition.dy;
        final endY = screenHeight + 100; // Off the bottom of screen
        final currentY = startY + (endY - startY) * _fallAnimation.value;

        return Stack(
          children: [
            Positioned(
              left: widget.startPosition.dx,
              top: currentY,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: const CustomIcon(
                    iconName: CustomIcon.lock,
                    size: 60,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

/// Custom icon widget that displays PNG icons from assets
/// Icons are displayed with their original colors and design - no color filters applied
class CustomIcon extends StatelessWidget {
  final String iconName;
  final double size;
  final Color? color; // Kept for API compatibility but NOT applied to preserve original design

  const CustomIcon({
    super.key,
    required this.iconName,
    this.size = 24,
    this.color, // Kept for compatibility but won't be used
  });

  // Icon name constants
  static const String timer = 'timer';
  static const String star = 'star';
  static const String lock = 'lock';
  static const String trophy = 'trophy';
  static const String fire = 'fire';
  static const String chefHat = 'chief_hat';

  String get _iconPath => 'assets/images/icons/icon_$iconName.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _iconPath,
      width: size,
      height: size,
      // NO color filter - preserve original icon design with colors and shadows
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to material icon if asset not found
        return Icon(
          Icons.help_outline,
          size: size,
          color: color ?? Colors.grey,
        );
      },
    );
  }
}

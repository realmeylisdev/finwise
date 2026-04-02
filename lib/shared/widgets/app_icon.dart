import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

export 'package:hugeicons/hugeicons.dart' show HugeIcons;

/// Normalized wrapper around [HugeIcon].
///
/// SVG-based HugeIcons fill their bounding box edge-to-edge, while
/// font-based Material Icons include ~2 dp optical padding per side.
/// This widget preserves the logical [size] for layout but scales the
/// rendered SVG so it visually matches a Material [Icon] at the same size.
class AppIcon extends StatelessWidget {
  const AppIcon({
    required this.icon,
    this.size = 24.0,
    this.color,
    super.key,
  });

  final List<List<dynamic>> icon;
  final double size;
  final Color? color;

  /// Tune this single value to adjust all HugeIcons across the app.
  static const double _opticalScale = 0.8;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: HugeIcon(
          icon: icon,
          size: size * _opticalScale,
          color: color,
        ),
      ),
    );
  }
}

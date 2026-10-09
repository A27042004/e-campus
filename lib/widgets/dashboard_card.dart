import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Base rounded card used everywhere (consistent radius, shadow, border).
class DashboardCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final double radius;
  final Color? color;

  const DashboardCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.gradient,
    this.radius = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final r = BorderRadius.circular(radius);
    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? p.card) : null,
        gradient: gradient,
        borderRadius: r,
        boxShadow: p.shadow,
        border: p.dark && gradient == null ? Border.all(color: p.border) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Gradient initials avatar (swap for NetworkImage when photos are available).
class UserAvatar extends StatelessWidget {
  final String initials;
  final double radius;
  final bool online, group;
  final Gradient? gradient;

  const UserAvatar({
    super.key,
    required this.initials,
    this.radius = 24,
    this.online = false,
    this.group = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient ?? (group ? AppColors.accentGradient : AppColors.brandGradient),
          ),
          alignment: Alignment.center,
          child: group
              ? Icon(Icons.groups_rounded, color: Colors.white, size: radius)
              : Text(
                  initials,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: radius * 0.72),
                ),
        ),
        if (online)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.5,
              height: radius * 0.5,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: p.card, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

class AppLogo extends StatelessWidget {
  final double size;
  final bool onDark;
  const AppLogo({super.key, this.size = 72, this.onDark = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: onDark ? Colors.white : null,
        gradient: onDark ? null : AppColors.brandGradient,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Icon(Icons.school_rounded, size: size * 0.54, color: onDark ? AppColors.primary : Colors.white),
    );
  }
}

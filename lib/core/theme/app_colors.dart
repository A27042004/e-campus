import 'package:flutter/material.dart';

/// Central brand colours. Change them here and the whole app updates.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF3730A3); // deep indigo
  static const secondary = Color(0xFF6366F1); // violet-blue
  static const accent = Color(0xFF14B8A6); // teal
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFDC2626);

  static const lightBg = Color(0xFFF4F7FE);
  static const darkBg = Color(0xFF0B1220);
  static const darkCard = Color(0xFF151E32);

  static const brandGradient = LinearGradient(
    colors: [Color(0xFF3730A3), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accentGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Theme-aware palette (light / dark) so widgets never hard-code colours.
class Pal {
  final bool dark;
  final Color bg, card, text, subtext, border, soft;

  const Pal._(this.dark, this.bg, this.card, this.text, this.subtext, this.border, this.soft);

  factory Pal.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark
        ? const Pal._(true, AppColors.darkBg, AppColors.darkCard, Color(0xFFE2E8F0),
            Color(0xFF94A3B8), Color(0xFF263248), Color(0xFF1C2740))
        : const Pal._(false, AppColors.lightBg, Colors.white, Color(0xFF0F172A),
            Color(0xFF64748B), Color(0xFFE2E8F0), Color(0xFFF1F5F9));
  }

  Color get primary => dark ? AppColors.secondary : AppColors.primary;

  List<BoxShadow> get shadow => dark
      ? const []
      : const [BoxShadow(color: Color(0x120F172A), blurRadius: 20, offset: Offset(0, 8))];
}

class AppSpacing {
  AppSpacing._();
  static const double xs = 4, sm = 8, md = 16, lg = 24, xl = 32;
}

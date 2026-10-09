import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// One place that controls colours, typography and component styles.
class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final dark = b == Brightness.dark;
    final text = dark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final sub = dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primary = dark ? AppColors.secondary : AppColors.primary;
    final card = dark ? AppColors.darkCard : Colors.white;
    final bg = dark ? AppColors.darkBg : AppColors.lightBg;
    final border = dark ? const Color(0xFF263248) : const Color(0xFFE2E8F0);
    final soft = dark ? const Color(0xFF1C2740) : const Color(0xFFF1F5F9);

    final scheme = ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: b).copyWith(
      primary: primary,
      secondary: AppColors.accent,
      surface: card,
      error: AppColors.error,
    );

    final base = ThemeData(brightness: b, useMaterial3: true, colorScheme: scheme);

    TextStyle f(double size, FontWeight w, {Color? c, double? h, double? ls}) =>
        GoogleFonts.inter(fontSize: size, fontWeight: w, color: c ?? text, height: h, letterSpacing: ls);

    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineLarge: f(28, FontWeight.w800, ls: -0.5),
      headlineMedium: f(24, FontWeight.w700, ls: -0.3),
      headlineSmall: f(20, FontWeight.w700),
      titleLarge: f(18, FontWeight.w700),
      titleMedium: f(16, FontWeight.w600),
      titleSmall: f(14, FontWeight.w600),
      bodyLarge: f(16, FontWeight.w400, h: 1.5),
      bodyMedium: f(14, FontWeight.w400, h: 1.45),
      bodySmall: f(12, FontWeight.w400, c: sub, h: 1.4),
      labelLarge: f(15, FontWeight.w600),
      labelMedium: f(12, FontWeight.w600, c: sub),
      labelSmall: f(11, FontWeight.w600, c: sub, ls: 0.4),
    );

    OutlineInputBorder ob(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      textTheme: textTheme,
      dividerColor: border,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: text),
        titleTextStyle: f(20, FontWeight.w700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: soft,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: f(14, FontWeight.w400, c: sub),
        labelStyle: f(14, FontWeight.w500, c: sub),
        prefixIconColor: sub,
        suffixIconColor: sub,
        border: ob(Colors.transparent),
        enabledBorder: ob(Colors.transparent),
        focusedBorder: ob(primary, 1.5),
        errorBorder: ob(AppColors.error),
        focusedErrorBorder: ob(AppColors.error, 1.5),
        errorStyle: f(12, FontWeight.w500, c: AppColors.error),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        elevation: 8,
        height: 68,
        indicatorColor: primary.withOpacity(0.14),
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? const Color(0xFF334155) : const Color(0xFF0F172A),
        contentTextStyle: f(14, FontWeight.w500, c: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: _SoftFadeTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}

/// Subtle fade + slight upward slide for route changes.
class _SoftFadeTransitionsBuilder extends PageTransitionsBuilder {
  const _SoftFadeTransitionsBuilder();

  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.03), end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  }
}



/// Theme-aware palette for light and dark mode.
class Pal {
  final bool dark;
  final Color bg, card, text, subtext, border, soft;

  const Pal._(
      this.dark,
      this.bg,
      this.card,
      this.text,
      this.subtext,
      this.border,
      this.soft,
      );

  factory Pal.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return dark
        ? const Pal._(
      true,
      AppColors.darkBg,
      AppColors.darkCard,
      Color(0xFFE2E8F0),
      Color(0xFF94A3B8),
      Color(0xFF263248),
      Color(0xFF1C2740),
    )
        : const Pal._(
      false,
      AppColors.lightBg,
      Colors.white,
      Color(0xFF0F172A),
      Color(0xFF64748B),
      Color(0xFFE2E8F0),
      Color(0xFFF1F5F9),
    );
  }

  Color get primary =>
      dark ? AppColors.secondary : AppColors.primary;

  List<BoxShadow> get shadow => dark
      ? const []
      : const [
    BoxShadow(
      color: Color(0x120F172A),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
}
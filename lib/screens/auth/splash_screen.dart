import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..forward();

  late final Animation<double> _scale = Tween(begin: 0.6, end: 1.0)
      .animate(CurvedAnimation(parent: _c, curve: const Interval(0, 0.6, curve: Curves.easeOutBack)));
  late final Animation<double> _fadeLogo =
      CurvedAnimation(parent: _c, curve: const Interval(0, 0.5, curve: Curves.easeOut));
  late final Animation<double> _fadeText =
      CurvedAnimation(parent: _c, curve: const Interval(0.45, 1, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) Navigator.of(context).pushReplacement(fadeRoute(const LoginScreen()));
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E2A8A), Color(0xFF4F46E5), Color(0xFF6366F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -80, right: -60, child: _circle(240, 0.07)),
            Positioned(bottom: -100, left: -80, child: _circle(300, 0.06)),
            Positioned(top: 160, left: -40, child: _circle(110, 0.05)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _fadeLogo,
                    child: ScaleTransition(scale: _scale, child: const AppLogo(size: 104)),
                  ),
                  const SizedBox(height: 28),
                  FadeTransition(
                    opacity: _fadeText,
                    child: SlideTransition(
                      position: Tween(begin: const Offset(0, 0.25), end: Offset.zero).animate(_fadeText),
                      child: Column(
                        children: [
                          const Text('E-Campus',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                          const SizedBox(height: 6),
                          Text('College Management App',
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, letterSpacing: 0.4)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 56,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeText,
                child: const Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white70),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double s, double o) => Container(
        width: s,
        height: s,
        decoration: BoxDecoration(color: Colors.white.withOpacity(o), shape: BoxShape.circle),
      );
}

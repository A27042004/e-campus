import 'dart:ui' show PathMetric, Tangent;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';

/// Live-style map. It is drawn with CustomPaint so the app runs without an API key.
/// To use real Google Maps, see README ("Google Maps") and replace [_MapArea].
class BusTrackingScreen extends StatefulWidget {
  const BusTrackingScreen({super.key});

  @override
  State<BusTrackingScreen> createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 40))..repeat();

  static const _places = ['College Gate', 'Main Road', 'City Mall', 'Library Circle', 'Railway Station'];

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Bus Tracking', subtitle: 'Bus 01 • Route A'),
      body: Stack(
        children: [
          Positioned.fill(child: _MapArea(controller: _c)),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: AnimatedBuilder(
                    animation: _c,
                    builder: (_, __) {
                      final idx = (_c.value * _places.length).floor().clamp(0, _places.length - 1).toInt();
                      final eta = (12 - _c.value * 10).round().clamp(2, 12).toInt();
                      return DashboardCard(
                        radius: 24,
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                    gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(14)),
                                child: const Icon(Icons.directions_bus_rounded, color: Colors.white),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Bus 01', style: t.titleMedium),
                                  Row(children: [
                                    const Icon(Icons.circle, size: 9, color: AppColors.success),
                                    const SizedBox(width: 5),
                                    Text('Live', style: t.labelMedium?.copyWith(color: AppColors.success)),
                                    Text('  •  Driver: Ramesh K.', style: t.bodySmall),
                                  ]),
                                ]),
                              ),
                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Text('$eta min', style: t.titleLarge?.copyWith(color: p.primary)),
                                Text('ETA', style: t.bodySmall),
                              ]),
                            ]),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(14)),
                              child: Row(children: [
                                Icon(Icons.my_location_rounded, color: p.primary, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text('Current location', style: t.bodySmall),
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: Text(_places[idx], key: ValueKey(idx), style: t.titleSmall),
                                    ),
                                  ]),
                                ),
                              ]),
                            ),
                            const SizedBox(height: 14),
                            CustomButton(
                              label: 'Notify me when bus is near',
                              icon: Icons.notifications_active_rounded,
                              outlined: true,
                              onPressed: () => showSnack(context, "We'll notify you when Bus 01 is 5 minutes away"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Path _route(Size s) {
  final w = s.width, h = s.height * 0.62;
  return Path()
    ..moveTo(w * 0.12, h * 0.86)
    ..cubicTo(w * 0.15, h * 0.45, w * 0.45, h * 0.75, w * 0.50, h * 0.50)
    ..cubicTo(w * 0.56, h * 0.22, w * 0.80, h * 0.62, w * 0.86, h * 0.18);
}

class _MapArea extends StatelessWidget {
  final AnimationController controller;
  const _MapArea({required this.controller});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return LayoutBuilder(builder: (context, c) {
      final size = Size(c.maxWidth, c.maxHeight);
      final metric = _route(size).computeMetrics().first;
      return Container(
        color: p.dark ? const Color(0xFF111A2C) : const Color(0xFFE8EEF9),
        child: Stack(
          children: [
            CustomPaint(size: size, painter: _MapPainter(p)),
            AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                final Tangent? tg = metric.getTangentForOffset(metric.length * controller.value);
                final pos = tg?.position ?? Offset.zero;
                return Positioned(
                  left: pos.dx - 22,
                  top: pos.dy - 22,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.5), blurRadius: 16, spreadRadius: 2)],
                    ),
                    child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 22),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

class _MapPainter extends CustomPainter {
  final Pal p;
  _MapPainter(this.p);

  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = p.dark ? const Color(0xFF1E2A44) : Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 1; i < 6; i++) {
      canvas.drawLine(Offset(0, size.height * i / 6), Offset(size.width, size.height * (i / 6) - 30), road);
    }
    for (var i = 1; i < 5; i++) {
      canvas.drawLine(Offset(size.width * i / 5, 0), Offset(size.width * i / 5 + 24, size.height), road);
    }

    final path = _route(size);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.secondary.withOpacity(0.25)
        ..strokeWidth = 12
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = p.primary
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // stops
    final PathMetric m = path.computeMetrics().first;
    for (var i = 0; i < 5; i++) {
      final pos = m.getTangentForOffset(m.length * (i / 4))!.position;
      canvas.drawCircle(pos, 9, Paint()..color = Colors.white);
      canvas.drawCircle(pos, 6, Paint()..color = i == 0 || i == 4 ? AppColors.error : p.primary);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.p.dark != p.dark;
}

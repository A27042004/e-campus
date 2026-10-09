import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'custom_button.dart';
import 'dashboard_card.dart';

class BusTrackingCard extends StatefulWidget {
  final VoidCallback onTrack;
  const BusTrackingCard({super.key, required this.onTrack});

  @override
  State<BusTrackingCard> createState() => _BusTrackingCardState();
}

class _BusTrackingCardState extends State<BusTrackingCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    return DashboardCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('College Bus', style: t.bodySmall),
                Row(
                  children: [
                    Text('Bus 01', style: t.titleMedium),
                    const SizedBox(width: 10),
                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) => Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withOpacity(0.5 * (1 - _pulse.value)),
                              blurRadius: 10 * _pulse.value + 2,
                              spreadRadius: 5 * _pulse.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('Live', style: t.labelMedium?.copyWith(color: AppColors.success)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 14, color: p.subtext),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text('Main Road', style: t.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CustomButton(label: 'Track', onPressed: widget.onTrack, small: true, expanded: false),
        ],
      ),
    );
  }
}

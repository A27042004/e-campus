import 'package:flutter/material.dart';

import '../core/models/models.dart';
import '../core/theme/app_colors.dart';
import 'dashboard_card.dart';

/// [compact] = fixed-width card for horizontal carousels; otherwise list row.
class NewsCard extends StatelessWidget {
  final NewsItem item;
  final bool compact;
  final VoidCallback? onTap;
  const NewsCard({super.key, required this.item, this.compact = false, this.onTap});

  @override
  Widget build(BuildContext context) => compact ? _compact(context) : _row(context);

  Widget _badge(BuildContext context, {bool onColor = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: onColor ? Colors.white.withOpacity(0.22) : item.color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        item.category,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: onColor ? Colors.white : item.color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _compact(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: 280,
      child: DashboardCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 84,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [item.color, item.color.withOpacity(0.65)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _badge(context, onColor: true),
                  if (item.important) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 18),
                  ],
                  const Spacer(),
                  Icon(item.icon, color: Colors.white.withOpacity(0.9), size: 30),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.titleSmall),
                  const SizedBox(height: 6),
                  Text(item.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: t.bodySmall?.copyWith(color: p.subtext)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 14, color: p.subtext),
                      const SizedBox(width: 4),
                      Text(item.date, style: t.bodySmall),
                      const Spacer(),
                      Text('Read More', style: t.labelMedium?.copyWith(color: p.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    return DashboardCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(color: item.color.withOpacity(0.14), borderRadius: BorderRadius.circular(16)),
            child: Icon(item.icon, color: item.color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _badge(context),
                    Text('• ${item.department}', style: t.bodySmall),
                    if (item.important)
                      const Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.warning),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item.title, style: t.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(item.description,
                    style: t.bodySmall?.copyWith(color: p.subtext), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 14, color: p.subtext),
                    const SizedBox(width: 4),
                    Text(item.date, style: t.bodySmall),
                    const Spacer(),
                    Text('Read More', style: t.labelMedium?.copyWith(color: p.primary)),
                    Icon(Icons.chevron_right_rounded, size: 18, color: p.primary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

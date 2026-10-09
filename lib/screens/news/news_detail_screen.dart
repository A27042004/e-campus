import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/widgets.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem item;
  const NewsDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(title: 'News'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(colors: [item.color, item.color.withOpacity(0.6)]),
            ),
            child: Center(child: Icon(item.icon, size: 72, color: Colors.white.withOpacity(0.9))),
          ),
          const SizedBox(height: 18),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: item.color.withOpacity(0.14), borderRadius: BorderRadius.circular(20)),
              child: Text(item.category, style: t.labelSmall?.copyWith(color: item.color, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Text('${item.department} • ${item.date}', style: t.bodySmall),
          ]),
          const SizedBox(height: 12),
          Text(item.title, style: t.headlineSmall),
          const SizedBox(height: 12),
          Text(
            '${item.description}\n\nThis is a placeholder for the full article. Connect your backend (Firestore / REST) '
            'and render the complete story here, with images and attachments.',
            style: t.bodyLarge?.copyWith(color: p.subtext, height: 1.6),
          ),
        ],
      ),
    );
  }
}

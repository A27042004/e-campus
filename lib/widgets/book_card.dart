import 'package:flutter/material.dart';

import '../core/models/models.dart';
import '../core/theme/app_colors.dart';
import 'dashboard_card.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onRead, onDownload;
  const BookCard({super.key, required this.book, this.onRead, this.onDownload});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    return DashboardCard(
      padding: const EdgeInsets.all(10),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [book.c1, book.c2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -18,
                    top: -18,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
                    ),
                  ),
                  Center(child: Icon(book.icon, size: 40, color: Colors.white)),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 6, color: Colors.black.withOpacity(0.16)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(book.title, style: t.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(book.author, style: t.bodySmall?.copyWith(color: p.subtext), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: p.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(book.category,
                style: t.labelSmall?.copyWith(color: p.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: FilledButton(
                    onPressed: onRead,
                    style: FilledButton.styleFrom(
                      backgroundColor: p.primary,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Read', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 36,
                height: 36,
                child: IconButton.outlined(
                  tooltip: 'Download',
                  onPressed: onDownload,
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    side: BorderSide(color: p.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: Icon(Icons.download_rounded, size: 18, color: p.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

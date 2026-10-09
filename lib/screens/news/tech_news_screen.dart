import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../data/mock_data.dart';
import '../../widgets/widgets.dart';
import 'news_detail_screen.dart';

class TechNewsScreen extends StatefulWidget {
  final bool embedded;
  const TechNewsScreen({super.key, this.embedded = false});

  @override
  State<TechNewsScreen> createState() => _TechNewsScreenState();
}

class _TechNewsScreenState extends State<TechNewsScreen> {
  late Future<List<NewsItem>> _future = MockApi.news();
  String _dept = 'All';

  void _reload() => setState(() => _future = MockApi.news());

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;

    return ScreenFrame(
      embedded: widget.embedded,
      title: 'Tech News',
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              scrollDirection: Axis.horizontal,
              itemCount: MockApi.departments.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final d = MockApi.departments[i];
                final sel = d == _dept;
                return ChoiceChip(
                  label: Text(d),
                  selected: sel,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _dept = d),
                  selectedColor: p.primary,
                  backgroundColor: p.card,
                  labelStyle: TextStyle(
                      color: sel ? Colors.white : p.subtext, fontWeight: FontWeight.w600, fontSize: 13),
                  side: BorderSide(color: sel ? p.primary : p.border),
                );
              },
            ),
          ),
          Expanded(
            child: AsyncBody<List<NewsItem>>(
              future: _future,
              onRetry: _reload,
              loading: const LoadingWidget(itemHeight: 120),
              builder: (context, all) {
                final list = _dept == 'All' ? all : all.where((n) => n.department == _dept).toList();
                if (list.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.newspaper_rounded,
                    title: 'No latest news',
                    message: 'There are no updates for $_dept right now. Check back soon.',
                    actionLabel: 'Show all',
                    onAction: () => setState(() => _dept = 'All'),
                  );
                }
                final featured = list.firstWhere((n) => n.important, orElse: () => list.first);
                final rest = list.where((n) => n.id != featured.id).toList();
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  children: [
                    FadeSlideIn(child: _Featured(item: featured)),
                    const SizedBox(height: 22),
                    Text('Latest Updates', style: t.titleLarge),
                    const SizedBox(height: 12),
                    for (var i = 0; i < rest.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FadeSlideIn(
                          delayMs: 60 * i,
                          child: NewsCard(
                            item: rest[i],
                            onTap: () => pushPage(context, NewsDetailScreen(item: rest[i])),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Featured extends StatelessWidget {
  final NewsItem item;
  const _Featured({required this.item});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return DashboardCard(
      onTap: () => pushPage(context, NewsDetailScreen(item: item)),
      padding: EdgeInsets.zero,
      radius: 24,
      child: Container(
        height: 190,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [item.color, Color.lerp(item.color, AppColors.primary, 0.55)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Icon(item.icon, size: 96, color: Colors.white.withOpacity(0.16)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.22), borderRadius: BorderRadius.circular(20)),
                    child: const Text('FEATURED',
                        style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ),
                  const SizedBox(width: 8),
                  Text(item.category, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                ]),
                const Spacer(),
                Text(item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.schedule_rounded, size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text('${item.date} • ${item.department}', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                  const Spacer(),
                  const Text('Read More', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

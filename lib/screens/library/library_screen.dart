import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../core/utils/nav.dart';
import '../../data/mock_data.dart';
import '../../widgets/widgets.dart';
import '../../core/theme/app_colors.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Book>> _future = MockApi.books();
  String _cat = 'All';
  String _q = '';

  void _reload() => setState(() => _future = MockApi.books());

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Scaffold(
      appBar: const CustomAppBar(title: 'E-Library', subtitle: 'Books, notes & references'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
            child: TextField(
              onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: const Icon(Icons.search_rounded),
                fillColor: p.card,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: p.border),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: MockApi.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = MockApi.categories[i];
                final sel = c == _cat;
                return ChoiceChip(
                  label: Text(c),
                  selected: sel,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _cat = c),
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
            child: AsyncBody<List<Book>>(
              future: _future,
              onRetry: _reload,
              loading: Shimmer(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 300, crossAxisSpacing: 14, mainAxisSpacing: 14),
                  itemCount: 4,
                  itemBuilder: (_, __) => const SkeletonBox(height: 300, radius: 20),
                ),
              ),
              builder: (context, all) {
                final list = all.where((b) {
                  final catOk = _cat == 'All' || b.category == _cat;
                  final qOk = _q.isEmpty || b.title.toLowerCase().contains(_q) || b.author.toLowerCase().contains(_q);
                  return catOk && qOk;
                }).toList();

                if (list.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.menu_book_rounded,
                    title: 'No books found',
                    message: 'Try a different search term or category.',
                  );
                }
                return LayoutBuilder(builder: (context, c) {
                  final cols = (c.maxWidth / 190).floor().clamp(2, 5).toInt();
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisExtent: 310,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => FadeSlideIn(
                      delayMs: (i % cols) * 60,
                      child: BookCard(
                        book: list[i],
                        onRead: () => showSnack(context, 'Opening "${list[i].title}"…'),
                        onDownload: () => showSnack(context, 'Downloading "${list[i].title}"…'),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

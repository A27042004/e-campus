import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../widgets/widgets.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  int _day = (DateTime.now().weekday - 1).clamp(0, 5).toInt();
  late Future<List<ClassSlot>> _future = MockApi.timetable(_day);

  void _select(int i) => setState(() {
        _day = i;
        _future = MockApi.timetable(i);
      });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Timetable', subtitle: 'Weekly class schedule'),
      body: Column(
        children: [
          SizedBox(
            height: 76,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final sel = i == _day;
                return GestureDetector(
                  onTap: () => _select(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 62,
                    decoration: BoxDecoration(
                      gradient: sel ? AppColors.brandGradient : null,
                      color: sel ? null : p.card,
                      borderRadius: BorderRadius.circular(16),
                      border: sel ? null : Border.all(color: p.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(_days[i],
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: sel ? Colors.white : p.subtext)),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: AsyncBody<List<ClassSlot>>(
              key: ValueKey(_day),
              future: _future,
              onRetry: () => _select(_day),
              loading: const LoadingWidget(count: 3),
              isEmpty: (l) => l.isEmpty,
              empty: const EmptyStateWidget(
                icon: Icons.weekend_rounded,
                title: 'No classes today',
                message: 'Enjoy your free day or catch up on assignments.',
              ),
              builder: (_, list) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final s = list[i];
                  return FadeSlideIn(
                    delayMs: 60 * i,
                    child: DashboardCard(
                      child: Row(children: [
                        Container(
                          width: 5,
                          height: 54,
                          decoration: BoxDecoration(
                              color: [AppColors.secondary, AppColors.accent, AppColors.warning, AppColors.success][i % 4],
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(s.time, style: t.labelMedium?.copyWith(color: p.primary)),
                            const SizedBox(height: 3),
                            Text(s.subject, style: t.titleSmall),
                            const SizedBox(height: 3),
                            Text('${s.room} • ${s.teacher}', style: t.bodySmall),
                          ]),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

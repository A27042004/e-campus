import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/models.dart';
import '../../core/services/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../data/mock_data.dart';
import '../../widgets/widgets.dart';
import 'timetable_screen.dart';

class AcademicsScreen extends StatefulWidget {
  final bool embedded;
  const AcademicsScreen({super.key, this.embedded = false});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> {
  late Future<List<SubjectAttendance>> _att = MockApi.attendance();
  late Future<List<Assignment>> _asg = MockApi.assignments();

  void _reload() => setState(() {
        _att = MockApi.attendance();
        _asg = MockApi.assignments();
      });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionProvider>().user!;
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    final isStudent = user.role == UserRole.student || user.role == UserRole.cr;

    return ScreenFrame(
      embedded: widget.embedded,
      title: 'Academics',
      child: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            FadeSlideIn(
              child: DashboardCard(
                gradient: AppColors.brandGradient,
                onTap: () => pushPage(context, const TimetableScreen()),
                child: Row(children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.calendar_month_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(isStudent ? 'Timetable' : 'Teaching timetable',
                          style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                      Text('View your weekly schedule', style: TextStyle(color: Colors.white.withOpacity(0.85))),
                    ]),
                  ),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Attendance'),
            const SizedBox(height: 12),
            AsyncBody<List<SubjectAttendance>>(
                future: _att,
                onRetry: _reload,
                loading: const SkeletonList(count: 3, height: 64),
                builder: (_, list) => DashboardCard(
                  child: Column(children: [
                    for (final s in list)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(children: [
                          Row(children: [
                            Expanded(child: Text(s.name, style: t.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                            Text('${(s.percent * 100).round()}%',
                                style: t.titleSmall?.copyWith(
                                    color: s.percent < 0.85 ? AppColors.warning : AppColors.success)),
                          ]),
                          const SizedBox(height: 7),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: s.percent),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                            builder: (_, v, __) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: v,
                                minHeight: 8,
                                backgroundColor: p.soft,
                                valueColor: AlwaysStoppedAnimation(
                                    s.percent < 0.85 ? AppColors.warning : AppColors.success),
                              ),
                            ),
                          ),
                        ]),
                      ),
                  ]),
                ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Assignments'),
            const SizedBox(height: 12),
            AsyncBody<List<Assignment>>(
                future: _asg,
                onRetry: _reload,
                loading: const SkeletonList(count: 3, height: 88),
                isEmpty: (l) => l.isEmpty,
                empty: const EmptyStateWidget(
                  icon: Icons.assignment_turned_in_rounded,
                  title: 'No assignments yet',
                  message: "You're all caught up. New assignments will show up here.",
                ),
                builder: (_, list) => Column(
                  children: [
                    for (var i = 0; i < list.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Builder(builder: (_) {
                    final a = list[i];
                    final c = a.urgent ? AppColors.error : p.primary;
                    return FadeSlideIn(
                      delayMs: 60 * i,
                      child: DashboardCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(a.title, style: t.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                              decoration: BoxDecoration(
                                  color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                              child: Text(a.due, style: t.labelSmall?.copyWith(color: c, fontWeight: FontWeight.w700)),
                            ),
                          ]),
                          const SizedBox(height: 2),
                          Text(a.subject, style: t.bodySmall),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: a.progress,
                              minHeight: 7,
                              backgroundColor: p.soft,
                              valueColor: AlwaysStoppedAnimation(c),
                            ),
                          ),
                        ]),
                      ),
                    );
                        }),
                      ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}

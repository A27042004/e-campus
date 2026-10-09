import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/models.dart';
import '../../core/services/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../data/mock_data.dart';
import '../../widgets/widgets.dart';
import '../ai/ai_chat_screen.dart';
import '../bus/bus_tracking_screen.dart';
import '../chat/chat_list_screen.dart';
import '../library/library_screen.dart';
import '../news/news_detail_screen.dart';
import '../notifications/notifications_screen.dart';
import '../academics/timetable_screen.dart';
import '../settings/settings_screen.dart';

class _Stat {
  final IconData icon;
  final String value, label;
  final Color color;
  final int? tab;
  const _Stat(this.icon, this.value, this.label, this.color, {this.tab});
}

class _Action {
  final IconData icon;
  final String label;
  final Color color;
  final Widget Function()? page;
  const _Action(this.icon, this.label, this.color, [this.page]);
}

class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onTab;
  const HomeScreen({super.key, required this.onTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NewsItem>> _news = MockApi.news();

  void _reload() => setState(() => _news = MockApi.news());

  // ---------- role configuration ----------
  List<_Stat> _stats(UserRole r) => switch (r) {
        UserRole.student => const [
            _Stat(Icons.fact_check_rounded, '87%', 'Attendance', AppColors.success, tab: 1),
            _Stat(Icons.assignment_rounded, '3 Pending', 'Assignments', AppColors.warning, tab: 1),
            _Stat(Icons.newspaper_rounded, '5 New', 'News', AppColors.secondary, tab: 3),
            _Stat(Icons.event_rounded, '2 Upcoming', 'Events', AppColors.accent),
          ],
        UserRole.teacher => const [
            _Stat(Icons.groups_rounded, '128', 'Students', AppColors.secondary, tab: 1),
            _Stat(Icons.how_to_reg_rounded, '4 Today', 'Classes', AppColors.success, tab: 1),
            _Stat(Icons.rate_review_rounded, '12 To grade', 'Submissions', AppColors.warning),
            _Stat(Icons.forum_rounded, '6 New', 'Messages', AppColors.accent),
          ],
        UserRole.cr => const [
            _Stat(Icons.groups_rounded, '62', 'Classmates', AppColors.secondary, tab: 1),
            _Stat(Icons.campaign_rounded, '2 Drafts', 'Announcements', AppColors.warning),
            _Stat(Icons.newspaper_rounded, '5 New', 'Tech News', AppColors.accent, tab: 3),
            _Stat(Icons.event_rounded, '3 Upcoming', 'Events', AppColors.success),
          ],
        UserRole.admin => const [
            _Stat(Icons.people_alt_rounded, '2,480', 'Students', AppColors.secondary),
            _Stat(Icons.badge_rounded, '164', 'Faculty', AppColors.accent),
            _Stat(Icons.directions_bus_rounded, '12 Active', 'Buses', AppColors.success),
            _Stat(Icons.pending_actions_rounded, '9 Pending', 'Approvals', AppColors.warning),
          ],
      };

  List<_Action> _actions(UserRole r) {
    const lib = _Action(Icons.local_library_rounded, 'E-Library', Color(0xFF6366F1));
    switch (r) {
      case UserRole.student:
        return [
          _Action(lib.icon, lib.label, lib.color, () => const LibraryScreen()),
          _Action(Icons.directions_bus_rounded, 'Bus Tracking', const Color(0xFF14B8A6), () => const BusTrackingScreen()),
          _Action(Icons.chat_bubble_rounded, 'Chat', const Color(0xFF0EA5E9), () => const ChatListScreen()),
          _Action(Icons.auto_awesome_rounded, 'AI Assistant', const Color(0xFF8B5CF6), () => const AiChatScreen()),
          _Action(Icons.newspaper_rounded, 'Tech News', const Color(0xFFF59E0B)),
          _Action(Icons.calendar_month_rounded, 'Timetable', const Color(0xFF16A34A), () => const TimetableScreen()),
        ];
      case UserRole.teacher:
        return [
          const _Action(Icons.how_to_reg_rounded, 'Attendance', Color(0xFF16A34A)),
          const _Action(Icons.groups_rounded, 'Students', Color(0xFF6366F1)),
          _Action(lib.icon, 'Resources', const Color(0xFF14B8A6), () => const LibraryScreen()),
          _Action(Icons.chat_bubble_rounded, 'Chat', const Color(0xFF0EA5E9), () => const ChatListScreen()),
          _Action(Icons.auto_awesome_rounded, 'Campus AI', const Color(0xFF8B5CF6), () => const AiChatScreen()),
          _Action(Icons.calendar_month_rounded, 'Timetable', const Color(0xFFF59E0B), () => const TimetableScreen()),
        ];
      case UserRole.cr:
        return [
          const _Action(Icons.campaign_rounded, 'Announce', Color(0xFFF59E0B)),
          const _Action(Icons.fact_check_rounded, 'Class List', Color(0xFF6366F1)),
          const _Action(Icons.newspaper_rounded, 'Post News', Color(0xFF14B8A6)),
          _Action(Icons.chat_bubble_rounded, 'Chat', const Color(0xFF0EA5E9), () => const ChatListScreen()),
          _Action(Icons.calendar_month_rounded, 'Timetable', const Color(0xFF16A34A), () => const TimetableScreen()),
          _Action(lib.icon, lib.label, lib.color, () => const LibraryScreen()),
        ];
      case UserRole.admin:
        return [
          const _Action(Icons.manage_accounts_rounded, 'Users', Color(0xFF6366F1)),
          const _Action(Icons.bar_chart_rounded, 'Reports', Color(0xFF14B8A6)),
          _Action(Icons.directions_bus_rounded, 'Buses', const Color(0xFF16A34A), () => const BusTrackingScreen()),
          _Action(Icons.notifications_rounded, 'Alerts', const Color(0xFFF59E0B), () => const NotificationsScreen()),
          _Action(Icons.chat_bubble_rounded, 'Chat', const Color(0xFF0EA5E9), () => const ChatListScreen()),
          _Action(Icons.settings_rounded, 'Settings', const Color(0xFF8B5CF6), () => const SettingsScreen()),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionProvider>().user!;
    final stats = _stats(user.role);
    final actions = _actions(user.role);

    return RefreshIndicator(
      onRefresh: () async => _reload(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ProfileHeader(
              user: user,
              onMenu: () => Scaffold.of(context).openDrawer(),
              onBell: () => pushPage(context, const NotificationsScreen()),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- stats ----
                      FadeSlideIn(
                        child: LayoutBuilder(builder: (context, c) {
                          final cols = c.maxWidth >= 640 ? 4 : 2;
                          return GridView(
 shrinkWrap: true,
 physics: const NeverScrollableScrollPhysics(),
 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
 crossAxisCount: cols, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 76),
                            children: [
                              for (final s in stats)
                                StatCard(
                                  icon: s.icon,
                                  value: s.value,
                                  label: s.label,
                                  color: s.color,
                                  onTap: s.tab == null ? null : () => widget.onTab(s.tab!),
                                ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 26),

                      // ---- quick access ----
                      const FadeSlideIn(delayMs: 80, child: SectionHeader(title: 'Quick Access')),
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        delayMs: 120,
                        child: LayoutBuilder(builder: (context, c) {
                          final cols = c.maxWidth >= 640 ? 6 : 3;
                          return GridView(
 shrinkWrap: true,
 physics: const NeverScrollableScrollPhysics(),
 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
 crossAxisCount: cols, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 120),
                            children: [
                              for (final a in actions)
                                QuickActionCard(
                                  icon: a.icon,
                                  label: a.label,
                                  color: a.color,
                                  onTap: () {
                                    if (a.page != null) {
                                      pushPage(context, a.page!());
                                    } else if (a.label == 'Tech News') {
                                      widget.onTab(3);
                                    } else {
                                      showSnack(context, '${a.label} is coming soon');
                                    }
                                  },
                                ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 26),

                      // ---- bus ----
                      if (user.role != UserRole.admin) ...[
                        FadeSlideIn(
                          delayMs: 160,
                          child: BusTrackingCard(onTrack: () => pushPage(context, const BusTrackingScreen())),
                        ),
                        const SizedBox(height: 26),
                      ],

                      // ---- role specific ----
                      FadeSlideIn(delayMs: 200, child: _RoleSection(role: user.role)),
                      const SizedBox(height: 26),

                      // ---- news ----
                      FadeSlideIn(
                        delayMs: 240,
                        child: SectionHeader(title: 'Latest News', action: 'See all', onAction: () => widget.onTab(3)),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 248,
                        child: AsyncBody<List<NewsItem>>(
                          future: _news,
                          onRetry: _reload,
                          loading: Shimmer(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              separatorBuilder: (_, __) => const SizedBox(width: 14),
                              itemBuilder: (_, __) => const SkeletonBox(width: 280, height: 248, radius: 20),
                            ),
                          ),
                          isEmpty: (l) => l.isEmpty,
                          empty: const EmptyStateWidget(
                            icon: Icons.newspaper_rounded,
                            title: 'No latest news',
                            message: 'New announcements will appear here.',
                          ),
                          builder: (_, list) => ListView.separated(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            itemCount: list.length.clamp(0, 5).toInt(),
                            separatorBuilder: (_, __) => const SizedBox(width: 14),
                            itemBuilder: (_, i) => NewsCard(
                              item: list[i],
                              compact: true,
                              onTap: () => pushPage(context, NewsDetailScreen(item: list[i])),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A different focus block per role, same design language.
class _RoleSection extends StatelessWidget {
  final UserRole role;
  const _RoleSection({required this.role});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;

    final title = switch (role) {
      UserRole.student => "Today's Classes",
      UserRole.teacher => "Today's Teaching Schedule",
      UserRole.cr => 'Class Management',
      UserRole.admin => 'Campus Overview',
    };

    Widget row(IconData i, Color c, String a, String b, [String? trailing]) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: c.withOpacity(0.14), borderRadius: BorderRadius.circular(12)),
              child: Icon(i, color: c, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a, style: t.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(b, style: t.bodySmall?.copyWith(color: p.subtext)),
              ]),
            ),
            if (trailing != null) Text(trailing, style: t.labelMedium?.copyWith(color: p.primary)),
          ]),
        );

    Widget bar(String label, double v, Color c) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Column(children: [
            Row(children: [
              Expanded(child: Text(label, style: t.bodyMedium)),
              Text('${(v * 100).round()}%', style: t.titleSmall),
            ]),
            const SizedBox(height: 7),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: v),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (_, val, __) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: val,
                  minHeight: 8,
                  backgroundColor: p.soft,
                  valueColor: AlwaysStoppedAnimation(c),
                ),
              ),
            ),
          ]),
        );

    final List<Widget> body = switch (role) {
      UserRole.student => [
          row(Icons.memory_rounded, AppColors.secondary, 'Operating Systems', 'Room 301 • Dr. Meera Iyer', '09:00'),
          row(Icons.storage_rounded, AppColors.accent, 'Database Systems', 'Room 301 • Prof. Sanjay Rao', '10:00'),
          row(Icons.hub_rounded, AppColors.warning, 'Computer Networks', 'Room 204 • Dr. A. Khan', '11:15'),
        ],
      UserRole.teacher => [
          row(Icons.memory_rounded, AppColors.secondary, 'Operating Systems – Sem 5', 'Room 301 • 62 students', '09:00'),
          row(Icons.cloud_rounded, AppColors.accent, 'Distributed Computing – Sem 5', 'Room 305 • 58 students', '10:00'),
          row(Icons.science_rounded, AppColors.success, 'OS Lab – Batch B', 'Lab 1 • 30 students', '02:00'),
        ],
      UserRole.cr => [
          row(Icons.campaign_rounded, AppColors.warning, 'Post class announcement', 'Notify 62 classmates instantly'),
          row(Icons.assignment_turned_in_rounded, AppColors.success, 'Collect assignment status', '18 students pending'),
          row(Icons.newspaper_rounded, AppColors.accent, 'Share tech news', 'Publish to your class feed'),
        ],
      UserRole.admin => [
          bar('Average attendance', 0.86, AppColors.success),
          bar('Fee collection', 0.72, AppColors.warning),
          bar('Library utilisation', 0.64, AppColors.secondary),
        ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: 8),
        DashboardCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: body),
        ),
      ],
    );
  }
}

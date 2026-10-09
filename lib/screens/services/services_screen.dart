import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';
import '../academics/timetable_screen.dart';
import '../ai/ai_chat_screen.dart';
import '../bus/bus_tracking_screen.dart';
import '../chat/chat_list_screen.dart';
import '../library/library_screen.dart';
import '../notifications/notifications_screen.dart';

class ServicesScreen extends StatelessWidget {
  final bool embedded;
  const ServicesScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;

    final items = <(IconData, String, String, Color, Widget Function())>[
      (Icons.local_library_rounded, 'E-Library', 'Books & study material', const Color(0xFF6366F1), () => const LibraryScreen()),
      (Icons.directions_bus_rounded, 'Bus Tracking', 'Live college bus', const Color(0xFF14B8A6), () => const BusTrackingScreen()),
      (Icons.chat_bubble_rounded, 'Chat', 'Classmates & teachers', const Color(0xFF0EA5E9), () => const ChatListScreen()),
      (Icons.auto_awesome_rounded, 'Campus AI', 'Study assistant', const Color(0xFF8B5CF6), () => const AiChatScreen()),
      (Icons.calendar_month_rounded, 'Timetable', 'Weekly schedule', const Color(0xFF16A34A), () => const TimetableScreen()),
      (Icons.notifications_rounded, 'Notifications', 'Alerts & circulars', const Color(0xFFF59E0B), () => const NotificationsScreen()),
    ];

    return ScreenFrame(
      embedded: embedded,
      title: 'Services',
      child: LayoutBuilder(builder: (context, c) {
        final cols = c.maxWidth >= 640 ? 3 : 2;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols, mainAxisExtent: 150, crossAxisSpacing: 14, mainAxisSpacing: 14),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final it = items[i];
            return FadeSlideIn(
              delayMs: 50 * i,
              child: DashboardCard(
                onTap: () => pushPage(context, it.$5()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: it.$4.withOpacity(0.14), borderRadius: BorderRadius.circular(15)),
                      child: Icon(it.$1, color: it.$4),
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(it.$2, style: t.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(it.$3, style: t.bodySmall?.copyWith(color: p.subtext), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ]),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

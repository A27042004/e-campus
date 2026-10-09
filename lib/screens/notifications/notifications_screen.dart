import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/utils/nav.dart';
import '../../data/mock_data.dart';
import '../../widgets/widgets.dart';
import '../settings/settings_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<AppNotification>> _future = MockApi.notifications();
  List<AppNotification>? _items;

  void _reload() => setState(() {
        _items = null;
        _future = MockApi.notifications();
      });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            icon: const Icon(Icons.done_all_rounded),
            onPressed: () => setState(() => _items?.forEach((n) => n.unread = false)),
          ),
          IconButton(
            tooltip: 'Reminder settings',
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => pushPage(context, const SettingsScreen()),
          ),
        ],
      ),
      body: AsyncBody<List<AppNotification>>(
        future: _future,
        onRetry: _reload,
        builder: (context, data) {
          _items ??= List.of(data);
          final list = _items!;
          if (list.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.notifications_off_rounded,
              title: "You're all caught up",
              message: 'New alerts and reminders will appear here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final n = list[i];
              return Dismissible(
                key: ValueKey(n.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) => setState(() => list.removeAt(i)),
                child: DashboardCard(
                  onTap: () => setState(() => n.unread = false),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(color: n.color.withOpacity(0.14), borderRadius: BorderRadius.circular(14)),
                      child: Icon(n.icon, color: n.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(n.title, style: t.titleSmall)),
                          if (n.unread)
                            Container(width: 9, height: 9, decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle)),
                        ]),
                        const SizedBox(height: 3),
                        Text(n.body, style: t.bodySmall?.copyWith(color: p.subtext)),
                        const SizedBox(height: 6),
                        Text(n.time, style: t.labelSmall),
                      ]),
                    ),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

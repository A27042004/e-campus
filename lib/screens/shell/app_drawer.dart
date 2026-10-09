import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/models.dart';
import '../../core/services/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';
import '../ai/ai_chat_screen.dart';
import '../auth/login_screen.dart';
import '../bus/bus_tracking_screen.dart';
import '../chat/chat_list_screen.dart';
import '../library/library_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';

class _Item {
  final String label;
  final IconData icon;
  final int? tab;
  final Widget Function()? page;
  final bool logout;
  const _Item(this.label, this.icon, {this.tab, this.page, this.logout = false});
}

class AppDrawer extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onTab;
  const AppDrawer({super.key, required this.currentTab, required this.onTab});

  /// Items change dynamically with the user's role.
  Map<String, List<_Item>> _sections(UserRole role) {
    final academics = switch (role) {
      UserRole.student => 'Academics',
      UserRole.teacher => 'My Classes',
      UserRole.cr => 'Class Management',
      UserRole.admin => 'Management',
    };
    return {
      'MAIN': [
        const _Item('Dashboard', Icons.dashboard_rounded, tab: 0),
        _Item(academics, Icons.school_rounded, tab: 1),
      ],
      'SERVICES': [
        _Item('E-Library', Icons.local_library_rounded, page: () => const LibraryScreen()),
        _Item('Bus Tracking', Icons.directions_bus_rounded, page: () => const BusTrackingScreen()),
        _Item('Chat', Icons.chat_bubble_rounded, page: () => const ChatListScreen()),
        if (role != UserRole.admin)
          _Item('Campus AI', Icons.auto_awesome_rounded, page: () => const AiChatScreen()),
      ],
      'INFORMATION': [
        const _Item('Tech News', Icons.newspaper_rounded, tab: 3),
        _Item('Notifications', Icons.notifications_rounded, page: () => const NotificationsScreen()),
      ],
      'ACCOUNT': [
        const _Item('Profile', Icons.person_rounded, tab: 4),
        _Item('Settings', Icons.settings_rounded, page: () => const SettingsScreen()),
        const _Item('Logout', Icons.logout_rounded, logout: true),
      ],
    };
  }

  Future<void> _tap(BuildContext context, _Item item) async {
    final nav = Navigator.of(context);
    nav.pop(); // close drawer
    if (item.logout) {
      final ok = await showDialog<bool>(
        context: nav.context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Log out?'),
          content: const Text('You will need to sign in again to access E-Campus.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Logout'),
            ),
          ],
        ),
      );
      if (ok == true && nav.mounted) {
        nav.pushAndRemoveUntil(fadeRoute(const LoginScreen()), (_) => false);
        Provider.of<SessionProvider>(nav.context, listen: false).logout();
      }
    } else if (item.tab != null) {
      onTab(item.tab!);
    } else if (item.page != null) {
      nav.push(fadeRoute(item.page!()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionProvider>().user!;
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    final sections = _sections(user.role);

    return Drawer(
      backgroundColor: p.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(28))),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 24, 20, 22),
            decoration: const BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.only(topRight: Radius.circular(28), bottomRight: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: UserAvatar(initials: user.initials, radius: 32),
                ),
                const SizedBox(height: 14),
                Text(user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: Text(roleLabel(user.role),
                          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(user.department,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.5)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              children: [
                for (final entry in sections.entries) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
                    child: Text(entry.key, style: t.labelSmall?.copyWith(letterSpacing: 1.2)),
                  ),
                  for (final item in entry.value) _tile(context, item, p),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, _Item item, Pal p) {
    final selected = item.tab != null && item.tab == currentTab;
    final color = item.logout ? AppColors.error : (selected ? p.primary : p.text);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? p.primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _tap(context, item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(item.icon, size: 22, color: item.logout ? AppColors.error : (selected ? p.primary : p.subtext)),
                const SizedBox(width: 14),
                Text(item.label,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: color, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

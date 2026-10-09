import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/models.dart';
import '../../core/services/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';
import '../auth/login_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionProvider>().user!;
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;

    Widget info(IconData i, String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: p.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(i, size: 19, color: p.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: t.bodySmall),
                Text(value, style: t.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
          ]),
        );

    return ScreenFrame(
      embedded: embedded,
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          FadeSlideIn(
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: p.primary, width: 2)),
                child: UserAvatar(initials: user.initials, radius: 46),
              ),
              const SizedBox(height: 14),
              Text(user.name, style: t.headlineSmall),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: p.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Text(roleLabel(user.role), style: t.labelMedium?.copyWith(color: p.primary)),
              ),
            ]),
          ),
          const SizedBox(height: 22),
          FadeSlideIn(
            delayMs: 80,
            child: DashboardCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(children: [
                info(Icons.badge_rounded, 'ID', user.id),
                info(Icons.mail_rounded, 'Email', user.email),
                info(Icons.phone_rounded, 'Mobile', '+91 ${user.phone}'),
                info(Icons.apartment_rounded, 'Department', user.department),
                info(Icons.calendar_month_rounded, 'Semester', user.semester),
              ]),
            ),
          ),
          const SizedBox(height: 18),
          CustomButton(
            label: 'Edit profile',
            icon: Icons.edit_rounded,
            onPressed: () => showSnack(context, 'Profile editing coming soon'),
          ),
          const SizedBox(height: 12),
          CustomButton(
            label: 'Settings',
            icon: Icons.settings_rounded,
            outlined: true,
            onPressed: () => pushPage(context, const SettingsScreen()),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.error, minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
            onPressed: () {
              final session = context.read<SessionProvider>();
              Navigator.of(context).pushAndRemoveUntil(fadeRoute(const LoginScreen()), (_) => false);
              session.logout();
            },
          ),
        ],
      ),
    );
  }
}

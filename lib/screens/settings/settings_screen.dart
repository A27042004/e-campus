import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/notification_service.dart';
import '../../core/services/settings_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _pickTime(BuildContext context, TimeOfDay initial, ValueChanged<TimeOfDay> onPicked) async {
    final t = await showTimePicker(context: context, initialTime: initial);
    if (t != null) onPicked(t);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;

    Widget label(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
          child: Text(text.toUpperCase(), style: t.labelSmall?.copyWith(letterSpacing: 1.2)),
        );

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings', subtitle: 'Appearance & reminders'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          // ---------------- APPEARANCE ----------------
          label('Appearance'),
          DashboardCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Theme', style: t.titleSmall),
                const SizedBox(height: 4),
                Text('Choose how E-Campus looks on your device.', style: t.bodySmall),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _ThemeOption(
                        icon: Icons.brightness_auto_rounded,
                        label: 'System',
                        selected: s.themeMode == ThemeMode.system,
                        onTap: () => s.setThemeMode(ThemeMode.system)),
                    const SizedBox(width: 10),
                    _ThemeOption(
                        icon: Icons.light_mode_rounded,
                        label: 'Light',
                        selected: s.themeMode == ThemeMode.light,
                        onTap: () => s.setThemeMode(ThemeMode.light)),
                    const SizedBox(width: 10),
                    _ThemeOption(
                        icon: Icons.dark_mode_rounded,
                        label: 'Dark',
                        selected: s.themeMode == ThemeMode.dark,
                        onTap: () => s.setThemeMode(ThemeMode.dark)),
                  ],
                ),
              ],
            ),
          ),

          // ---------------- NOTIFICATIONS ----------------
          label('Notifications & reminders'),
          DashboardCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                _SwitchTile(
                  icon: Icons.notifications_active_rounded,
                  color: AppColors.secondary,
                  title: 'Enable notifications',
                  subtitle: 'Master switch for all reminders',
                  value: s.notificationsEnabled,
                  onChanged: (v) async {
                    final ok = await s.setNotificationsEnabled(v);
                    if (!ok && context.mounted) {
                      showSnack(context, 'Notification permission denied. Enable it from system settings.');
                    }
                  },
                ),
                _divider(p),
                _SwitchTile(
                  icon: Icons.assignment_rounded,
                  color: AppColors.warning,
                  title: 'Assignment reminders',
                  subtitle: s.assignmentReminders
                      ? 'Daily at ${s.assignmentTime.format(context)}'
                      : 'Get nudged about pending deadlines',
                  value: s.assignmentReminders,
                  enabled: s.notificationsEnabled,
                  onChanged: s.setAssignmentReminders,
                ),
                if (s.notificationsEnabled && s.assignmentReminders)
                  _TimeRow(
                    time: s.assignmentTime.format(context),
                    onTap: () => _pickTime(context, s.assignmentTime, s.setAssignmentTime),
                  ),
                _divider(p),
                _SwitchTile(
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.success,
                  title: 'Class reminders',
                  subtitle: s.classReminders
                      ? 'Daily at ${s.classTime.format(context)}'
                      : "A morning nudge about today's timetable",
                  value: s.classReminders,
                  enabled: s.notificationsEnabled,
                  onChanged: s.setClassReminders,
                ),
                if (s.notificationsEnabled && s.classReminders)
                  _TimeRow(
                    time: s.classTime.format(context),
                    onTap: () => _pickTime(context, s.classTime, s.setClassTime),
                  ),
                _divider(p),
                _SwitchTile(
                  icon: Icons.newspaper_rounded,
                  color: AppColors.accent,
                  title: 'News alerts',
                  subtitle: 'Important college & tech news',
                  value: s.newsAlerts,
                  enabled: s.notificationsEnabled,
                  onChanged: s.setNewsAlerts,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            label: 'Send test notification',
            icon: Icons.send_rounded,
            outlined: true,
            onPressed: s.notificationsEnabled
                ? () async {
                    await NotificationService.showTest();
                    if (context.mounted) showSnack(context, 'Test notification sent');
                  }
                : null,
          ),

          // ---------------- ACCOUNT ----------------
          label('Account'),
          DashboardCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                _NavTile(
                    icon: Icons.lock_rounded,
                    title: 'Change password',
                    onTap: () => showSnack(context, 'Coming soon')),
                _divider(p),
                _NavTile(
                    icon: Icons.privacy_tip_rounded,
                    title: 'Privacy & security',
                    onTap: () => showSnack(context, 'Coming soon')),
                _divider(p),
                _NavTile(
                    icon: Icons.help_rounded, title: 'Help & support', onTap: () => showSnack(context, 'Coming soon')),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Center(child: Text('E-Campus  •  Version 1.0.0', style: t.bodySmall)),
        ],
      ),
    );
  }

  Widget _divider(Pal p) => Divider(height: 1, color: p.border);
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeOption({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: '$label theme',
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: selected ? p.primary.withOpacity(0.12) : p.soft,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? p.primary : Colors.transparent, width: 1.6),
            ),
            child: Column(
              children: [
                Icon(icon, color: selected ? p.primary : p.subtext),
                const SizedBox(height: 6),
                Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? p.primary : p.subtext)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: t.titleSmall),
                const SizedBox(height: 2),
                Text(subtitle, style: t.bodySmall),
              ]),
            ),
            Switch(value: value && enabled, onChanged: enabled ? onChanged : null),
          ],
        ),
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String time;
  final VoidCallback onTap;
  const _TimeRow({required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 56, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(12)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.access_time_rounded, size: 17, color: p.primary),
              const SizedBox(width: 8),
              Text('Remind me at $time',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: p.primary)),
              const SizedBox(width: 4),
              Icon(Icons.edit_rounded, size: 14, color: p.subtext),
            ]),
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _NavTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(children: [
          Icon(icon, size: 21, color: p.subtext),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall)),
          Icon(Icons.chevron_right_rounded, color: p.subtext),
        ]),
      ),
    );
  }
}

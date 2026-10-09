import 'package:flutter/material.dart';

import '../core/models/models.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/nav.dart';
import 'custom_app_bar.dart';
import 'user_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final AppUser user;
  final VoidCallback onMenu, onBell;
  const ProfileHeader({super.key, required this.user, required this.onMenu, required this.onBell});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final top = MediaQuery.of(context).padding.top;

    Widget chip(IconData i, String s) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(i, size: 14, color: Colors.white),
            const SizedBox(width: 5),
            Flexible(
              child: Text(s,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ]),
        );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.brandGradient),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -40,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), shape: BoxShape.circle),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -60,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), shape: BoxShape.circle),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, top + 12, 20, 26),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onMenu,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration:
                              BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
                          child: const Icon(Icons.menu_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                      const Spacer(),
                      BellButton(onTap: onBell, count: 2, onGradient: true),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(roleLabel(user.role).toUpperCase(),
                                style: t.labelSmall?.copyWith(color: Colors.white70, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            Text('${greeting()}, ${user.shortName} 👋',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: t.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                chip(Icons.apartment_rounded, user.department),
                                chip(Icons.calendar_month_rounded, user.semester),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: UserAvatar(initials: user.initials, radius: 30),
                      ),
                    ],
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

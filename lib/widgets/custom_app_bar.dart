import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({super.key, required this.title, this.subtitle, this.actions, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final p = Pal.of(context);
    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      leadingWidth: leading != null || canPop ? 60 : 0,
      leading: leading ??
          (canPop
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _RoundIcon(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                )
              : null),
      titleSpacing: leading != null || canPop ? 4 : 20,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (subtitle != null)
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: p.subtext)),
        ],
      ),
      actions: [...?actions, const SizedBox(width: 8)],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _RoundIcon({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: p.card,
            shape: BoxShape.circle,
            boxShadow: p.shadow,
            border: p.dark ? Border.all(color: p.border) : null,
          ),
          child: Icon(icon, size: 20, color: p.text),
        ),
      ),
    );
  }
}

/// Bell icon with unread badge.
class BellButton extends StatelessWidget {
  final VoidCallback onTap;
  final int count;
  final bool onGradient;
  const BellButton({super.key, required this.onTap, this.count = 0, this.onGradient = false});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: onGradient ? Colors.white.withOpacity(0.18) : p.card,
              shape: BoxShape.circle,
              boxShadow: onGradient ? null : p.shadow,
            ),
            child: Icon(Icons.notifications_rounded, size: 21, color: onGradient ? Colors.white : p.text),
          ),
        ),
        if (count > 0)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: onGradient ? AppColors.secondary : p.card, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String? time;
  final bool mine;
  const MessageBubble({super.key, required this.text, required this.mine, this.time});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    final maxW = MediaQuery.of(context).size.width * 0.76;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset((mine ? 20 : -20) * (1 - v), 0), child: child),
      ),
      child: Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxW > 520 ? 520 : maxW),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          decoration: BoxDecoration(
            gradient: mine ? AppColors.brandGradient : null,
            color: mine ? null : p.card,
            border: !mine && p.dark ? Border.all(color: p.border) : null,
            boxShadow: mine ? null : p.shadow,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(mine ? 18 : 4),
              bottomRight: Radius.circular(mine ? 4 : 18),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, style: t.bodyMedium?.copyWith(color: mine ? Colors.white : p.text)),
              if (time != null) ...[
                const SizedBox(height: 4),
                Text(time!,
                    style: TextStyle(fontSize: 10.5, color: mine ? Colors.white70 : p.subtext)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final String hint;
  const MessageInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttach,
    this.hint = 'Type a message…',
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        decoration: BoxDecoration(
          color: p.card,
          border: Border(top: BorderSide(color: p.border)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (onAttach != null)
              IconButton(
                tooltip: 'Attach',
                onPressed: onAttach,
                icon: Icon(Icons.attach_file_rounded, color: p.subtext),
              ),
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: hint,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  enabledBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(gradient: AppColors.brandGradient, shape: BoxShape.circle),
              child: IconButton(
                tooltip: 'Send',
                onPressed: onSend,
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

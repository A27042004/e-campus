import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  final ChatPreview chat;
  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _c = TextEditingController();
  final _scroll = ScrollController();
  bool _typing = false;
  Timer? _timer;

  late final List<ChatMessage> _msgs = [
    ChatMessage('Hey! Did you check the latest notes?', '09:10', false),
    ChatMessage('Yes, just went through unit 3 👍', '09:12', true),
    ChatMessage(widget.chat.last, '09:15', false),
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String _now() {
    final n = TimeOfDay.now();
    return '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }

  void _toBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(_scroll.position.maxScrollExtent + 80,
              duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        }
      });

  void _send() {
    final text = _c.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(ChatMessage(text, _now(), true));
      _typing = true;
    });
    _c.clear();
    _toBottom();
    _timer = Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        _msgs.add(ChatMessage('Got it, thanks! 🙌', _now(), false));
      });
      _toBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    final chat = widget.chat;
    final parts = chat.name.replaceAll(RegExp(r'^(Dr\.|Prof\.)\s*'), '').split(' ');
    final initials = parts.length > 1 ? (parts[0][0] + parts[1][0]).toUpperCase() : parts[0][0];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
            tooltip: 'Back', icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.maybePop(context)),
        title: Row(children: [
          UserAvatar(initials: initials, radius: 20, online: chat.online, group: chat.group),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(chat.name, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(_typing ? 'typing…' : (chat.online ? 'Online' : (chat.group ? 'Group' : 'Last seen recently')),
                  style: t.bodySmall?.copyWith(color: _typing || chat.online ? p.primary : p.subtext)),
            ]),
          ),
        ]),
        actions: [
          IconButton(
              tooltip: 'More',
              onPressed: () => showSnack(context, 'More options coming soon'),
              icon: const Icon(Icons.more_vert_rounded)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(20)),
                    child: Text('Today', style: t.labelMedium),
                  ),
                ),
                for (final m in _msgs) MessageBubble(text: m.text, time: m.time, mine: m.mine),
                if (_typing)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: p.card,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: p.shadow,
                        border: p.dark ? Border.all(color: p.border) : null,
                      ),
                      child: const TypingIndicator(),
                    ),
                  ),
              ],
            ),
          ),
          MessageInputBar(
            controller: _c,
            onSend: _send,
            onAttach: () => showSnack(context, 'Attachments coming soon'),
          ),
        ],
      ),
    );
  }
}

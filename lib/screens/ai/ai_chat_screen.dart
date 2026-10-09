import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/widgets.dart';

class _Msg {
  final String text;
  final bool mine;
  const _Msg(this.text, this.mine);
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _c = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _msgs = [];
  bool _thinking = false;
  Timer? _timer;

  static const _suggestions = [
    'What is distributed computing?',
    'Explain this topic simply.',
    'Help me prepare for my exam.',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// TODO: replace with a call to your backend / LLM API.
  String _reply(String q) {
    final s = q.toLowerCase();
    if (s.contains('distributed')) {
      return 'Distributed computing is when several computers work together over a network to solve one problem. '
          'Each machine handles a part of the work, and they coordinate by passing messages. '
          'Examples: web search, cloud services and blockchain networks.';
    }
    if (s.contains('exam') || s.contains('prepare')) {
      return "Here's a simple plan:\n\n1. List all topics from the syllabus\n2. Revise one topic per study block (45 min)\n"
          '3. Solve previous-year questions\n4. Take a short break between blocks\n5. Do a quick revision the day before.\n\n'
          'Tell me your subject and exam date and I can make it specific.';
    }
    if (s.contains('simply') || s.contains('explain')) {
      return 'Sure! Tell me the topic and I will explain it in plain language, with an everyday example.';
    }
    return "That's a great question! This demo assistant has limited answers, but once connected to an AI backend "
        'it can help with any subject. Try one of the suggestions above.';
  }

  void _toBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(_scroll.position.maxScrollExtent + 100,
              duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        }
      });

  void _send([String? preset]) {
    final text = (preset ?? _c.text).trim();
    if (text.isEmpty || _thinking) return;
    setState(() {
      _msgs.add(_Msg(text, true));
      _thinking = true;
    });
    _c.clear();
    _toBottom();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        _thinking = false;
        _msgs.add(_Msg(_reply(text), false));
      });
      _toBottom();
    });
  }

  Widget _aiAvatar(double s) => Container(
        width: s,
        height: s,
        decoration: const BoxDecoration(gradient: AppColors.brandGradient, shape: BoxShape.circle),
        child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: s * 0.52),
      );

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Campus AI',
        subtitle: 'Ask anything about your studies',
        actions: [
          IconButton(
            tooltip: 'New chat',
            onPressed: () => setState(_msgs.clear),
            icon: const Icon(Icons.add_comment_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _msgs.isEmpty && !_thinking
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: FadeSlideIn(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Stack(alignment: Alignment.center, children: [
                            Container(
                                width: 124,
                                height: 124,
                                decoration: BoxDecoration(color: p.primary.withOpacity(0.08), shape: BoxShape.circle)),
                            _aiAvatar(84),
                          ]),
                          const SizedBox(height: 20),
                          Text('Hi, I am Campus AI 👋', style: t.headlineSmall),
                          const SizedBox(height: 6),
                          Text('Your friendly study companion. Pick a question or type your own.',
                              textAlign: TextAlign.center, style: t.bodyMedium?.copyWith(color: p.subtext)),
                          const SizedBox(height: 28),
                          for (final s in _suggestions)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: DashboardCard(
                                onTap: () => _send(s),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                radius: 16,
                                child: Row(children: [
                                  Icon(Icons.lightbulb_outline_rounded, color: p.primary, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(s, style: t.titleSmall)),
                                  Icon(Icons.arrow_forward_rounded, size: 18, color: p.subtext),
                                ]),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    children: [
                      for (final m in _msgs)
                        m.mine
                            ? MessageBubble(text: m.text, mine: true)
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: const EdgeInsets.only(top: 4, right: 8), child: _aiAvatar(30)),
                                  Expanded(child: MessageBubble(text: m.text, mine: false)),
                                ],
                              ),
                      if (_thinking)
                        Row(children: [
                          Padding(padding: const EdgeInsets.only(right: 8), child: _aiAvatar(30)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: p.card,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: p.shadow,
                              border: p.dark ? Border.all(color: p.border) : null,
                            ),
                            child: const TypingIndicator(),
                          ),
                        ]),
                    ],
                  ),
          ),
          MessageInputBar(controller: _c, onSend: _send, hint: 'Ask Campus AI…'),
        ],
      ),
    );
  }
}

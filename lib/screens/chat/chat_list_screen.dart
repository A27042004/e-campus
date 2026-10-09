import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../core/utils/nav.dart';
import '../../data/mock_data.dart';
import '../../widgets/widgets.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<ChatPreview>> _future = MockApi.chats();

  void _reload() => setState(() => _future = MockApi.chats());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Chat', subtitle: 'Classmates, teachers & groups'),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New message',
        onPressed: () => showSnack(context, 'New chat coming soon'),
        child: const Icon(Icons.edit_rounded),
      ),
      body: AsyncBody<List<ChatPreview>>(
        future: _future,
        onRetry: _reload,
        isEmpty: (l) => l.isEmpty,
        empty: const EmptyStateWidget(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'No messages yet',
          message: 'Start a conversation with a classmate or teacher.',
        ),
        builder: (context, list) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
          itemCount: list.length,
          separatorBuilder: (_, __) => Divider(height: 1, indent: 72, color: Theme.of(context).dividerColor),
          itemBuilder: (_, i) => FadeSlideIn(
            delayMs: 40 * i,
            child: ChatTile(chat: list[i], onTap: () => pushPage(context, ChatScreen(chat: list[i]))),
          ),
        ),
      ),
    );
  }
}

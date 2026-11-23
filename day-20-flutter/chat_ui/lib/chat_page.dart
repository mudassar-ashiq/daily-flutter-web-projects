import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'message_bubble.dart';
import 'models.dart';
import 'sample_chats.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  bool _typing = false;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    // Opening a chat marks it as read.
    widget.chat.unread = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    setState(() {
      widget.chat.messages.add(
        ChatMessage(text: text, sentByMe: true, time: DateTime.now()),
      );
    });
    _scrollToBottom();
    _fakeReply();
  }

  // Pretend the other person is typing, then send a short reply back.
  void _fakeReply() {
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _typing = true);
      _scrollToBottom();
    });
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        widget.chat.messages.add(
          ChatMessage(
            text: quickReplies[_random.nextInt(quickReplies.length)],
            sentByMe: false,
            time: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    final colour = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: chat.isGroup
                  ? Colors.teal.shade700
                  : colour.primary,
              child: Text(
                chat.initials,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chat.name, style: const TextStyle(fontSize: 16)),
                  Text(
                    chat.online ? 'Online' : 'Last seen recently',
                    style: TextStyle(
                      fontSize: 12,
                      color: colour.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: chat.messages.length + (_typing ? 1 : 0),
              itemBuilder: (context, index) {
                if (_typing && index == chat.messages.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'typing...',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }
                final message = chat.messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
            color: colour.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: colour.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: colour.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

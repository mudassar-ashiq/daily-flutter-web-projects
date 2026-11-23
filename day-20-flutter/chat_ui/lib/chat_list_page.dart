import 'package:flutter/material.dart';

import 'chat_page.dart';
import 'models.dart';
import 'sample_chats.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late List<Chat> chats;
  String query = '';

  @override
  void initState() {
    super.initState();
    chats = sampleChats();
  }

  List<Chat> get visible {
    if (query.isEmpty) return chats;
    final q = query.toLowerCase();
    return chats.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  void _openChat(Chat chat) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ChatPage(chat: chat)));
    // Refresh the list when coming back, unread counts may have changed.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colour = Theme.of(context).colorScheme;
    final list = visible;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            tooltip: 'More',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                hintText: 'Search chats',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colour.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('No chats found'))
                : ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (context, index) {
                      final chat = list[index];
                      return Dismissible(
                        key: ValueKey(chat.name),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red.shade400,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          setState(() => chats.remove(chat));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${chat.name} deleted'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  setState(() => chats.insert(index, chat));
                                },
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: chat.isGroup
                                    ? Colors.teal.shade700
                                    : colour.primary,
                                child: Text(
                                  chat.initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (chat.online)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colour.surface,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            chat.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            chat.preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                shortTime(chat.lastMessage.time),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: chat.unread > 0
                                      ? colour.primary
                                      : colour.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (chat.unread > 0)
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: colour.primary,
                                  child: Text(
                                    '${chat.unread}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () => _openChat(chat),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'New chat',
        child: const Icon(Icons.chat),
      ),
    );
  }
}

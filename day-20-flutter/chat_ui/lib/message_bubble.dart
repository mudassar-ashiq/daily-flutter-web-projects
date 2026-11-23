import 'package:flutter/material.dart';

import 'models.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showTime;

  const MessageBubble({super.key, required this.message, this.showTime = true});

  @override
  Widget build(BuildContext context) {
    final colour = Theme.of(context).colorScheme;
    final mine = message.sentByMe;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: mine ? colour.primaryContainer : colour.surfaceContainer,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(mine ? 14 : 4),
            bottomRight: Radius.circular(mine ? 4 : 14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.text, style: const TextStyle(fontSize: 15)),
            if (showTime) ...[
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    shortTime(message.time),
                    style: TextStyle(
                      fontSize: 11,
                      color: colour.onSurfaceVariant,
                    ),
                  ),
                  if (mine) ...[
                    const SizedBox(width: 4),
                    Icon(
                      message.read ? Icons.done_all : Icons.done,
                      size: 15,
                      color: message.read
                          ? Colors.blue
                          : colour.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

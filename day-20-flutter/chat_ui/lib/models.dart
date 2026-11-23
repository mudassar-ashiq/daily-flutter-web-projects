class ChatMessage {
  final String text;
  final bool sentByMe;
  final DateTime time;
  final bool read;

  ChatMessage({
    required this.text,
    required this.sentByMe,
    required this.time,
    this.read = false,
  });

  ChatMessage copyWith({bool? read}) {
    return ChatMessage(
      text: text,
      sentByMe: sentByMe,
      time: time,
      read: read ?? this.read,
    );
  }
}

class Chat {
  final String name;
  final String initials;
  final bool online;
  final bool isGroup;
  final List<ChatMessage> messages;
  int unread;

  Chat({
    required this.name,
    required this.initials,
    this.online = false,
    this.isGroup = false,
    required this.messages,
    this.unread = 0,
  });

  ChatMessage get lastMessage => messages.last;

  String get preview {
    final text = lastMessage.text;
    if (text.length <= 42) return text;
    return '${text.substring(0, 42)}...';
  }
}

// Short time label, like 09:41 or Yesterday.
String shortTime(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(time.year, time.month, time.day);
  if (day == today) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
  if (day == today.subtract(const Duration(days: 1))) {
    return 'Yesterday';
  }
  return '${time.day}/${time.month}/${time.year}';
}

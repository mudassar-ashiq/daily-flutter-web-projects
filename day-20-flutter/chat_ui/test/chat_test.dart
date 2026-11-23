import 'package:chat_ui/models.dart';
import 'package:chat_ui/sample_chats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('preview cuts off long last messages', () {
    final chat = Chat(
      name: 'Test',
      initials: 'T',
      messages: [
        ChatMessage(
          text:
              'This is a very long message that goes on and on past the limit',
          sentByMe: false,
          time: DateTime.now(),
        ),
      ],
    );
    expect(chat.preview.endsWith('...'), isTrue);
    expect(chat.preview.length, 45);
  });

  test('short message is shown in full in the preview', () {
    final chat = Chat(
      name: 'Test',
      initials: 'T',
      messages: [
        ChatMessage(text: 'Hi', sentByMe: false, time: DateTime.now()),
      ],
    );
    expect(chat.preview, 'Hi');
  });

  test('shortTime shows the time for a message from today', () {
    final now = DateTime.now();
    final time = DateTime(now.year, now.month, now.day, 9, 5);
    expect(shortTime(time), '9:05 AM');
  });

  test('shortTime says Yesterday for a message from yesterday', () {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final time = DateTime(
      yesterday.year,
      yesterday.month,
      yesterday.day,
      18,
      30,
    );
    expect(shortTime(time), 'Yesterday');
  });

  test('copyWith can mark a message as read', () {
    final message = ChatMessage(
      text: 'Hello',
      sentByMe: true,
      time: DateTime.now(),
    );
    expect(message.read, isFalse);
    expect(message.copyWith(read: true).read, isTrue);
    expect(message.copyWith(read: true).text, 'Hello');
  });

  test('sample chats have messages and one group chat', () {
    final chats = sampleChats();
    expect(chats.length, 7);
    expect(chats.where((c) => c.isGroup).length, 1);
    for (final chat in chats) {
      expect(chat.messages.isNotEmpty, isTrue);
    }
  });

  test('unread chats add up', () {
    final chats = sampleChats();
    final total = chats.fold<int>(0, (sum, c) => sum + c.unread);
    expect(total, 6);
  });

  test('quick replies are all short', () {
    for (final reply in quickReplies) {
      expect(reply.length, lessThan(40));
    }
  });
}

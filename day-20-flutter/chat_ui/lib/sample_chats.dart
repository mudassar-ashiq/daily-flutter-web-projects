import 'models.dart';

// A few sample conversations so the screens have something real to show.
List<Chat> sampleChats() {
  final now = DateTime.now();
  DateTime at(int hour, int minute, {int daysAgo = 0}) {
    final day = now.subtract(Duration(days: daysAgo));
    return DateTime(day.year, day.month, day.day, hour, minute);
  }

  return [
    Chat(
      name: 'BSSE-A Class Group',
      initials: 'BG',
      isGroup: true,
      unread: 3,
      messages: [
        ChatMessage(
          text: 'Sir Arslan shared the MAD slides for week 12',
          sentByMe: false,
          time: at(8, 12),
        ),
        ChatMessage(
          text: 'Thanks, downloading them now',
          sentByMe: true,
          time: at(8, 15),
          read: true,
        ),
        ChatMessage(
          text: 'Quiz is on Thursday, not Friday',
          sentByMe: false,
          time: at(9, 2),
        ),
        ChatMessage(
          text: 'Can someone share the lab task file?',
          sentByMe: false,
          time: at(9, 20),
        ),
        ChatMessage(
          text: 'I will send it after class',
          sentByMe: false,
          time: at(9, 31),
        ),
      ],
    ),
    Chat(
      name: 'Ahmed Raza',
      initials: 'AR',
      online: true,
      unread: 1,
      messages: [
        ChatMessage(
          text: 'Did you finish the OS assignment?',
          sentByMe: false,
          time: at(20, 5, daysAgo: 1),
        ),
        ChatMessage(
          text: 'Almost, just the last question left',
          sentByMe: true,
          time: at(20, 18, daysAgo: 1),
          read: true,
        ),
        ChatMessage(
          text: 'Send me your notes for paging when you are done',
          sentByMe: false,
          time: at(8, 47),
        ),
      ],
    ),
    Chat(
      name: 'Sara Malik',
      initials: 'SM',
      online: true,
      messages: [
        ChatMessage(
          text: 'The Flutter project looks good',
          sentByMe: false,
          time: at(21, 40, daysAgo: 1),
        ),
        ChatMessage(
          text: 'Thanks, I changed the colours today',
          sentByMe: true,
          time: at(21, 52, daysAgo: 1),
          read: true,
        ),
        ChatMessage(
          text: 'Much better now, the home screen is clean',
          sentByMe: false,
          time: at(22, 3, daysAgo: 1),
        ),
      ],
    ),
    Chat(
      name: 'Bilal Hussain',
      initials: 'BH',
      unread: 2,
      messages: [
        ChatMessage(
          text: 'Are we meeting at the library at 10?',
          sentByMe: false,
          time: at(7, 58),
        ),
        ChatMessage(
          text: 'Yes, I will bring the SCaD slides',
          sentByMe: false,
          time: at(8, 5),
        ),
      ],
    ),
    Chat(
      name: 'Ayesha Khan',
      initials: 'AK',
      messages: [
        ChatMessage(
          text: 'Happy birthday! Hope you have a good day',
          sentByMe: true,
          time: at(10, 30, daysAgo: 2),
          read: true,
        ),
        ChatMessage(
          text: 'Thank you so much',
          sentByMe: false,
          time: at(11, 2, daysAgo: 2),
        ),
      ],
    ),
    Chat(
      name: 'Hassan Ali',
      initials: 'HA',
      online: true,
      messages: [
        ChatMessage(
          text: 'Cricket on Sunday? Ground is booked for 4 pm',
          sentByMe: false,
          time: at(18, 44, daysAgo: 3),
        ),
        ChatMessage(
          text: 'Count me in, I will bring the bat',
          sentByMe: true,
          time: at(19, 1, daysAgo: 3),
          read: true,
        ),
      ],
    ),
    Chat(
      name: 'Fatima Zahra',
      initials: 'FZ',
      messages: [
        ChatMessage(
          text: 'Did you see the new timetable?',
          sentByMe: false,
          time: at(9, 15, daysAgo: 4),
        ),
        ChatMessage(
          text: 'Yes, Thursday classes moved to room B10',
          sentByMe: true,
          time: at(9, 40, daysAgo: 4),
          read: true,
        ),
      ],
    ),
  ];
}

// A short reply the other person sends back after a message.
const List<String> quickReplies = [
  'Sounds good',
  'Okay, let me check and tell you',
  'Yes, that works for me',
  'Give me a minute',
  'Sure, no problem',
];

import 'package:chat_ui/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('chat list shows the sample chats', (tester) async {
    await tester.pumpWidget(const ChatUiApp());
    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Ahmed Raza'), findsOneWidget);
    expect(find.text('BSSE-A Class Group'), findsOneWidget);
  });

  testWidgets('search filters the chat list', (tester) async {
    await tester.pumpWidget(const ChatUiApp());
    await tester.enterText(find.byType(TextField), 'Sara');
    await tester.pump();
    expect(find.text('Sara Malik'), findsOneWidget);
    expect(find.text('Ahmed Raza'), findsNothing);
  });

  testWidgets('tapping a chat opens the conversation', (tester) async {
    await tester.pumpWidget(const ChatUiApp());
    await tester.tap(find.text('Ahmed Raza'));
    await tester.pumpAndSettle();
    expect(find.text('Type a message'), findsOneWidget);
    expect(
      find.text('Send me your notes for paging when you are done'),
      findsOneWidget,
    );
  });

  testWidgets('sending a message adds a bubble', (tester) async {
    await tester.pumpWidget(const ChatUiApp());
    await tester.tap(find.text('Sara Malik'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'See you tomorrow');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text('See you tomorrow'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';

import 'chat_list_page.dart';

void main() {
  runApp(const ChatUiApp());
}

class ChatUiApp extends StatelessWidget {
  const ChatUiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      home: const ChatListPage(),
    );
  }
}

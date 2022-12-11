import 'package:flutter/material.dart';

import 'chat/ui/chat_rooms_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatRoomsPage(title: 'Flutter Demo Home Page'),
    );
  }
}

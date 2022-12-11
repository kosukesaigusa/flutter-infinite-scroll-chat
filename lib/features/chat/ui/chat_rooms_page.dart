import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatRoomsPage extends HookConsumerWidget {
  const ChatRoomsPage({super.key});

  static const path = '/';
  static const name = 'ChatRoomsPage';
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Rooms')),
      body: const SizedBox(),
    );
  }
}

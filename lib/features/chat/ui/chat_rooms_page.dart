import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/loading.dart';
import '../chat.dart';
import '../chat_room.dart';

class ChatRoomsPage extends HookConsumerWidget {
  const ChatRoomsPage({super.key});

  static const path = '/';
  static const name = 'ChatRoomsPage';
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Rooms')),
      body: ref.watch(chatRoomsProvider).when(
            data: (chatRooms) {
              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) => _ChatRoom(chatRooms[index]),
              );
            },
            error: (_, __) => Text(_.toString()),
            loading: PrimarySpinkitCircle.new,
          ),
    );
  }
}

class _ChatRoom extends StatelessWidget {
  const _ChatRoom(this.chatRoom);

  final ChatRoom chatRoom;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chatRoom.chatRoomId),
            if (chatRoom.updatedAt.dateTime != null)
              Text(chatRoom.updatedAt.dateTime!.toIso8601String())
          ],
        ),
      ),
    );
  }
}

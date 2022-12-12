import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../firestore/chat_room.dart';
import '../../../utils/extensions/date_time.dart';
import '../../../utils/loading.dart';
import '../chat.dart';
import 'chat_room_page.dart';

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
            error: (_, __) => const SizedBox(),
            loading: PrimarySpinkitCircle.new,
          ),
    );
  }
}

class _ChatRoom extends HookConsumerWidget {
  const _ChatRoom(this.chatRoom);

  final ChatRoom chatRoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(latestMessageProvider(chatRoom.chatRoomId));
    return InkWell(
      onTap: () => Navigator.pushNamed<void>(
        context,
        ChatRoomPage.location(chatRoomId: chatRoom.chatRoomId),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('チャットルーム ID：${chatRoom.chatRoomId}'),
            if (message != null) ...[
              Text('直近のメッセージ：${message.content}'),
              if (message.createdAt.dateTime != null)
                Text(message.createdAt.dateTime!.toYYYYMMDDHHMM()),
            ]
          ],
        ),
      ),
    );
  }
}

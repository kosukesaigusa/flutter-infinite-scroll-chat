import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_models/chat_room.dart';
import '../../firestore_models/message.dart';
import '../../repositories/chat.dart';
import 'chat_room_controller.dart';
import 'chat_room_state.dart';

final chatRoomsProvider = StreamProvider.autoDispose<List<ChatRoom>>(
  (ref) => ref.read(chatRepositoryProvider).subscribeChatRooms(),
);

final chatRoomControllerProvider = StateNotifierProvider.autoDispose
    .family<ChatRoomController, ChatRoomState, String>(ChatRoomController.new);

final _latestMessagesProvider = StreamProvider.autoDispose.family<List<Message>, String>(
  (ref, chatRoomId) => ref.read(chatRepositoryProvider).subscribeMessages(
        chatRoomId: chatRoomId,
        queryBuilder: (q) => q.orderBy('createdAt', descending: true).limit(1),
      ),
);

final latestMessageProvider = Provider.autoDispose.family<Message?, String>(
  (ref, chatRoomId) => ref.watch(_latestMessagesProvider(chatRoomId)).when(
        data: (messages) => messages.isNotEmpty ? messages.first : null,
        error: (_, __) => null,
        loading: () => null,
      ),
);

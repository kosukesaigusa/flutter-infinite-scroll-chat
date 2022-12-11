import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_models/chat_room.dart';
import '../../repositories/chat.dart';
import 'chat_room_controller.dart';
import 'chat_room_state.dart';

final chatRoomsProvider = StreamProvider.autoDispose<List<ChatRoom>>(
  (ref) => ref.read(chatRepositoryProvider).subscribeChatRooms(),
);

final chatRoomControllerProvider =
    StateNotifierProvider.autoDispose.family<ChatRoomController, ChatRoomState, String>(
  (ref, chatRoomId) => ChatRoomController(ref, chatRoomId)..initialize(),
);

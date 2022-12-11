import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/chat.dart';
import 'chat_room.dart';

final chatRoomsProvider = StreamProvider.autoDispose<List<ChatRoom>>(
  (ref) => ref.read(chatRepositoryProvider).subscribeChatRooms(),
);

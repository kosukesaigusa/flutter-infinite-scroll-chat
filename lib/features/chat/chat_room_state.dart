import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../firestore/message.dart';

part 'chat_room_state.freezed.dart';

@freezed
class ChatRoomState with _$ChatRoomState {
  const factory ChatRoomState({
    @Default(true) bool loading,
    @Default(false) bool sending,
    @Default(false) bool isValid,
    @Default(<Message>[]) List<Message> messages,
    @Default(<Message>[]) List<Message> newMessages,
    @Default(<Message>[]) List<Message> pastMessages,
    @Default(false) bool fetching,
    @Default(true) bool hasMore,
    QueryDocumentSnapshot<Message>? lastReadQueryDocumentSnapshot,
  }) = _ChatRoomState;
}

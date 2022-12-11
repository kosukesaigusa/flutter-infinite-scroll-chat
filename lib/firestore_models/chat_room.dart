import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/json_converters/union_timestamp.dart';

part 'chat_room.freezed.dart';
part 'chat_room.g.dart';

@freezed
class ChatRoom with _$ChatRoom {
  const factory ChatRoom({
    @Default('') String chatRoomId,
    @Default(false) bool isDeleted,
    @alwaysUseServerTimestampUnionTimestampConverter
    @Default(UnionTimestamp.serverTimestamp())
        UnionTimestamp createdAt,
    @alwaysUseServerTimestampUnionTimestampConverter
    @Default(UnionTimestamp.serverTimestamp())
        UnionTimestamp updatedAt,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);

  factory ChatRoom.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ChatRoom.fromJson(<String, dynamic>{
      ...data,
      'chatRoomId': ds.id,
    });
  }
}

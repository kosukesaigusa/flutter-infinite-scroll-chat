import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/json_converters/union_timestamp.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    @Default('') String messageId,
    @Default('') String senderId,
    @Default('') String content,
    @alwaysUseServerTimestampUnionTimestampConverter
    @Default(UnionTimestamp.serverTimestamp())
        UnionTimestamp createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  factory Message.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Message.fromJson(<String, dynamic>{
      ...data,
      'messageId': ds.id,
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'features/app_user/app_user.dart';
import 'features/chat/chat_room.dart';
import 'features/chat/message.dart';

final db = FirebaseFirestore.instance;

/// appUsers コレクションの参照。
final appUsersRef = db.collection('appUsers').withConverter(
  fromFirestore: (ds, _) {
    return AppUser.fromDocumentSnapshot(ds);
  },
  toFirestore: (obj, _) {
    final json = obj.toJson();
    return json;
  },
);

/// appUser ドキュメントの参照。
DocumentReference<AppUser> appUserRef({
  required String appUserId,
}) =>
    appUsersRef.doc(appUserId);

/// chatRooms コレクションの参照。
final chatRoomsRef = db.collection('chatRooms').withConverter(
      fromFirestore: (ds, _) => ChatRoom.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// chatRoom ドキュメントの参照。
DocumentReference<ChatRoom> chatRoomRef({
  required String chatRoomId,
}) =>
    chatRoomsRef.doc(chatRoomId);

/// messages コレクションの参照。
CollectionReference<Message> messagesRef({
  required String chatRoomId,
}) =>
    chatRoomRef(chatRoomId: chatRoomId).collection('messages').withConverter(
          fromFirestore: (ds, _) => Message.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// message ドキュメントの参照。
DocumentReference<Message> messageRef({
  required String chatRoomId,
  required String messageId,
}) =>
    messagesRef(chatRoomId: chatRoomId).doc(messageId);

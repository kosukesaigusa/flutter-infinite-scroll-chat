import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:infinite_scroll_chat/firestore/app_user.dart';
import 'package:infinite_scroll_chat/firestore/chat_room.dart';
import 'package:infinite_scroll_chat/firestore/message.dart';

final mockDb = FakeFirebaseFirestore();

/// appUsers コレクションの参照。
final mockAppUsersRef = mockDb.collection('appUsers').withConverter(
  fromFirestore: (ds, _) {
    return AppUser.fromDocumentSnapshot(ds);
  },
  toFirestore: (obj, _) {
    final json = obj.toJson();
    return json;
  },
);

/// appUser ドキュメントの参照。
DocumentReference<AppUser> mockAppUserRef({
  required String appUserId,
}) =>
    mockAppUsersRef.doc(appUserId);

/// chatRooms コレクションの参照。
final mockChatRoomsRef = mockDb.collection('chatRooms').withConverter(
      fromFirestore: (ds, _) => ChatRoom.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// chatRoom ドキュメントの参照。
DocumentReference<ChatRoom> mockChatRoomRef({
  required String chatRoomId,
}) =>
    mockChatRoomsRef.doc(chatRoomId);

/// messages コレクションの参照。
CollectionReference<Message> mockMessagesRef({
  required String chatRoomId,
}) =>
    mockChatRoomRef(chatRoomId: chatRoomId).collection('messages').withConverter(
          fromFirestore: (ds, _) => Message.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// message ドキュメントの参照。
DocumentReference<Message> mockMessageRef({
  required String chatRoomId,
  required String messageId,
}) =>
    mockMessagesRef(chatRoomId: chatRoomId).doc(messageId);

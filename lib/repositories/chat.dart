import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_models/chat_room.dart';
import '../firestore_models/message.dart';
import '../firestore_refs.dart';

final chatRepository = Provider.autoDispose<ChatRepository>((_) => ChatRepository());

class ChatRepository {
  /// ChatRoom 一覧を購読する。
  Stream<List<ChatRoom>> subscribeChatRooms({
    Query<ChatRoom>? Function(Query<ChatRoom> query)? queryBuilder,
    int Function(ChatRoom lhs, ChatRoom rhs)? compare,
  }) {
    Query<ChatRoom> query = chatRoomsRef;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    return query.snapshots().map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }

  /// 最後に取得したドキュメント以降のメッセージ limit 件の QuerySnapshot を返す。
  Future<QuerySnapshot<Message>> loadMoreMessagesQuerySnapshot({
    required int limit,
    required String chatRoomId,
    required QueryDocumentSnapshot<Message>? lastReadQueryDocumentSnapshot,
  }) async {
    final qs = await _query(
      limit: limit,
      chatRoomId: chatRoomId,
      lastReadQueryDocumentSnapshot: lastReadQueryDocumentSnapshot,
    ).limit(limit).get();
    return qs;
  }

  /// 最後に取得したドキュメント以降のメッセージ limit 件を取得するための
  /// Query<Message> を返す。メッセージの無限スクロールに用いる。
  Query<Message> _query({
    required int limit,
    required String chatRoomId,
    required QueryDocumentSnapshot<Message>? lastReadQueryDocumentSnapshot,
  }) {
    var query = messagesRef(chatRoomId: chatRoomId).orderBy('createdAt', descending: true);
    final qds = lastReadQueryDocumentSnapshot;
    if (qds != null) {
      query = query.startAfterDocument(qds);
    }
    return query.limit(limit);
  }

  /// Message 一覧を購読する。
  Stream<List<Message>> subscribeMessages({
    required String chatRoomId,
    Query<Message>? Function(Query<Message> query)? queryBuilder,
    int Function(Message lhs, Message rhs)? compare,
  }) {
    Query<Message> query = messagesRef(chatRoomId: chatRoomId);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    return query.snapshots().map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }
}

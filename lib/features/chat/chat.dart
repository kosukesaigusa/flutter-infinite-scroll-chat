import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../../firestore/chat_room.dart';
import '../../firestore/message.dart';
import '../../firestore/refs.dart';
import '../../repositories/chat.dart';
import '../../utils/exceptions/base.dart';
import '../../utils/uuid.dart';
import '../auth/auth.dart';
import 'chat_state.dart';

/// チャットルーム一覧を取得する StreamProvider。
final chatRoomsProvider = StreamProvider.autoDispose<List<ChatRoom>>(
  (ref) => ref.read(baseChatRepositoryProvider).subscribeChatRooms(),
);

/// 指定したチャットルームの最新 1 件のメッセージを取得する Provider。
final latestMessageProvider = Provider.autoDispose.family<Message?, String>(
  (ref, chatRoomId) => ref.watch(latestMessagesProvider(Tuple2<String, int>(chatRoomId, 1))).when(
        data: (messages) => messages.isNotEmpty ? messages.first : null,
        error: (_, __) => null,
        loading: () => null,
      ),
);

/// 指定したチャットルームの指定した最新件数のメッセージを購読する Provider。
@visibleForTesting
final latestMessagesProvider =
    StreamProvider.autoDispose.family<List<Message>, Tuple2<String, int>>(
  (ref, tuple2) => ref.read(baseChatRepositoryProvider).subscribeMessages(
        chatRoomId: tuple2.item1,
        queryBuilder: (q) => q.orderBy('createdAt', descending: true).limit(tuple2.item2),
      ),
);

/// ChatRoomState の操作とチャットルームページの振る舞いを記述したモデル。
final chatProvider = StateNotifierProvider.autoDispose.family<Chat, ChatState, String>(Chat.new);

/// ChatRoomState の操作とチャットルームページの振る舞いを記述したモデル。
class Chat extends StateNotifier<ChatState> {
  Chat(this._ref, this._chatRoomId) : super(const ChatState()) {
    Future<void>(() async {
      await Future.wait<void>([
        loadMore(),
        // ChatPage に遷移直後のメッセージアイコンを意図的に見せるために最低でも 500 ms 待つ。
        Future<void>.delayed(const Duration(milliseconds: 500)),
      ]);
      state = state.copyWith(loading: false);
    });
  }

  final AutoDisposeStateNotifierProviderRef<Chat, ChatState> _ref;

  /// チャットルームの ID。
  final String _chatRoomId;

  /// 無限スクロールで取得するメッセージ件数の limit 値。
  static const _limit = 10;

  /// この時刻以降のメッセージを新たなメッセージとしてリアルタイム取得する。
  final startDateTime = DateTime.now();

  /// 新着メッセージのサブスクリプション。
  /// リスナーで state.newMessages を更新する。
  StreamSubscription<List<Message>> get newMessagesSubscription => _ref
      .read(baseChatRepositoryProvider)
      .subscribeMessages(
        chatRoomId: _chatRoomId,
        queryBuilder: (q) => q
            .orderBy('createdAt', descending: true)
            .where('createdAt', isGreaterThanOrEqualTo: startDateTime),
      )
      .listen(_updateNewMessages);

  /// 過去のメッセージを、最後に取得した queryDocumentSnapshot 以降の
  /// limit 件だけ取得する。
  Future<void> loadMore() async {
    if (!state.hasMore) {
      state = state.copyWith(fetching: false);
      return;
    }
    if (state.fetching) {
      return;
    }
    state = state.copyWith(fetching: true);
    final qs = await _ref.read(baseChatRepositoryProvider).loadMoreMessagesQuerySnapshot(
          limit: _limit,
          chatRoomId: _chatRoomId,
          lastReadQueryDocumentSnapshot: state.lastReadQueryDocumentSnapshot,
        );
    final messages = qs.docs.map((qds) => qds.data()).toList();
    _updatePastMessages([...state.pastMessages, ...messages]);
    state = state.copyWith(
      fetching: false,
      lastReadQueryDocumentSnapshot: qs.docs.isNotEmpty ? qs.docs.last : null,
      hasMore: qs.docs.length >= _limit,
    );
  }

  /// 取得したメッセージ全体を更新する。
  void _updateMessages() {
    state = state.copyWith(messages: [...state.newMessages, ...state.pastMessages]);
  }

  /// チャットルーム画面に遷移した後に新たに取得したメッセージを更新した後、
  /// 取得したメッセージ全体も更新する。
  void _updateNewMessages(List<Message> newMessages) {
    state = state.copyWith(newMessages: newMessages);
    _updateMessages();
  }

  /// チャットルーム画面を遡って取得した過去のメッセージを更新した後、
  /// 取得したメッセージ全体も更新する。
  void _updatePastMessages(List<Message> pastMessages) {
    state = state.copyWith(pastMessages: pastMessages);
    _updateMessages();
  }

  /// メッセージを送信する。
  Future<void> sendMessage({
    required String text,
  }) async {
    if (state.sending) {
      return;
    }
    if (text.isEmpty) {
      throw const AppException(message: '内容を入力してください。');
    }
    final userId = _ref.read(userIdAsyncValueProvider).value;
    if (userId == null) {
      throw const AppException(message: 'メッセージの送信にはログインが必要です。');
    }
    state = state.copyWith(sending: true);
    final message = Message(
      messageId: uuid,
      senderId: userId,
      content: text,
    );
    try {
      await messageRef(
        chatRoomId: _chatRoomId,
        messageId: message.messageId,
      ).set(message);
    } finally {
      state = state.copyWith(sending: false);
    }
  }

  void updateIsValid({required bool isValid}) {
    state = state.copyWith(isValid: isValid);
  }
}

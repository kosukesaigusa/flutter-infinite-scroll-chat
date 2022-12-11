import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_models/message.dart';
import '../../firestore_refs.dart';
import '../../repositories/chat.dart';
import '../../utils/scaffold_messenger_service.dart';
import '../../utils/uuid.dart';
import '../auth/auth.dart';
import 'chat_room_state.dart';

const _messageLimit = 10;
const _scrollValueThreshold = 0.8;

class ChatRoomController extends StateNotifier<ChatRoomState> {
  ChatRoomController(this._ref, this._chatRoomId) : super(const ChatRoomState());

  final AutoDisposeStateNotifierProviderRef<ChatRoomController, ChatRoomState> _ref;
  final String _chatRoomId;
  late StreamSubscription<List<Message>> _newMessagesSubscription;
  late TextEditingController textEditingController;
  late ScrollController scrollController;

  @override
  void dispose() {
    Future<void>(() async {
      super.dispose();
      await _newMessagesSubscription.cancel();
      textEditingController.dispose();
      scrollController.dispose();
    });
  }

  /// 初期化処理。
  /// コンストラクタメソッドと一緒にコールする。
  Future<void> initialize() async {
    _initializeScrollController();
    _initializeNewMessagesSubscription();
    await Future.wait<void>([
      _initializeTextEditingController(),
      loadMore(),
      Future<void>.delayed(const Duration(milliseconds: 500)),
    ]);
    state = state.copyWith(loading: false);
  }

  /// 読み取り開始時刻以降のメッセージを購読して
  /// 画面に表示する messages に反映させるリスナーを初期化する。
  void _initializeNewMessagesSubscription() {
    _newMessagesSubscription = _ref
        .read(chatRepositoryProvider)
        .subscribeMessages(
          chatRoomId: _chatRoomId,
          queryBuilder: (q) => q
              .orderBy('createdAt', descending: true)
              .where('createdAt', isGreaterThanOrEqualTo: DateTime.now()),
        )
        .listen((messages) async {
      state = state.copyWith(newMessages: messages);
      _updateMessages();
    });
  }

  /// TextEditingController を初期化してリスナーを設定する
  Future<void> _initializeTextEditingController() async {
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      final text = textEditingController.text;
      state = state.copyWith(isValid: text.isNotEmpty);
    });
  }

  /// ListView の ScrollController を初期化して、
  /// 過去のメッセージを遡って取得するための Listener を設定する。
  void _initializeScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      final scrollValue = scrollController.offset / scrollController.position.maxScrollExtent;
      if (scrollValue > _scrollValueThreshold) {
        await loadMore();
      }
    });
  }

  /// 無限スクロールのクエリ
  Query<Message> get _query {
    var query = messagesRef(chatRoomId: _chatRoomId).orderBy('createdAt', descending: true);
    final qds = state.lastReadQueryDocumentSnapshot;
    if (qds != null) {
      query = query.startAfterDocument(qds);
    }
    return query.limit(_messageLimit);
  }

  /// 表示するメッセージを更新する
  void _updateMessages() {
    state = state.copyWith(messages: [...state.newMessages, ...state.pastMessages]);
  }

  /// メッセージを送信する
  Future<void> send() async {
    if (state.sending) {
      return;
    }
    final userId = _ref.read(userIdProvider).value;
    if (userId == null) {
      _ref.read(scaffoldMessengerServiceProvider).showSnackBar('メッセージの送信にはログインが必要です。');
      return;
    }
    state = state.copyWith(sending: true);
    final text = textEditingController.value.text;
    if (text.isEmpty) {
      _ref.read(scaffoldMessengerServiceProvider).showSnackBar('内容を入力してください。');
      return;
    }
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
    } on FirebaseException catch (e) {
      _ref.read(scaffoldMessengerServiceProvider).showSnackBarByFirebaseException(e);
    } finally {
      state = state.copyWith(sending: false);
      textEditingController.clear();
      await scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    }
  }

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
    final qs = await _query.limit(_messageLimit).get();
    final messages = qs.docs.map((qds) => qds.data()).toList();
    state = state.copyWith(pastMessages: [...state.pastMessages, ...messages]);
    _updateMessages();
    state = state.copyWith(
      fetching: false,
      lastReadQueryDocumentSnapshot: qs.docs.isNotEmpty ? qs.docs.last : null,
      hasMore: qs.docs.length >= _messageLimit,
    );
  }
}

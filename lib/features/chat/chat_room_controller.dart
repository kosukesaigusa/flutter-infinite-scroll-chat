import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore/message.dart';
import '../../repositories/chat.dart';
import '../../utils/exceptions/base.dart';
import '../../utils/scaffold_messenger_service.dart';
import 'chat.dart';

/// 無限スクロールで取得するメッセージ件数の limit 値。
const _limit = 10;

/// 画面の何割をスクロールした時点で次の _limit 件のメッセージを取得するか。
const _scrollValueThreshold = 0.8;

final chatRoomControllerProvider =
    Provider.autoDispose.family<ChatRoomController, String>(ChatRoomController.new);

/// チャットルームページでの各種操作を行うコントローラ。
class ChatRoomController {
  ChatRoomController(
    this._ref,
    this._chatRoomId,
  ) : _chat = _ref.read(chatProvider(_chatRoomId).notifier) {
    _initialize();
    _ref.onDispose(() async {
      await _newMessagesSubscription.cancel();
      textEditingController.dispose();
      scrollController.dispose();
    });
  }

  final AutoDisposeProviderRef<ChatRoomController> _ref;
  final String _chatRoomId;
  final Chat _chat;
  late StreamSubscription<List<Message>> _newMessagesSubscription;
  late TextEditingController textEditingController;
  late ScrollController scrollController;

  /// 初期化処理。
  /// コンストラクタメソッドと一緒にコールする。
  Future<void> _initialize() async {
    _initializeScrollController();
    _initializeNewMessagesSubscription();
    await _initializeTextEditingController();
  }

  /// 読み取り開始時刻以降のメッセージを購読して
  /// 画面に表示する messages に反映させるリスナーを初期化する。
  void _initializeNewMessagesSubscription() {
    _newMessagesSubscription = _ref
        .read(chatRepository)
        .subscribeMessages(
          chatRoomId: _chatRoomId,
          queryBuilder: (q) => q
              .orderBy('createdAt', descending: true)
              .where('createdAt', isGreaterThanOrEqualTo: DateTime.now()),
        )
        .listen((newMessages) async {
      _chat
        ..updateNewMessages(newMessages)
        ..updateMessages();
    });
  }

  /// TextEditingController を初期化してリスナーを設定する。
  Future<void> _initializeTextEditingController() async {
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      _chat.updateIsValid(isValid: textEditingController.value.text.isNotEmpty);
    });
  }

  /// ListView の ScrollController を初期化して、
  /// 過去のメッセージを遡って取得するための Listener を設定する。
  void _initializeScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      final scrollValue = scrollController.offset / scrollController.position.maxScrollExtent;
      if (scrollValue > _scrollValueThreshold) {
        await _chat.loadMore(limit: _limit);
      }
    });
  }

  /// メッセージを送信する。
  Future<void> send() async {
    final text = textEditingController.value.text;
    if (text.isEmpty) {
      _ref.read(scaffoldMessengerServiceProvider).showSnackBar('内容を入力してください。');
      return;
    }
    try {
      await _chat.sendMessage(text: text);
    } on AppException catch (e) {
      _ref.read(scaffoldMessengerServiceProvider).showSnackBarByException(e);
    } on FirebaseException catch (e) {
      _ref.read(scaffoldMessengerServiceProvider).showSnackBarByFirebaseException(e);
    } finally {
      textEditingController.clear();
      await scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    }
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore/message.dart';
import '../../utils/exceptions/base.dart';
import '../../utils/scaffold_messenger_service.dart';
import 'chat.dart';

final chatControllerProvider = Provider.autoDispose.family<ChatController, String>(
  (ref, chatRoomId) => ChatController(ref, ref.read(chatProvider(chatRoomId).notifier)),
);

/// チャット画面での各種操作を行うコントローラ。
class ChatController {
  ChatController(this._ref, this._chat) {
    _initialize();
    _ref.onDispose(() async {
      await _newMessagesSubscription.cancel();
      textEditingController.dispose();
      scrollController.dispose();
    });
  }

  final AutoDisposeProviderRef<ChatController> _ref;

  /// チャットモデルのインスタンス。
  final Chat _chat;

  /// 新着メッセージのサブスクリプション。
  late final StreamSubscription<List<Message>> _newMessagesSubscription;

  /// メッセージ入力部分のコントローラ。
  late final TextEditingController textEditingController;

  /// メッセージを表示する ListView のコントローラ。
  late final ScrollController scrollController;

  /// 画面の何割をスクロールした時点で次の _limit 件のメッセージを取得するか。
  static const _scrollValueThreshold = 0.8;

  /// 初期化処理。コンストラクタメソッド内でコールする。
  void _initialize() {
    _initializeTextEditingController();
    _initializeScrollController();
    _initializeNewMessagesSubscription();
  }

  /// TextEditingController を初期化してリスナーを設定する。
  void _initializeTextEditingController() {
    textEditingController = TextEditingController()
      ..addListener(() {
        _chat.updateIsValid(isValid: textEditingController.value.text.isNotEmpty);
      });
  }

  /// ListView の ScrollController を初期化して、
  /// 過去のメッセージを遡って取得するための Listener を設定する。
  void _initializeScrollController() {
    scrollController = ScrollController()
      ..addListener(() async {
        final scrollValue = scrollController.offset / scrollController.position.maxScrollExtent;
        if (scrollValue > _scrollValueThreshold) {
          await _chat.loadMore();
        }
      });
  }

  /// 読み取り開始時刻以降のメッセージを購読して
  /// 画面に表示する messages に反映させるリスナーを初期化する。
  void _initializeNewMessagesSubscription() {
    _newMessagesSubscription = _chat.newMessagesSubscription;
  }

  /// メッセージを送信する。
  Future<void> send() async {
    final text = textEditingController.value.text;
    try {
      await _chat.sendMessage(text: text);
      textEditingController.clear();
      await scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    } on AppException catch (e) {
      _ref.read(scaffoldMessengerServiceProvider).showSnackBarByException(e);
    } on FirebaseException catch (e) {
      _ref.read(scaffoldMessengerServiceProvider).showSnackBarByFirebaseException(e);
    }
  }
}

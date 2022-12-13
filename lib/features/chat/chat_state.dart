import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../firestore/message.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    /// チャットページに入ったときの初回ローディング中かどうか。
    @Default(true) bool loading,

    /// メッセージを送信中かどうか。
    @Default(false) bool sending,

    /// メッセージの内容のバリデーションに成功しているかどうか。
    @Default(false) bool isValid,

    /// 取得したメッセージ全体。
    @Default(<Message>[]) List<Message> messages,

    /// 取得した新着メッセージ。
    @Default(<Message>[]) List<Message> newMessages,

    /// 遡って取得した過去のメッセージ。
    @Default(<Message>[]) List<Message> pastMessages,

    /// 無限スクロールで遡って過去のメッセージを取得中かどうか。
    @Default(false) bool fetching,

    /// 無限スクロールで遡る際にまだ取得するメッセージが残っているかどうか。
    @Default(true) bool hasMore,

    /// 無限スクロールで遡って取得した最後のドキュメントのクエリスナップショット。
    QueryDocumentSnapshot<Message>? lastReadQueryDocumentSnapshot,
  }) = _ChatRoomState;
}

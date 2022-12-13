// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChatState {
  /// チャットページに入ったときの初回ローディング中かどうか。
  bool get loading => throw _privateConstructorUsedError;

  /// メッセージを送信中かどうか。
  bool get sending => throw _privateConstructorUsedError;

  /// メッセージの内容のバリデーションに成功しているかどうか。
  bool get isValid => throw _privateConstructorUsedError;

  /// 取得したメッセージ全体。
  List<Message> get messages => throw _privateConstructorUsedError;

  /// 取得した新着メッセージ。
  List<Message> get newMessages => throw _privateConstructorUsedError;

  /// 遡って取得した過去のメッセージ。
  List<Message> get pastMessages => throw _privateConstructorUsedError;

  /// 無限スクロールで遡って過去のメッセージを取得中かどうか。
  bool get fetching => throw _privateConstructorUsedError;

  /// 無限スクロールで遡る際にまだ取得するメッセージが残っているかどうか。
  bool get hasMore => throw _privateConstructorUsedError;

  /// 無限スクロールで遡って取得した最後のドキュメントのクエリスナップショット。
  QueryDocumentSnapshot<Message>? get lastReadQueryDocumentSnapshot =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatStateCopyWith<ChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatStateCopyWith<$Res> {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) then) =
      _$ChatStateCopyWithImpl<$Res, ChatState>;
  @useResult
  $Res call(
      {bool loading,
      bool sending,
      bool isValid,
      List<Message> messages,
      List<Message> newMessages,
      List<Message> pastMessages,
      bool fetching,
      bool hasMore,
      QueryDocumentSnapshot<Message>? lastReadQueryDocumentSnapshot});
}

/// @nodoc
class _$ChatStateCopyWithImpl<$Res, $Val extends ChatState>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? sending = null,
    Object? isValid = null,
    Object? messages = null,
    Object? newMessages = null,
    Object? pastMessages = null,
    Object? fetching = null,
    Object? hasMore = null,
    Object? lastReadQueryDocumentSnapshot = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      sending: null == sending
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      newMessages: null == newMessages
          ? _value.newMessages
          : newMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      pastMessages: null == pastMessages
          ? _value.pastMessages
          : pastMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      fetching: null == fetching
          ? _value.fetching
          : fetching // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      lastReadQueryDocumentSnapshot: freezed == lastReadQueryDocumentSnapshot
          ? _value.lastReadQueryDocumentSnapshot
          : lastReadQueryDocumentSnapshot // ignore: cast_nullable_to_non_nullable
              as QueryDocumentSnapshot<Message>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatRoomStateCopyWith<$Res>
    implements $ChatStateCopyWith<$Res> {
  factory _$$_ChatRoomStateCopyWith(
          _$_ChatRoomState value, $Res Function(_$_ChatRoomState) then) =
      __$$_ChatRoomStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool sending,
      bool isValid,
      List<Message> messages,
      List<Message> newMessages,
      List<Message> pastMessages,
      bool fetching,
      bool hasMore,
      QueryDocumentSnapshot<Message>? lastReadQueryDocumentSnapshot});
}

/// @nodoc
class __$$_ChatRoomStateCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$_ChatRoomState>
    implements _$$_ChatRoomStateCopyWith<$Res> {
  __$$_ChatRoomStateCopyWithImpl(
      _$_ChatRoomState _value, $Res Function(_$_ChatRoomState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? sending = null,
    Object? isValid = null,
    Object? messages = null,
    Object? newMessages = null,
    Object? pastMessages = null,
    Object? fetching = null,
    Object? hasMore = null,
    Object? lastReadQueryDocumentSnapshot = freezed,
  }) {
    return _then(_$_ChatRoomState(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      sending: null == sending
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      newMessages: null == newMessages
          ? _value._newMessages
          : newMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      pastMessages: null == pastMessages
          ? _value._pastMessages
          : pastMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      fetching: null == fetching
          ? _value.fetching
          : fetching // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      lastReadQueryDocumentSnapshot: freezed == lastReadQueryDocumentSnapshot
          ? _value.lastReadQueryDocumentSnapshot
          : lastReadQueryDocumentSnapshot // ignore: cast_nullable_to_non_nullable
              as QueryDocumentSnapshot<Message>?,
    ));
  }
}

/// @nodoc

class _$_ChatRoomState implements _ChatRoomState {
  const _$_ChatRoomState(
      {this.loading = true,
      this.sending = false,
      this.isValid = false,
      final List<Message> messages = const <Message>[],
      final List<Message> newMessages = const <Message>[],
      final List<Message> pastMessages = const <Message>[],
      this.fetching = false,
      this.hasMore = true,
      this.lastReadQueryDocumentSnapshot})
      : _messages = messages,
        _newMessages = newMessages,
        _pastMessages = pastMessages;

  /// チャットページに入ったときの初回ローディング中かどうか。
  @override
  @JsonKey()
  final bool loading;

  /// メッセージを送信中かどうか。
  @override
  @JsonKey()
  final bool sending;

  /// メッセージの内容のバリデーションに成功しているかどうか。
  @override
  @JsonKey()
  final bool isValid;

  /// 取得したメッセージ全体。
  final List<Message> _messages;

  /// 取得したメッセージ全体。
  @override
  @JsonKey()
  List<Message> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  /// 取得した新着メッセージ。
  final List<Message> _newMessages;

  /// 取得した新着メッセージ。
  @override
  @JsonKey()
  List<Message> get newMessages {
    if (_newMessages is EqualUnmodifiableListView) return _newMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newMessages);
  }

  /// 遡って取得した過去のメッセージ。
  final List<Message> _pastMessages;

  /// 遡って取得した過去のメッセージ。
  @override
  @JsonKey()
  List<Message> get pastMessages {
    if (_pastMessages is EqualUnmodifiableListView) return _pastMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pastMessages);
  }

  /// 無限スクロールで遡って過去のメッセージを取得中かどうか。
  @override
  @JsonKey()
  final bool fetching;

  /// 無限スクロールで遡る際にまだ取得するメッセージが残っているかどうか。
  @override
  @JsonKey()
  final bool hasMore;

  /// 無限スクロールで遡って取得した最後のドキュメントのクエリスナップショット。
  @override
  final QueryDocumentSnapshot<Message>? lastReadQueryDocumentSnapshot;

  @override
  String toString() {
    return 'ChatState(loading: $loading, sending: $sending, isValid: $isValid, messages: $messages, newMessages: $newMessages, pastMessages: $pastMessages, fetching: $fetching, hasMore: $hasMore, lastReadQueryDocumentSnapshot: $lastReadQueryDocumentSnapshot)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatRoomState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.sending, sending) || other.sending == sending) &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            const DeepCollectionEquality()
                .equals(other._newMessages, _newMessages) &&
            const DeepCollectionEquality()
                .equals(other._pastMessages, _pastMessages) &&
            (identical(other.fetching, fetching) ||
                other.fetching == fetching) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.lastReadQueryDocumentSnapshot,
                    lastReadQueryDocumentSnapshot) ||
                other.lastReadQueryDocumentSnapshot ==
                    lastReadQueryDocumentSnapshot));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      sending,
      isValid,
      const DeepCollectionEquality().hash(_messages),
      const DeepCollectionEquality().hash(_newMessages),
      const DeepCollectionEquality().hash(_pastMessages),
      fetching,
      hasMore,
      lastReadQueryDocumentSnapshot);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatRoomStateCopyWith<_$_ChatRoomState> get copyWith =>
      __$$_ChatRoomStateCopyWithImpl<_$_ChatRoomState>(this, _$identity);
}

abstract class _ChatRoomState implements ChatState {
  const factory _ChatRoomState(
      {final bool loading,
      final bool sending,
      final bool isValid,
      final List<Message> messages,
      final List<Message> newMessages,
      final List<Message> pastMessages,
      final bool fetching,
      final bool hasMore,
      final QueryDocumentSnapshot<Message>?
          lastReadQueryDocumentSnapshot}) = _$_ChatRoomState;

  @override

  /// チャットページに入ったときの初回ローディング中かどうか。
  bool get loading;
  @override

  /// メッセージを送信中かどうか。
  bool get sending;
  @override

  /// メッセージの内容のバリデーションに成功しているかどうか。
  bool get isValid;
  @override

  /// 取得したメッセージ全体。
  List<Message> get messages;
  @override

  /// 取得した新着メッセージ。
  List<Message> get newMessages;
  @override

  /// 遡って取得した過去のメッセージ。
  List<Message> get pastMessages;
  @override

  /// 無限スクロールで遡って過去のメッセージを取得中かどうか。
  bool get fetching;
  @override

  /// 無限スクロールで遡る際にまだ取得するメッセージが残っているかどうか。
  bool get hasMore;
  @override

  /// 無限スクロールで遡って取得した最後のドキュメントのクエリスナップショット。
  QueryDocumentSnapshot<Message>? get lastReadQueryDocumentSnapshot;
  @override
  @JsonKey(ignore: true)
  _$$_ChatRoomStateCopyWith<_$_ChatRoomState> get copyWith =>
      throw _privateConstructorUsedError;
}

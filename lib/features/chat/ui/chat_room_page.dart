import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../firestore/message.dart';
import '../../../utils/exceptions/base.dart';
import '../../../utils/extensions/build_context.dart';
import '../../../utils/extensions/date_time.dart';
import '../../../utils/extensions/int.dart';
import '../../app_user/app_user.dart';
import '../../auth/auth.dart';
import '../../routing/app_router_state.dart';
import '../chat.dart';
import '../chat_room_controller.dart';

/// 複数箇所で指定している水平方向の Padding。
const double _horizontalPadding = 8;

/// メッセージ送信者のアイコンサイズ。
const double _senderIconSize = 24;

/// 複数箇所で指定している背景等のグレー色。
const _backgroundGrey = Color(0xfff1eef1);

///
final _chatRoomIdProvider = Provider.autoDispose<String>(
  (ref) {
    final state = ref.watch(appRouterStateProvider);
    final chatRoomId = state.params['chatRoomId'];
    if (chatRoomId == null) {
      throw const AppException(message: 'チャットルームが見つかりませんでした。');
    }
    return chatRoomId;
  },
  dependencies: [
    extractExtraData,
    appRouterStateProvider,
  ],
);

/// チャットルームページ。
class ChatRoomPage extends HookConsumerWidget {
  const ChatRoomPage({super.key});

  static const path = '/chatRoom/:chatRoomId';
  static const name = 'ChatRoomPage';
  static String location({required String chatRoomId}) => '/chatRoom/$chatRoomId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomId = ref.watch(_chatRoomIdProvider);
    final controller = ref.watch(chatRoomControllerProvider(chatRoomId));
    final messages = ref.watch(chatProvider(chatRoomId).select((s) => s.messages));
    final loading = ref.watch(chatProvider(chatRoomId).select((s) => s.loading));
    final userId = ref.watch(userIdAsyncValueProvider).value;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          loading
              ? const Center(
                  child: FaIcon(
                    FontAwesomeIcons.solidComment,
                    size: 72,
                    color: Colors.black12,
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListView.builder(
                          controller: controller.scrollController,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return _MessageItem(
                              chatRoomId: chatRoomId,
                              message: message,
                              showDate: _showDate(
                                itemCount: messages.length,
                                index: index,
                                messages: messages,
                              ),
                              isMyMessage: message.senderId == userId,
                            );
                          },
                          itemCount: messages.length,
                          reverse: true,
                        ),
                      ),
                    ),
                    _RoomMessageInput(chatRoomId),
                    const Gap(24),
                  ],
                ),
          const Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: _DebugIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  /// 日付を表示するかどうか
  bool _showDate({
    required int itemCount,
    required int index,
    required List<Message> messages,
  }) {
    if (itemCount == 1) {
      return true;
    }
    if (index == itemCount - 1) {
      return true;
    }
    final lastCreatedAt = messages[index].createdAt.dateTime;
    final previouslyCreatedAt = messages[index + 1].createdAt.dateTime;
    if (lastCreatedAt == null || previouslyCreatedAt == null) {
      return false;
    }
    if (sameDay(lastCreatedAt, previouslyCreatedAt)) {
      return false;
    }
    return true;
  }
}

class _DebugIndicator extends HookConsumerWidget {
  const _DebugIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomId = ref.watch(_chatRoomIdProvider);
    final messages = ref.watch(chatProvider(chatRoomId).select((s) => s.messages));
    final state = ref.watch(chatProvider(chatRoomId));
    final lastReadDocumentId = state.lastReadQueryDocumentSnapshot?.id;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('デバッグウィンドウ', style: context.titleSmall!.copyWith(color: Colors.white)),
          const Gap(4),
          Text(
            '取得したメッセージ：${messages.length.withComma} 件',
            style: context.bodySmall!.copyWith(color: Colors.white),
          ),
          Text(
            '取得中？：${state.fetching}',
            style: context.bodySmall!.copyWith(color: Colors.white),
          ),
          Text(
            'まだ取得できる？：${state.hasMore}',
            style: context.bodySmall!.copyWith(color: Colors.white),
          ),
          if (lastReadDocumentId != null)
            Text(
              '最後に取得したドキュメント ID：$lastReadDocumentId',
              style: context.bodySmall!.copyWith(color: Colors.white),
            ),
          const Gap(8),
        ],
      ),
    );
  }
}

/// メッセージ、日付、相手のアイコン、送信日時のウィジェット
class _MessageItem extends HookConsumerWidget {
  const _MessageItem({
    required this.chatRoomId,
    required this.message,
    required this.showDate,
    required this.isMyMessage,
  });

  final String chatRoomId;
  final Message message;
  final bool showDate;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showDate && message.createdAt.dateTime != null)
          _DateOnChatRoom(message.createdAt.dateTime!),
        Row(
          mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMyMessage) ...[
              const FaIcon(FontAwesomeIcons.user, size: _senderIconSize),
              const Gap(8),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMyMessage) ...[
                  _SenderName(message.senderId),
                  const Gap(8),
                ],
                _MessageContentWidget(message: message, isMyMessage: isMyMessage),
              ],
            ),
          ],
        ),
        _MessageAdditionalInfo(
          message: message,
          chatRoomId: chatRoomId,
          isMyMessage: isMyMessage,
        ),
      ],
    );
  }
}

/// チャットメッセージの日付
class _DateOnChatRoom extends StatelessWidget {
  const _DateOnChatRoom(this.dateTime);

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: _backgroundGrey,
          ),
          child: Text(
            toIsoStringDateWithWeekDay(dateTime),
            style: context.bodySmall,
          ),
        ),
      ),
    );
  }
}

/// メッセージの送り主（相手）の名前を表示するウィジェット。
class _SenderName extends HookConsumerWidget {
  const _SenderName(this.senderId);

  final String senderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(appUserProvider(senderId)).when(
          data: (appUser) => appUser == null ? const SizedBox() : Text(appUser.name),
          error: (error, stackTrace) => const SizedBox(),
          loading: () => const SizedBox(),
        );
  }
}

/// メッセージの本文を表示するウィジェット。
class _MessageContentWidget extends HookConsumerWidget {
  const _MessageContentWidget({
    required this.message,
    required this.isMyMessage,
  });

  final Message message;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: BoxConstraints(
        maxWidth:
            (MediaQuery.of(context).size.width - _senderIconSize - _horizontalPadding * 3) * 0.9,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
          bottomLeft: Radius.circular(isMyMessage ? 8 : 0),
          bottomRight: Radius.circular(isMyMessage ? 0 : 8),
        ),
        color: isMyMessage ? context.theme.primaryColor : _backgroundGrey,
      ),
      child: Text(
        message.content,
        style: isMyMessage ? context.bodySmall!.copyWith(color: Colors.white) : context.bodySmall,
      ),
    );
  }
}

/// 送信日時と未既読などを表示するウィジェット。
class _MessageAdditionalInfo extends HookConsumerWidget {
  const _MessageAdditionalInfo({
    required this.message,
    required this.chatRoomId,
    required this.isMyMessage,
  });

  final Message message;
  final String chatRoomId;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        left: isMyMessage ? 0 : _senderIconSize + _horizontalPadding,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            to24HourNotationString(message.createdAt.dateTime),
            style: context.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// ルームページのメッセージ入力欄のウィジェット
class _RoomMessageInput extends HookConsumerWidget {
  const _RoomMessageInput(this.chatRoomId);

  final String chatRoomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: _backgroundGrey,
            ),
            child: TextField(
              controller: ref.watch(chatRoomControllerProvider(chatRoomId)).textEditingController,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: 16,
                  right: 36,
                  top: 8,
                  bottom: 8,
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'メッセージを入力',
                hintStyle: context.bodySmall,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (!ref.read(chatProvider(chatRoomId)).isValid) {
              return;
            }
            await ref.read(chatRoomControllerProvider(chatRoomId)).send();
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ref.watch(chatProvider(chatRoomId)).isValid
                  ? context.theme.primaryColor
                  : context.theme.disabledColor,
            ),
            child: const Icon(Icons.send, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

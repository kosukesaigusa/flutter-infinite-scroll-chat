import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../firestore_models/message.dart';
import '../../../utils/exceptions/base.dart';
import '../../../utils/extensions/build_context.dart';
import '../../../utils/extensions/date_time.dart';
import '../../../utils/widgets/image.dart';
import '../../app_user/app_user.dart';
import '../../auth/auth.dart';
import '../../routing/app_router_state.dart';
import '../chat.dart';

const double _horizontalPadding = 8;
const double _partnerImageSize = 36;
const _messageBackgroundColor = Color(0xfff1eef1);

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
    extractExtraDataProvider,
    appRouterStateProvider,
  ],
);

/// チャットルームページ
class ChatRoomPage extends StatefulHookConsumerWidget {
  const ChatRoomPage({super.key});

  static const path = '/chatRoom/:chatRoomId';
  static const name = 'ChatRoomPage';
  static String location({required String chatRoomId}) => '/chatRoom/$chatRoomId';

  @override
  ConsumerState<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends ConsumerState<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    final chatRoomId = ref.watch(_chatRoomIdProvider);
    final messages = ref.watch(
      chatRoomControllerProvider(chatRoomId).select((s) => s.messages),
    );
    final userId = ref.watch(userIdProvider).value;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(chatRoomControllerProvider(chatRoomId)).loading
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
                      controller: ref
                          .watch(
                            chatRoomControllerProvider(chatRoomId).notifier,
                          )
                          .scrollController,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _MessageItemWidget(
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
                _RoomMessageInputWidget(chatRoomId),
                const Gap(24),
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

/// メッセージ、日付、相手のアイコン、送信日時のウィジェット
class _MessageItemWidget extends HookConsumerWidget {
  const _MessageItemWidget({
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
          _DateOnChatRoomWidget(message.createdAt.dateTime!),
        Row(
          mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMyMessage) ...[
              _SenderImageWidget(message.senderId),
              const Gap(8),
            ],
            _MessageContentWidget(message: message, isMyMessage: isMyMessage),
          ],
        ),
        _MessageAdditionalInfoWidget(
          message: message,
          chatRoomId: chatRoomId,
          isMyMessage: isMyMessage,
        ),
      ],
    );
  }
}

/// チャットメッセージの日付
class _DateOnChatRoomWidget extends StatelessWidget {
  const _DateOnChatRoomWidget(this.dateTime);

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
            color: _messageBackgroundColor,
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

/// ルームページのメッセージ入力欄のウィジェット
class _RoomMessageInputWidget extends HookConsumerWidget {
  const _RoomMessageInputWidget(this.chatRoomId);

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
              color: _messageBackgroundColor,
            ),
            child: TextField(
              controller:
                  ref.watch(chatRoomControllerProvider(chatRoomId).notifier).textEditingController,
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
            if (!ref.read(chatRoomControllerProvider(chatRoomId)).isValid) {
              return;
            }
            await ref.read(chatRoomControllerProvider(chatRoomId).notifier).send();
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ref.watch(chatRoomControllerProvider(chatRoomId)).isValid
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

/// メッセージの送り主（相手）の画像を表示するウィジェット。
class _SenderImageWidget extends HookConsumerWidget {
  const _SenderImageWidget(this.senderId);

  final String senderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(appUserProvider(senderId)).when(
          data: (appUser) => CircleImageWidget(diameter: 36, imageURL: appUser?.imageUrl),
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
            (MediaQuery.of(context).size.width - _partnerImageSize - _horizontalPadding * 3) * 0.9,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
          bottomLeft: Radius.circular(isMyMessage ? 8 : 0),
          bottomRight: Radius.circular(isMyMessage ? 0 : 8),
        ),
        color: isMyMessage ? context.theme.primaryColor : _messageBackgroundColor,
      ),
      child: Text(
        message.content,
        style: isMyMessage ? context.bodySmall!.copyWith(color: Colors.white) : context.bodySmall,
      ),
    );
  }
}

/// 送信日時と未既読などを表示するウィジェット。
class _MessageAdditionalInfoWidget extends HookConsumerWidget {
  const _MessageAdditionalInfoWidget({
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
        left: isMyMessage ? 0 : _partnerImageSize + _horizontalPadding,
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

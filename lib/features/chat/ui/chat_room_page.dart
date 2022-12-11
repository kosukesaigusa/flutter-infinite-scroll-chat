import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/exceptions/base.dart';
import '../../routing/app_router_state.dart';

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

const double _horizontalPadding = 8;
const double _partnerImageSize = 36;

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
    return Scaffold(
      appBar: AppBar(title: Text(chatRoomId)),
      body: const SizedBox(),
    );
    // final messages = ref.watch(
    //   roomPageStateNotifierProvider(chatRoomId).select((s) => s.messages),
    // );
    // final userId = ref.watch(userIdProvider).value;
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: ref.watch(roomPageStateNotifierProvider(chatRoomId)).loading
    //       ? const Center(
    //           child: FaIcon(
    //             FontAwesomeIcons.solidComment,
    //             size: 72,
    //             color: Colors.black12,
    //           ),
    //         )
    //       : Column(
    //           children: [
    //             Expanded(
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 8),
    //                 child: ListView.builder(
    //                   controller: ref
    //                       .watch(
    //                         roomPageStateNotifierProvider(chatRoomId).notifier,
    //                       )
    //                       .scrollController,
    //                   itemBuilder: (context, index) {
    //                     final message = messages[index];
    //                     return MessageItemWidget(
    //                       chatRoomId: chatRoomId,
    //                       message: message,
    //                       showDate: _showDate(
    //                         itemCount: messages.length,
    //                         index: index,
    //                         messages: messages,
    //                       ),
    //                       isMyMessage: message.senderId == userId,
    //                     );
    //                   },
    //                   itemCount: messages.length,
    //                   reverse: true,
    //                 ),
    //               ),
    //             ),
    //             RoomMessageInputWidget(chatRoomId: chatRoomId),
    //             if (!KeyboardVisibilityProvider.isKeyboardVisible(context)) const Gap(32),
    //           ],
    //         ),
    // );
  }
}

// /// メッセージ、日付、相手のアイコン、送信日時のウィジェット
// class MessageItemWidget extends HookConsumerWidget {
//   const MessageItemWidget({
//     super.key,
//     required this.chatRoomId,
//     required this.message,
//     required this.showDate,
//     required this.isMyMessage,
//   });

//   final String chatRoomId;
//   final Message message;
//   final bool showDate;
//   final bool isMyMessage;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Column(
//       crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         if (showDate) DateOnChatRoomWidget(dateTime: message.createdAt.dateTime),
//         Row(
//           mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (!isMyMessage) ...[
//               SenderImageWidget(senderId: message.senderId),
//               const Gap(8),
//             ],
//             MessageContentWidget(message: message, isMyMessage: isMyMessage),
//           ],
//         ),
//         MessageAdditionalInfoWidget(
//           message: message,
//           chatRoomId: chatRoomId,
//           isMyMessage: isMyMessage,
//         ),
//       ],
//     );
//   }
// }

// /// チャットメッセージの日付
// class DateOnChatRoomWidget extends StatelessWidget {
//   const DateOnChatRoomWidget({
//     super.key,
//     this.dateTime,
//   });

//   final DateTime? dateTime;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 24),
//       child: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(8)),
//             color: messageBackgroundColor,
//           ),
//           child: Text(
//             toIsoStringDateWithWeekDay(dateTime),
//             style: context.bodySmall,
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// ルームページのメッセージ入力欄のウィジェット
// class RoomMessageInputWidget extends HookConsumerWidget {
//   const RoomMessageInputWidget({
//     super.key,
//     required this.chatRoomId,
//   });

//   final String chatRoomId;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.all(8),
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(16)),
//               color: messageBackgroundColor,
//             ),
//             child: TextField(
//               controller: ref
//                   .watch(roomPageStateNotifierProvider(chatRoomId).notifier)
//                   .textEditingController,
//               minLines: 1,
//               maxLines: 5,
//               decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.only(
//                   left: 16,
//                   right: 36,
//                   top: 8,
//                   bottom: 8,
//                 ),
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 hintText: 'メッセージを入力',
//                 hintStyle: context.bodySmall,
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () async {
//             if (!ref.read(roomPageStateNotifierProvider(chatRoomId)).isValid) {
//               return;
//             }
//             await ref.read(roomPageStateNotifierProvider(chatRoomId).notifier).send();
//           },
//           child: Container(
//             margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: ref.watch(roomPageStateNotifierProvider(chatRoomId)).isValid
//                   ? context.theme.primaryColor
//                   : context.theme.disabledColor,
//             ),
//             child: const Icon(Icons.send, size: 20, color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// メッセージの送り主（相手）の画像を表示するウィジェット。
// class SenderImageWidget extends HookConsumerWidget {
//   const SenderImageWidget({
//     super.key,
//     required this.senderId,
//   });

//   final String senderId;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ref.watch(appUserStreamProvider(senderId)).when(
//           data: (appUser) => CircleImageWidget(diameter: 36, imageURL: appUser?.imageUrl),
//           error: (error, stackTrace) => const SizedBox(),
//           loading: () => const SizedBox(),
//         );
//   }
// }

// /// メッセージの本文を表示するウィジェット。
// class MessageContentWidget extends HookConsumerWidget {
//   const MessageContentWidget({
//     super.key,
//     required this.message,
//     required this.isMyMessage,
//   });

//   final Message message;
//   final bool isMyMessage;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       constraints: BoxConstraints(
//         maxWidth:
//             (MediaQuery.of(context).size.width - partnerImageSize - horizontalPadding * 3) * 0.9,
//       ),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: const Radius.circular(8),
//           topRight: const Radius.circular(8),
//           bottomLeft: Radius.circular(isMyMessage ? 8 : 0),
//           bottomRight: Radius.circular(isMyMessage ? 0 : 8),
//         ),
//         color: isMyMessage ? context.theme.primaryColor : messageBackgroundColor,
//       ),
//       child: Text(
//         message.content,
//         style: isMyMessage ? context.bodySmall!.copyWith(color: Colors.white) : context.bodySmall,
//       ),
//     );
//   }
// }

// /// 送信日時と未既読などを表示するウィジェット。
// class MessageAdditionalInfoWidget extends HookConsumerWidget {
//   const MessageAdditionalInfoWidget({
//     super.key,
//     required this.message,
//     required this.chatRoomId,
//     required this.isMyMessage,
//   });

//   final Message message;
//   final String chatRoomId;
//   final bool isMyMessage;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: EdgeInsets.only(
//         top: 4,
//         left: isMyMessage ? 0 : partnerImageSize + horizontalPadding,
//         bottom: 16,
//       ),
//       child: Column(
//         crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Text(
//             to24HourNotationString(message.createdAt.dateTime),
//             style: context.bodySmall,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_chat/features/chat/chat.dart';
import 'package:infinite_scroll_chat/firestore/chat_room.dart';
import 'package:infinite_scroll_chat/firestore/message.dart';
import 'package:infinite_scroll_chat/repositories/chat.dart';
import 'package:infinite_scroll_chat/utils/uuid.dart';
import 'package:tuple/tuple.dart';

import '../../mocks/firestore/refs.dart';
import '../../mocks/repositories/chat.dart';

void main() {
  group('チャット機能のテスト', () {
    group('chatRoomsProvider のテスト', () {
      test('正しく ChatRoom 一覧が取得できる。', () async {
        final container = ProviderContainer(
          overrides: [
            baseChatRepositoryProvider.overrideWith((_) => MockChatRepository()),
          ],
        );

        // ロード中である。
        expect(container.read(chatRoomsProvider), const AsyncValue<List<ChatRoom>>.loading());

        // ロードが終わるまで待つ。
        await container.read(chatRoomsProvider.future);

        // ロードが完了した後のデータが正しい。
        expect(container.read(chatRoomsProvider).value, [
          const ChatRoom(chatRoomId: 'chat-room-id-1'),
          const ChatRoom(chatRoomId: 'chat-room-id-2'),
          const ChatRoom(chatRoomId: 'chat-room-id-3'),
        ]);
      });
    });

    group('latestMessagesProvider のテスト', () {
      test('正しく最新のメッセージが取得できる。', () async {
        final container = ProviderContainer(
          overrides: [
            baseChatRepositoryProvider.overrideWith((_) => MockChatRepository()),
          ],
        );

        const chatRoomId = 'chat-room-id-1';
        const limit = 1;
        const tuple2 = Tuple2(chatRoomId, limit);

        // ロード中である。
        expect(container.read(latestMessageProvider(chatRoomId)), null);
        expect(
          container.read(latestMessagesProvider(tuple2)),
          const AsyncValue<List<Message>>.loading(),
        );

        // ロードが終わるまで待つ。
        await container.read(latestMessagesProvider(tuple2).future);

        // ロードが完了した後のデータが正しい。
        expect(container.read(latestMessagesProvider(tuple2)).value, [
          const Message(content: 'メッセージ 1'),
          const Message(content: 'メッセージ 2'),
        ]);
        expect(container.read(latestMessageProvider(chatRoomId))?.content, 'メッセージ 1');
      });
    });

    group('Chat クラスのテスト', () {
      const chatRoomId = 'chat-room-id-1';
      const messagesCount = 35;

      group('loadMore() メソッドのテスト', () {
        setUp(() async {
          final messages = List<Message>.generate(
            messagesCount,
            (index) => Message(messageId: uuid, content: 'メッセージ ${index + 1}'),
          );

          // メッセージデータを FakeFirebaseFirestore に作成する。
          for (final message in messages) {
            await mockMessageRef(chatRoomId: chatRoomId, messageId: message.messageId).set(message);
          }
        });

        test('4 回 loadMore() を繰り返すテスト。)', () async {
          final container = ProviderContainer(
            overrides: [
              baseChatRepositoryProvider.overrideWith((_) => MockChatRepository()),
            ],
          );

          final chat = container.read(chatProvider(chatRoomId).notifier);
          await chat.loadMore();

          expect(container.read(chatProvider(chatRoomId)).messages.length, 10);
          expect(container.read(chatProvider(chatRoomId)).newMessages.length, 0);
          expect(container.read(chatProvider(chatRoomId)).pastMessages.length, 10);
          expect(container.read(chatProvider(chatRoomId)).hasMore, true);

          await chat.loadMore();

          expect(container.read(chatProvider(chatRoomId)).messages.length, 20);
          expect(container.read(chatProvider(chatRoomId)).newMessages.length, 0);
          expect(container.read(chatProvider(chatRoomId)).pastMessages.length, 20);
          expect(container.read(chatProvider(chatRoomId)).hasMore, true);

          await chat.loadMore();

          expect(container.read(chatProvider(chatRoomId)).messages.length, 30);
          expect(container.read(chatProvider(chatRoomId)).newMessages.length, 0);
          expect(container.read(chatProvider(chatRoomId)).pastMessages.length, 30);
          expect(container.read(chatProvider(chatRoomId)).hasMore, true);

          await chat.loadMore();

          expect(container.read(chatProvider(chatRoomId)).messages.length, 35);
          expect(container.read(chatProvider(chatRoomId)).newMessages.length, 0);
          expect(container.read(chatProvider(chatRoomId)).pastMessages.length, 35);
          expect(container.read(chatProvider(chatRoomId)).hasMore, false);
        });
      });
    });
  });
}

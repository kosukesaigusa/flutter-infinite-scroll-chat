import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../chat/ui/chat_room_page.dart';
import '../chat/ui/chat_rooms_page.dart';
import 'app_route.dart';
import 'app_router_state.dart';

/// AppRoute インスタンスの一覧
/// 各ページのコンストラクタに引数を渡さない済むように、そのような場合は ProviderScope.override で
/// appRouterState の値をオーバーライドして、各画面を AppState をオーバーライドされた
/// Provider 経由で取得するようにする。
final appRoutes = <AppRoute>[
  AppRoute(
    path: ChatRoomsPage.path,
    name: ChatRoomsPage.name,
    builder: (context, state) => const ChatRoomsPage(key: ValueKey(ChatRoomsPage.name)),
  ),
  AppRoute(
    path: ChatRoomPage.path,
    name: ChatRoomPage.name,
    builder: (context, state) => ProviderScope(
      overrides: <Override>[appRouterState.overrideWithValue(state)],
      child: const ChatRoomPage(key: ValueKey(ChatRoomPage.name)),
    ),
  ),
];

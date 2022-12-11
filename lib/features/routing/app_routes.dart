import 'package:flutter/material.dart';

import '../chat/ui/chat_rooms_page.dart';
import 'app_route.dart';

/// AppRoute インスタンスの一覧
/// 各ページのコンストラクタに引数を渡さない済むように、そのような場合は ProviderScope.override で
/// appRouterStateProvider の値をオーバーライドして、各画面を AppState をオーバーライドされた
/// Provider 経由で取得するようにする。
final appRoutes = <AppRoute>[
  AppRoute(
    path: ChatRoomsPage.path,
    name: ChatRoomsPage.name,
    builder: (context, state) => const ChatRoomsPage(key: ValueKey(ChatRoomsPage.name)),
  ),
];

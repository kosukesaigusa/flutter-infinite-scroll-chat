import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/global_key.dart';
import '../../utils/loading.dart';
import '../../utils/widgets/not_found_page.dart';
import '../auth/auth.dart';
import 'app_router.dart';

/// ウィジェットツリーの上位にある Navigator を含むウィジェット。
class RootNavigator extends HookConsumerWidget {
  const RootNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider).value;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Navigator(
            key: ref.watch(globalKeyProvider),
            initialRoute: ref.watch(appRouterProvider).initialRoute,
            onGenerateRoute: ref.watch(appRouterProvider).onGenerateRoute,
            onUnknownRoute: (settings) {
              final route = MaterialPageRoute<void>(
                settings: settings,
                builder: (context) => const NotFoundPage(),
              );
              return route;
            },
          ),
          if (userId == null)
            const ColoredBox(
              color: Colors.black26,
              child: SizedBox.expand(),
            ),
          if (ref.watch(overlayLoadingProvider) || userId == null) const OverlayLoadingWidget(),
        ],
      ),
    );
  }
}

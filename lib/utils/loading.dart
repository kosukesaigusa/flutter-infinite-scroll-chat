import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// アプリ全体に半透明のローディング画面を重ねるかどうか。
final showOverlayLoading = StateProvider<bool>((_) => false);

/// プライマリカラーの SpinkitCircle を表示する
class PrimarySpinkitCircle extends StatelessWidget {
  const PrimarySpinkitCircle({
    super.key,
    this.size = 48,
  });

  final double size;
  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

/// 二度押しを防止したいときなどの重ねるローディングウィジェット。
class OverlayLoadingWidget extends StatelessWidget {
  const OverlayLoadingWidget({
    super.key,
    this.backgroundColor = Colors.black26,
    this.showLoadingWidget = true,
  });

  final Color backgroundColor;
  final bool showLoadingWidget;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: SizedBox.expand(
        child: showLoadingWidget ? const Center(child: PrimarySpinkitCircle()) : null,
      ),
    );
  }
}

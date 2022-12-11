import 'dart:math';

import 'package:flutter/material.dart';

import '../../../utils/extensions/build_context.dart';
import '../constants/number.dart';

/// AlertDialog.content に指定する
/// SizedBox で横幅を良い感じに調整したウィジェット。
class CommonAlertDialogContent extends StatelessWidget {
  const CommonAlertDialogContent({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: min(context.displaySize.width, alertDialogContentMinWidth),
      child: child,
    );
  }
}

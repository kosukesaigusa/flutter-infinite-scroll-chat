import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_models/app_user.dart';
import '../../repositories/app_user.dart';

/// 指定した userId の AppUser ドキュメントを購読する StreamProvider。
final appUserProvider = StreamProvider.autoDispose.family<AppUser?, String>((ref, userId) {
  return ref.read(appUserRepositoryProvider).subscribeAppUser(appUserId: userId);
});

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/logger.dart';
import '../features/app_user/app_user.dart';
import '../firestore_refs.dart';

final appUserRepositoryProvider = Provider.autoDispose((_) => AppUserRepository());

class AppUserRepository {
  /// 指定した AppUser を取得する。
  Future<AppUser?> fetchAppUser({
    required String appUserId,
  }) async {
    final ds = await appUserRef(appUserId: appUserId).get();
    if (!ds.exists) {
      logger.warning('Document not found: ${ds.reference.path}');
      return null;
    }
    return ds.data();
  }

  /// 指定した AppUser を購読する。
  Stream<AppUser?> subscribeAppUser({
    required String appUserId,
  }) {
    final docStream = appUserRef(appUserId: appUserId).snapshots();
    return docStream.map((ds) => ds.data());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_models/app_user.dart';
import '../firestore_refs.dart';

final appUserRepositoryProvider = Provider.autoDispose((_) => AppUserRepository());

class AppUserRepository {
  /// 指定した AppUser を購読する。
  Stream<AppUser?> subscribeAppUser({
    required String appUserId,
  }) {
    final docStream = appUserRef(appUserId: appUserId).snapshots();
    return docStream.map((ds) => ds.data());
  }

  /// 指定した userId のユーザーを `SetOptions(merge: true)` で作成する。
  Future<void> setAppUser({
    required String appUserId,
    String? fcmToken,
  }) async {
    await appUserRef(appUserId: appUserId).set(
      AppUser(
        appUserId: appUserId,
        name: 'AAA',
      ),
      SetOptions(merge: true),
    );
  }
}

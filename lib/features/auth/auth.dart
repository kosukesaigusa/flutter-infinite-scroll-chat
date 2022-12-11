import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/app_user.dart';
import '../../utils/exceptions/base.dart';
import '../../utils/logger.dart';

final _auth = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authUser = StreamProvider<User?>(
  (ref) => ref.watch(_auth).userChanges(),
);

final userIdAsyncValue = Provider<AsyncValue<String?>>(
  (ref) => ref.watch(authUser).whenData((user) => user?.uid),
);

final isSignedInAsyncValue = Provider(
  (ref) => ref.watch(userIdAsyncValue).whenData((userId) => userId != null),
);

final signInAnonymously = Provider.autoDispose<Future<void> Function()>(
  (ref) => () async {
    try {
      final userCredential = await ref.watch(_auth).signInAnonymously();
      final user = userCredential.user;
      if (user == null) {
        throw const AppException(message: '匿名サインインに失敗しました。');
      }
      final appUser = await ref.read(appUserRepository).fetchAppUser(appUserId: user.uid);
      if (appUser == null) {
        await ref.read(appUserRepository).setAppUser(appUserId: user.uid);
      }
    } on FirebaseException catch (e) {
      logger.warning(e.toString());
    } on AppException catch (e) {
      logger.warning(e.toString());
    }
  },
);

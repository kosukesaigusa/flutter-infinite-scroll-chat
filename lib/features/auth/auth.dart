import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/app_user.dart';
import '../../utils/exceptions/base.dart';
import '../../utils/logger.dart';

final _authProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(_authProvider).userChanges(),
);

final userIdAsyncValueProvider = Provider<AsyncValue<String?>>(
  (ref) => ref.watch(authUserProvider).whenData((user) => user?.uid),
);

final isSignedInAsyncValueProvider = Provider(
  (ref) => ref.watch(userIdAsyncValueProvider).whenData((userId) => userId != null),
);

final signInAnonymouslyProvider = Provider.autoDispose<Future<void> Function()>(
  (ref) => () async {
    try {
      final userCredential = await ref.watch(_authProvider).signInAnonymously();
      final user = userCredential.user;
      if (user == null) {
        throw const AppException(message: '匿名サインインに失敗しました。');
      }
      final appUser = await ref.read(appUserRepositoryProvider).fetchAppUser(appUserId: user.uid);
      if (appUser == null) {
        await ref.read(appUserRepositoryProvider).setAppUser(appUserId: user.uid);
      }
    } on FirebaseException catch (e) {
      logger.warning(e.toString());
    } on AppException catch (e) {
      logger.warning(e.toString());
    }
  },
);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore/app_user.dart';
import '../firestore/refs.dart';
import '../utils/extensions/list.dart';
import '../utils/logger.dart';

///
final baseAppUserRepositoryProvider =
    Provider.autoDispose<BaseAppUserRepository>((_) => throw UnimplementedError());

///
abstract class BaseAppUserRepository {
  /// 指定した AppUser を取得する。
  Future<AppUser?> fetchAppUser({required String appUserId});

  /// 指定した AppUser を購読する。
  Stream<AppUser?> subscribeAppUser({required String appUserId});

  /// 指定した userId のユーザードキュメントを作成する。
  Future<void> setAppUser({required String appUserId});
}

final appUserRepositoryProvider =
    Provider.autoDispose<BaseAppUserRepository>((_) => AppUserRepository());

///
class AppUserRepository implements BaseAppUserRepository {
  @override
  Future<AppUser?> fetchAppUser({required String appUserId}) async {
    final ds = await appUserRef(appUserId: appUserId).get();
    if (!ds.exists) {
      logger.warning('Document not found: ${ds.reference.path}');
      return null;
    }
    return ds.data();
  }

  @override
  Stream<AppUser?> subscribeAppUser({required String appUserId}) {
    final docStream = appUserRef(appUserId: appUserId).snapshots();
    return docStream.map((ds) => ds.data());
  }

  @override
  Future<void> setAppUser({required String appUserId}) async {
    await appUserRef(appUserId: appUserId).set(
      AppUser(
        appUserId: appUserId,
        name: names.random,
      ),
      SetOptions(merge: true),
    );
  }
}

final names = [
  'Colten',
  'Fip',
  'Jessie',
  'Perry',
  'Mohammed',
  'Warner',
  'Tyler',
  'Dawson',
  'Camille-Shel',
  'Nat-Merton',
  'Mel-Cameron',
  'Billy',
  'Darien',
  'Rickey',
  'John',
  'Blaine',
  'Randall',
  'Casimir-Anthony',
  'Carlos',
  'Elbert',
  'Kurson',
  'Carlyle',
  'Mattie',
  'Bryan',
  'Reggie',
  'Grant',
  'Innocent',
  'Gabriel',
  'Artie',
  'Owen',
  'Rich',
  'Jeffery',
  'Steve',
  'Lean-Anton',
  'Irwin',
  'Danny',
  'Martez-Gillian',
  'Milton',
  'Ralph',
  'Lee',
  'Galton',
  'Garrick',
  'Cyril',
  'Bernard',
  'Colin',
  'Euｇene',
  'Wilf',
  'Augustin',
  'Troy',
  'Vin',
];

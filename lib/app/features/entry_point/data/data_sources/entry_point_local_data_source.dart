import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;

import '../../../../core/utils/utils_exports.dart' show WithDelay;
import '../../../../core/errors/errors_exports.dart'
    show AuthNotFoundedException;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show AuthDataModel;

abstract class EntryPointLocalDataSource {
  Future<void> clearAuth(String key);
  Future<AuthDataModel> fetchAuth(String key);
  Future<void> persistAuth(String key, {required AuthDataModel authDataModel});
  Future<void> updateAuth(
    String key, {
    required AuthDataModel newAuthDataModel,
  });
}

class EntryPointLocalDataSourceImplementation
    implements EntryPointLocalDataSource {
  final FlutterSecureStorage secureStorage;

  EntryPointLocalDataSourceImplementation({required this.secureStorage});

  @override
  Future<void> clearAuth(String key) async {
    await secureStorage.delete(key: key);
  }

  @override
  Future<AuthDataModel> fetchAuth(String key) async {
    final encodedAuth = await secureStorage.read(key: key);
    if (encodedAuth != null) {
      final decodedAuth = AuthDataModel.fromJson(encodedAuth);
      return decodedAuth.toFuture();
    } else {
      throw AuthNotFoundedException();
    }
  }

  @override
  Future<void> persistAuth(
    String key, {
    required AuthDataModel authDataModel,
  }) async {
    await secureStorage.write(key: key, value: authDataModel.toJson());
  }

  @override
  Future<void> updateAuth(
    String key, {
    required AuthDataModel newAuthDataModel,
  }) async {
    // clear old auth
    await clearAuth(key);
    // then, write new auth -- becuase package doesn't support directly update
    await persistAuth(key, authDataModel: newAuthDataModel);
  }
}

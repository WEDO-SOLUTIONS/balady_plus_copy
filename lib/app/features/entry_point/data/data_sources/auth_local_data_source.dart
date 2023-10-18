import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/local/shared_prefs_manager.dart';
import '../../../../core/services/local/use_case.dart';
import '../../entry_point_exports.dart';

abstract class EntryPointLocalDataSource {
  Future<bool> saveAuth(SSOToken params);
  Future<SSOToken> getAuth();
  Future<NoType> clearAuth();
  Future<bool> saveSSOProfile(SsoUserInfo params);
  Future<SsoUserInfo> checkSSOProfile();
//  Future<bool> saveProfile(Profile params);
//  Future<Profile> checkProfile();
}

class EntryPointLocalDataSourceImpl extends EntryPointLocalDataSource {
  EntryPointLocalDataSourceImpl();

  @override
  Future<bool> saveAuth(SSOToken params) {
    try {
      print("saveeeed coookie ${params.appCookie}");
      sharedPrefs.setSSOToken(params.toModel);
      return Future.value(true);
    } catch (error) {
      throw ServerException(
        error.toString(),
      );
    }
  }

  @override
  Future<SSOToken> getAuth() {
    try {
      SSOTokenModel? token = sharedPrefs.getSSOToken();
      if (token != null) {
        print("saveeeed coookie111 ${token.appCookie}");

        return Future.value(token);
      } else {
        throw AuthNotFoundedException();
      }
    } catch (error) {
      throw AuthNotFoundedException();
    }
  }

  @override
  Future<NoType> clearAuth() {
    try {
      sharedPrefs.setSSOToken(null);
      return Future.value(NoType());
    } catch (error) {
      throw AuthNotFoundedException();
    }
  }

  @override
  Future<bool> saveSSOProfile(SsoUserInfo params) {
    try {
      sharedPrefs.setSSOUserProfile(params.toModel);
      return Future.value(true);
    } catch (error) {
      throw ServerException(
        error.toString(),
      );
    }
  }

  @override
  Future<SsoUserInfo> checkSSOProfile() {
    try {
      SsoUserInfo? profile = sharedPrefs.getSSOUserProfile();
      if (profile != null) {
        return Future.value(profile);
      } else {
        throw AuthNotFoundedException();
      }
    } catch (error) {
      throw AuthNotFoundedException();
    }
  }
}

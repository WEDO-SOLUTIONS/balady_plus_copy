import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/local/shared_prefs_manager.dart';
import '../../../../core/services/local/use_case.dart';
import '../../entry_point_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

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
      sharedPrefs.setSSOToken(params.toModel);
      return Future.value(true);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
        return Future.value(token);
      } else {
        throw AuthNotFoundedException();
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw AuthNotFoundedException();
    }
  }

  @override
  Future<NoType> clearAuth() {
    try {
      sharedPrefs.setSSOToken(null);
      return Future.value(NoType());
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw AuthNotFoundedException();
    }
  }

  @override
  Future<bool> saveSSOProfile(SsoUserInfo params) {
    try {
      sharedPrefs.setSSOUserProfile(params.toModel);
      return Future.value(true);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw AuthNotFoundedException();
    }
  }
}

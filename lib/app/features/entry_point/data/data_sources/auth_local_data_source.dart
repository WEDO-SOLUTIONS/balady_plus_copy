import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/errors/exceptions.dart';
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
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  EntryPointLocalDataSourceImpl();

  @override
  Future<bool> saveAuth(SSOToken params) async {
    try {
      await secureStorage.write(
        key: 'sso_token',
        value: json.encode(params.toModel.toJson()),
      );
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
  Future<SSOToken> getAuth() async {
    try {
      String? data = await secureStorage.read(key: 'sso_token');
      if (data != null) {
        SSOTokenModel token = SSOTokenModel.fromMap(json.decode(data));
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
      secureStorage.delete(key: "sso_token");
      secureStorage.delete(key: "sso_user_profile");
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
  Future<bool> saveSSOProfile(SsoUserInfo params) async {
    try {
      await secureStorage.write(
        key: 'sso_user_profile',
        value: json.encode(params.toModel.toJson()),
      );
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
  Future<SsoUserInfo> checkSSOProfile() async {
    try {
      String? data = await secureStorage.read(key: 'sso_user_profile');
      if (data != null) {
        SsoUserInfo profile = SsoUserInfoModel.fromJson(json.decode(data));
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

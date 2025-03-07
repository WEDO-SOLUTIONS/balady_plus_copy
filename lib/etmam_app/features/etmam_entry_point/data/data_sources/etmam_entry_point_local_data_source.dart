import 'dart:convert';

import 'package:balady_plus/etmam_app/core/errors/exceptions.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/data/models/profile_model.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/profile.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class EtmamEntryPointLocalDataSource {
  Future<bool> saveProfile(Profile params);
  Future<Profile> checkProfile();
}

class EtmamEntryPointLocalDataSourceImpl
    extends EtmamEntryPointLocalDataSource {

  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  EtmamEntryPointLocalDataSourceImpl();

  @override
  Future<Profile> checkProfile() async {
    try {
      String? data = await secureStorage.read(key: 'user_profile');
      if (data != null) {
        ProfileModel profile = ProfileModel.fromMap(json.decode(data));
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

  @override
  Future<bool> saveProfile(Profile params) async {
    try {
      await secureStorage.write(
        key: 'user_profile',
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
}

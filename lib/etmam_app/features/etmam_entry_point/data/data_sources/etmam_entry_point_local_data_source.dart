import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/etmam_app/core/errors/exceptions.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show NoType;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/data/models/profile_model.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/profile.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class EtmamEntryPointLocalDataSource {
  Future<bool> saveProfile(Profile params);
  Future<Profile> checkProfile();
}

class EtmamEntryPointLocalDataSourceImpl
    extends EtmamEntryPointLocalDataSource {
  EtmamEntryPointLocalDataSourceImpl();

  @override
  Future<Profile> checkProfile() {
    try {
      ProfileModel? profile = sharedPrefs.getUserProfile();
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

  @override
  Future<bool> saveProfile(Profile params) {
    try {
      sharedPrefs.setUserProfile(params.toModel);
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

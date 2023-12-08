import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/etmam_app/core/errors/exceptions.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show NoType;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/data/models/profile_model.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/profile.dart';

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
    } catch (error) {
      throw AuthNotFoundedException();
    }
  }

  @override
  Future<bool> saveProfile(Profile params) {
    try {
      sharedPrefs.setUserProfile(params.toModel);
      return Future.value(true);
    } catch (error) {
      throw ServerException(
        error.toString(),
      );
    }
  }
}

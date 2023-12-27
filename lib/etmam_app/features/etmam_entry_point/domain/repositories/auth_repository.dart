import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/create_profile_params.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class EtmamEntryPointRepository {
  Future<Either<Failure, ApigeeResponse<Profile>>> getProfile();

  Future<Either<Failure, bool>> saveProfile(Profile params);
  Future<Either<Failure, Profile>> checkProfile();
  Future<Either<Failure, ApigeeResponse<String>>> createProfile(
      CraeteProfileParams params);

  Future<Either<Failure, ApigeeResponse>> updateProfile(
      UpdateProfileParams params);

  Future<Either<Failure, ApigeeResponse<AddDeviceResponse>>> addDeviceToken(
      AddDeviceParams params);
  Future<Either<Failure, ApigeeResponse<UpdateDeviceResponse>>>
      updateDeviceToken(UpdateDeviceParams params);

  Future<Either<Failure, ForceUpdateResponse>> getForceVersion(
      ForceUpdateParams params);
}

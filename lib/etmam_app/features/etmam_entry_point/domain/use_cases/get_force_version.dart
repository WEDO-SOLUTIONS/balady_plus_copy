import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase, NoParams, NavigationService, NoType;
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';

import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show showUpdateAppPopUpWidget, ApigeeResponse;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart'
    show EtmamEntryPointRepository, ForceUpdateResponse, ForceUpdateParams;
import 'package:version/version.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetForceVersion extends UseCase<bool, NoParams> {
  final EtmamEntryPointRepository repository;

  GetForceVersion({required this.repository});
  @override
  Future<Either<Failure, bool>> call(NoParams p) async {
    ForceUpdateParams params = ForceUpdateParams(
        appId: "etmam_mobile", type: CommonProperties.deviceOs ?? "");
    final successsOrFailure = await repository.getForceVersion(params);
    return successsOrFailure.fold((l) => Right(false), (r) {
      print("SUCCCCCCCCESSSSSS ${r}");
      bool showForce = compareVersion(
          CommonProperties.appVersion, r.versionNumber, r.forceUpdate);
      return Right(showForce);
    });
  }

  bool compareVersion(
      String? currentVersionNo, String? latestVersionNo, bool? forceUpdate) {
    if (currentVersionNo != null &&
        latestVersionNo != null &&
        forceUpdate != null) {
      if (forceUpdate) {
        Version currentVersion = Version.parse(currentVersionNo);
        Version latestVersion = Version.parse(latestVersionNo);
        if (currentVersion < latestVersion) {
          return true;
        }
      }
    }
    return false;
  }
}

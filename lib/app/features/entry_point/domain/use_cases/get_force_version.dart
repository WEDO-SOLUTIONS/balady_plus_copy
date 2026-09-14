import 'package:dartz/dartz.dart' show Either, Right;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../entry_point_exports.dart';

import 'package:version/version.dart';

class GetForceVersion extends UseCase<bool, NoParams> {
  final EntryPointRepository repository;

  GetForceVersion({required this.repository});
  @override
  Future<Either<Failure, bool>> call(NoParams p) async {
    /*ForceUpdateParams params = ForceUpdateParams(
        appId: "etmam_mobile", type: CommonProperties.deviceOs ?? "");
    final successsOrFailure = await repository.getForceVersion(params);
    return successsOrFailure.fold((l) => Right(false), (r) {
      bool showForce = compareVersion(
          CommonProperties.appVersion, r.versionNumber, r.forceUpdate);
      return Right(showForce);
    });*/
    return Right(false);
  }

  bool compareVersion(String? currentVersionNo, String? latestVersionNo, bool? forceUpdate) {
    if (currentVersionNo != null && latestVersionNo != null && forceUpdate != null) {
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

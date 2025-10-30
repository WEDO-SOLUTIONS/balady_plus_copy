import 'dart:io';

import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:dartz/dartz.dart' show Either, Right;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart'
    show EtmamEntryPointRepository, AddDeviceParams, UpdateDeviceParams;
import '../../../../core/errors/errors_exports.dart' show Failure;

class UpdateDeviceToken extends UseCase<NoType, NoParams> {
  final EtmamEntryPointRepository repository;

  UpdateDeviceToken({required this.repository});
  @override
  Future<Either<Failure, NoType>> call(NoParams params) async {
    String os = Platform.isIOS ? "ios" : "android";
    final successOrFailureForAdd = await repository.addDeviceToken(
        AddDeviceParams(
            id: CommonProperties.deviceId,
            typeId: "mobile",
            notificationToken: CommonProperties.fcmToken,
            name: CommonProperties.deviceName,
            os: os));

    successOrFailureForAdd.fold((l) async {
      final successOrFailureForUpdate = await repository.updateDeviceToken(
          UpdateDeviceParams(
              id: CommonProperties.deviceId,
              os: os,
              name: CommonProperties.deviceName,
              notificationToken: CommonProperties.fcmToken));
    }, (r) => null);

    return Right(NoType());
  }
}

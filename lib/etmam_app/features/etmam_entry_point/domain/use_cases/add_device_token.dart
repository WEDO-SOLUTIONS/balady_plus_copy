import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:dartz/dartz.dart' show Either, Right;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart'
    show
        EtmamEntryPointRepository,
        AddDeviceResponse,
        AddDeviceParams,
        UpdateDeviceParams;
import '../../../../core/errors/errors_exports.dart' show Failure;

class AddDeviceToken extends UseCase<NoType, AddDeviceParams> {
  final EtmamEntryPointRepository repository;

  AddDeviceToken({required this.repository});
  @override
  Future<Either<Failure, NoType>> call(AddDeviceParams params) async {
    Either<Failure, ApigeeResponse<AddDeviceResponse>> res =
        await repository.addDeviceToken(params);

    await res.fold((failure) async {
      await repository.updateDeviceToken(UpdateDeviceParams(
          id: params.id,
          name: params.name,
          notificationToken: params.notificationToken,
          os: params.os));
    }, (success) {});

    return Right(NoType());
  }
}

import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../entities/vehicle_item_params.dart';
import '../entities/vehicle_response.dart';
import '../repositories/dc_repository.dart';

class GetMyVehicles
    extends UseCase<ResponseBodyModel<VehicleResponse>, VehicleItemParams> {
  final DCRetriveRepository repository;

  GetMyVehicles({required this.repository});

  @override
  Future<Either<Failure, ResponseBodyModel<VehicleResponse>>> call(
      VehicleItemParams params) async {
    return await repository.getMyVehicles(params: params);
  }
}

import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../vd/domain/entities/create_incident/create_incident_response.dart';
import '../../data/model/create_retrive_car_request.dart';
import '../entities/vehicle_item_params.dart';
import '../entities/vehicle_response.dart';

abstract class DCRetriveRepository {
  Future<Either<Failure, ResponseBodyModel<VehicleResponse>>> getMyVehicles(
      {required VehicleItemParams params});

  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>>
      createRetriveCar({required CreateRetriveCarRequest params});
}

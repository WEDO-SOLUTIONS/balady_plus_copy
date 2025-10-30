import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../damaged_cars_exports.dart'
    show ActiveLocationParams, CarModel, CarType;
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../../vd/vd_exports.dart'
    show CreateIncidentResponse, CreateIncidentParams;

abstract class DCRepository {
  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>>
      createIncidentRegistered({required CreateIncidentParams params});

  Future<Either<Failure, List<CarType>>> getCarTypes();

  Future<Either<Failure, List<CarModel>>> getCarModels(
      {required String params});

  Future<Either<Failure, bool>> checkActiveLocation(
      {required ActiveLocationParams params});
}

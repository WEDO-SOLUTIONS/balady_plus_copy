import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../../vd/domain/entities/create_incident/create_incident_response.dart';
import '../../data/model/create_retrive_car_request.dart';
import '../repositories/dc_repository.dart';

class CreateReriveCarRequest extends UseCase<
    ResponseBodyModel<CreateIncidentResponse>, CreateRetriveCarRequest> {
  final DCRetriveRepository repository;

  CreateReriveCarRequest({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>> call(
      CreateRetriveCarRequest params) async {
    return await repository.createRetriveCar(params: params);
  }
}

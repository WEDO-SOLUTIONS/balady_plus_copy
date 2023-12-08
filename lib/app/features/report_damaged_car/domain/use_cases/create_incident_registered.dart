import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../repositories/dc_repository.dart';
import '../../../vd/vd_exports.dart'
    show CreateIncidentParams, CreateIncidentResponse;
import '../../../_shared_feature_/data/models/response_body_model.dart';

class CreateDamagedCarInc extends UseCase<
    ResponseBodyModel<CreateIncidentResponse>, CreateIncidentParams> {
  final DCRepository repository;

  CreateDamagedCarInc({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>> call(
      CreateIncidentParams params) async {
    return await repository.createIncidentRegistered(params: params);
  }
}

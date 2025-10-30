import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show VDRepository, CreateIncidentParams, CreateIncidentResponse;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart'
    show UseCase;

import 'package:dartz/dartz.dart' show Either;

import '../../../_shared_feature_/data/models/response_body_model.dart';

class CreateIncidentRegistered extends UseCase<
    ResponseBodyModel<CreateIncidentResponse>, CreateIncidentParams> {
  final VDRepository repository;

  CreateIncidentRegistered({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>> call(
      CreateIncidentParams params) async {
    return await repository.createIncidentRegistered(params: params);
  }
}

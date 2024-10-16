import '/app/features/details/data/models/entity_violation_activity_model.dart';
import '/app/features/details/domain/entities/entity_violation_activity_request_params.dart';
import '/app/features/details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetViolationEntityActivityDetailsUC extends UseCase<
    List<EntityViolationActivityModel>, EntityViolationActivityRequestParams> {
  final DetailsRepository repository;

  GetViolationEntityActivityDetailsUC({required this.repository});

  @override
  Future<Either<Failure, List<EntityViolationActivityModel>>> call(
      EntityViolationActivityRequestParams params) async {
    return await repository.getViolationEntityDetails(params);
  }
}

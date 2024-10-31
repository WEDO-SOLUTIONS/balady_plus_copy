import '/app/features/details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/entity_violation_activity_details_model.dart';
import '../entities/entity_violation_activity_details_request_params.dart';

class GetViolationDetailsUC extends UseCase<EntityViolationActivityDetailsModel,
    EntityViolationActivityDetailsRequestParams> {
  final DetailsRepository repository;

  GetViolationDetailsUC({required this.repository});

  @override
  Future<Either<Failure, EntityViolationActivityDetailsModel>> call(
      EntityViolationActivityDetailsRequestParams params) async {
    return await repository.getEntityViolationActivityDetails(params);
  }
}

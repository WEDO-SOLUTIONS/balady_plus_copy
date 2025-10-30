import '/app/features/map/data/models/validate_point_response_model.dart';
import '/app/features/map/domain/entities/validate_point_request.dart';
import '/app/features/map/domain/entities/validate_point_response.dart';
import '/app/features/map/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;

class ValidatePointUC
    extends UseCase<List<ValidatePointResponse>, ValidatePointRequest> {
  final SmartAdvisorMapRepository repository;

  ValidatePointUC({required this.repository});

  @override
  Future<Either<Failure, List<ValidatePointResponse>>> call(
      ValidatePointRequest request) async {
    return await repository.validatePoint(request);
  }
}

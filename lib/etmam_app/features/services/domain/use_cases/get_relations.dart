import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServicesRepository, RelationResponse, RelationParams;

import '../../../../core/errors/errors_exports.dart' show Failure;

class GetReleation
    extends UseCase<ApigeeResponse<RelationResponse>, RelationParams> {
  final ServicesRepository repository;

  GetReleation({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<RelationResponse>>> call(
      RelationParams params) async {
    return await repository.getRelations(params: params);
  }
}

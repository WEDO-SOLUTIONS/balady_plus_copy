import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show
        ServiceResponse,
        ServiceParams,
        ServiceDetailsResponse,
        ServiceDetailsParams,
        RelationResponse,
        RelationParams;

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class ServicesRepository {
  Future<Either<Failure, ApigeeResponse<ServiceResponse>>> getServices(
      {required ServiceParams params});

  Future<Either<Failure, ApigeeResponse<ServiceDetailsResponse>>>
      getServiceDetails({required ServiceDetailsParams params});

  Future<Either<Failure, ApigeeResponse<RelationResponse>>> getRelations(
      {required RelationParams params});
}

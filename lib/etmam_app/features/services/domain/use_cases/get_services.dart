import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServicesRepository, ServiceResponse, ServiceParams;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetServicesProvidersByService
    extends UseCase<ApigeeResponse<ServiceResponse>, ServiceParams> {
  final ServicesRepository repository;

  GetServicesProvidersByService({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<ServiceResponse>>> call(
      ServiceParams params) async {
    return await repository.getServices(params: params);
  }
}

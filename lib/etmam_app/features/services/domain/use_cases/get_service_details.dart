import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServicesRepository, ServiceDetailsResponse, ServiceDetailsParams;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetServiceDetails extends UseCase<ApigeeResponse<ServiceDetailsResponse>,
    ServiceDetailsParams> {
  final ServicesRepository repository;

  GetServiceDetails({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<ServiceDetailsResponse>>> call(
      ServiceDetailsParams params) async {
    return await repository.getServiceDetails(params: params);
  }
}

import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show HomeRepository, SubServiceResponse, SubServiceParams;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetSubService
    extends UseCase<ApigeeResponse<SubServiceResponse>, SubServiceParams> {
  final HomeRepository repository;

  GetSubService({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<SubServiceResponse>>> call(
      SubServiceParams params) async {
    return await repository.getSubServices(params: params);
  }
}

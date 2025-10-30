import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show HomeRepository, SubServiceResponse, TopOrderedSubServiceParams;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetTopOrderedSubService extends UseCase<
    ApigeeResponse<SubServiceResponse>, TopOrderedSubServiceParams> {
  final HomeRepository repository;

  GetTopOrderedSubService({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<SubServiceResponse>>> call(
      TopOrderedSubServiceParams params) async {
    return await repository.getTopOrderedSubServices(params: params);
  }
}

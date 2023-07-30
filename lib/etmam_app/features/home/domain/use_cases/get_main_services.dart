import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show HomeRepository, MainServiceResponse, MainServiceParams;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetMainServices
    extends UseCase<ApigeeResponse<MainServiceResponse>, MainServiceParams> {
  final HomeRepository repository;

  GetMainServices({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<MainServiceResponse>>> call(
      MainServiceParams params) async {
    return await repository.getMainServices(params: params);
  }
}

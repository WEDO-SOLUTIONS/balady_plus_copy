import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ProviderResponse;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show HomeRepository, TopRatedProviderParams;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetTopRatedProviders
    extends UseCase<ApigeeResponse<ProviderResponse>, TopRatedProviderParams> {
  final HomeRepository repository;

  GetTopRatedProviders({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<ProviderResponse>>> call(
      TopRatedProviderParams params) async {
    return await repository.getTopRatedProviders(params: params);
  }
}

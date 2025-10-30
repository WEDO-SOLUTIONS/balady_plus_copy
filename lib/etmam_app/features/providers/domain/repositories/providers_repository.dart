import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ProviderResponse;
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show ProviderParams, ProviderDetailsParams, ProviderDetailsResponse;

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class ProvidersRepository {
  Future<Either<Failure, ApigeeResponse<ProviderResponse>>> getProviders(
      {required ProviderParams params});

  Future<Either<Failure, ApigeeResponse<ProviderDetailsResponse>>>
      getProviderDetails({required ProviderDetailsParams params});
}

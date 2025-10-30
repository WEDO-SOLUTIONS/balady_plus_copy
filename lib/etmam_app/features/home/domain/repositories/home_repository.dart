import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ProviderResponse;
import 'package:balady_plus/etmam_app/features/home/domain/entities/ads/ads_response.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        MainServiceParams,
        SubServiceParams,
        MainServiceResponse,
        SubServiceResponse,
        TopOrderedSubServiceParams,
        TopRatedProviderParams;
import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class HomeRepository {
  Future<Either<Failure, ApigeeResponse<MainServiceResponse>>> getMainServices(
      {required MainServiceParams params});

  Future<Either<Failure, ApigeeResponse<SubServiceResponse>>>
      getTopOrderedSubServices({required TopOrderedSubServiceParams params});

  Future<Either<Failure, ApigeeResponse<ProviderResponse>>>
      getTopRatedProviders({required TopRatedProviderParams params});

  Future<Either<Failure, ApigeeResponse<SubServiceResponse>>> getSubServices(
      {required SubServiceParams params});

  Future<Either<Failure, ApigeeResponse<AdsResponse>>> getAds();
}

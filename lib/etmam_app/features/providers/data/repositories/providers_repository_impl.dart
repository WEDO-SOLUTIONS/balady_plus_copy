import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ProviderResponse;
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/etmam_app/features/providers/domain/entities/provider_details_response.dart';
import 'package:balady_plus/etmam_app/features/providers/domain/entities/provider_details_params.dart';

import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show
        ProvidersRepository,
        ProviderParams,
        ProvidersLocalDataSource,
        ProvidersRemoteDataSource,
        ProvidersCacheDataSource;
import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

class ProvidersRepositoryImpl implements ProvidersRepository {
  final ProvidersRemoteDataSource remoteDataSource;
  final ProvidersCacheDataSource cacheDataSource;
  final ProvidersLocalDataSource localDataSource;

  ProvidersRepositoryImpl(
      {required this.remoteDataSource,
      required this.cacheDataSource,
      required this.localDataSource});

  @override
  Future<Either<Failure, ApigeeResponse<ProviderResponse>>> getProviders(
      {required ProviderParams params}) async {
    try {
      final data = await remoteDataSource.getProviders(params: params);

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<ProviderDetailsResponse>>>
      getProviderDetails({required ProviderDetailsParams params}) async {
    try {
      final data = await remoteDataSource.getProviderDetails(params: params);

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}

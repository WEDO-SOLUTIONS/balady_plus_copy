import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ProviderResponse;
import 'package:balady_plus/etmam_app/features/home/domain/entities/ads/ads_response.dart';
import 'package:balady_plus/etmam_app/features/home/domain/entities/sub_services/sub_service_params.dart';
import 'package:balady_plus/etmam_app/features/home/domain/entities/top_rated_providers/top_rated_provider_params.dart';

import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        HomeRepository,
        HomeCacheDataSource,
        HomeRemoteDataSource,
        SubServiceResponse,
        MainServiceResponse,
        HomeLocalDataSource,
        TopOrderedSubServiceParams,
        MainServiceParams;
import 'package:dartz/dartz.dart' show Either, Left, Right;
import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeCacheDataSource cacheDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl(
      {required this.remoteDataSource,
      required this.cacheDataSource,
      required this.localDataSource});

  @override
  Future<Either<Failure, ApigeeResponse<MainServiceResponse>>> getMainServices(
      {required MainServiceParams params}) async {
    try {
      final data = await remoteDataSource.getMainServices(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<SubServiceResponse>>>
      getTopOrderedSubServices(
          {required TopOrderedSubServiceParams params}) async {
    try {
      final data =
          await remoteDataSource.getTopOrderedSubServices(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<ProviderResponse>>>
      getTopRatedProviders({required TopRatedProviderParams params}) async {
    try {
      final data = await remoteDataSource.getTopRatedProviders(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<SubServiceResponse>>> getSubServices(
      {required SubServiceParams params}) async {
    try {
      final data = await remoteDataSource.getSubServices(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<AdsResponse>>> getAds() async {
    try {
      final data = await remoteDataSource.getAds();

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}

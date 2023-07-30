import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, CityResponse;

import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart'
    show CityRemoteDataSource, CityLocalDataSource, CityRepository;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

class CityRepositoryImpl implements CityRepository {
  final CityRemoteDataSource remoteDataSource;
  final CityLocalDataSource localDataSource;

  CityRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, ApigeeResponse<CityResponse>>> getCities() async {
    try {
      final data = await remoteDataSource.getCities();

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  /* @override
  Future<Either<Failure, ApigeeResponse<MainServiceResponse>>> getMainServices(
      {required MainServiceParams params}) async {
    try {
      final data = await remoteDataSource.getMainServices(params: params);

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }*/
}

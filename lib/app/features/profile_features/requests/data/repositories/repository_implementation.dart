import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../requests_exports.dart'
    show
        RequestsRepository,
        RequestsRemoteDataSource,
        MunicipalityEntity,
        RequestEntity,
        RequestStatusEntity,
        RequestSubTypeEntity,
        RequestSubTypeParamsModel,
        RequestTypeEntity,
        RequestsPrams,
        SubMunicipalityEntity,
        SubMunicipalityParamsModel;

class RequestsRepositoryImplementation implements RequestsRepository {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<RequestEntity>>> getRequests(
    RequestsPrams params,
  ) async {
    try {
      final data = await remoteDataSource.getRequests(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<RequestStatusEntity>>>
      getRequestStatuses() async {
    try {
      final data = await remoteDataSource.getRequestStatuses();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<MunicipalityEntity>>> getMunicipalities() async {
    try {
      final data = await remoteDataSource.getMunicipalities();
      // return Left(ServerFailure("testing Errors"));
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<SubMunicipalityEntity>>> getSubMunicipalities(
    SubMunicipalityParamsModel params,
  ) async {
    try {
      final data = await remoteDataSource.getSubMunicipalities(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<RequestTypeEntity>>> getRequestTypes() async {
    try {
      final data = await remoteDataSource.getRequestTypes();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<RequestSubTypeEntity>>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  ) async {
    try {
      final data = await remoteDataSource.getRequestSubTypes(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}

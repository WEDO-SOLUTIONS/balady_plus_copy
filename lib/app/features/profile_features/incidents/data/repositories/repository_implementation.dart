import 'package:balady_plus/app/features/profile_features/incidents/data/models/request_details_response.dart';
import 'package:balady_plus/app/features/profile_features/incidents/domain/entities/request_details_response.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../requests_exports.dart'
    show RequestsRepository, RequestsRemoteDataSource;

class RequestsRepositoryImplementation implements RequestsRepository {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, RequestDetailsResponse>> getCRMINQRequestDetails(
      String params) async {
    try {
      final data = await remoteDataSource.getCRMINQRequestDetails(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, RequestDetailsResponse>> getCRMIncidentRequestDetails(
      String params) async {
    try {
      final data = await remoteDataSource.getCRMIncidentRequestDetails(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, RequestDetailsResponse>> getCRMREQRequestDetails(
      String params) async {
    try {
      final data = await remoteDataSource.getCRMREQRequestDetails(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, CrmRequestDetails>> getDCRequestDetails(
      String params) async {
    try {
      final data = await remoteDataSource.getRequestDetails(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}

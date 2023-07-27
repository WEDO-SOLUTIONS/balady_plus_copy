import 'package:balady_plus/app/features/objectable_transactions/domain/entities/create_objection_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/create_objection_response.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/transaction_details.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/transaction_details_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/upload_file_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/upload_file_response.dart';
import 'package:balady_plus/app/features/objections/domain/entities/objection_details.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../objections_exports.dart'
    show
        RequestsRepository,
        RequestsRemoteDataSource,
        ObjectableTransactionsEntity,
        RequestStatusEntity,
        RequestSubTypeEntity,
        RequestSubTypeParamsModel,
        RequestTypeEntity,
        TransactionsRequestsPrams;

class RequestsRepositoryImplementation implements RequestsRepository {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepositoryImplementation({
    required this.remoteDataSource,
  });

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

  @override
  Future<Either<Failure, List<ObjectableTransactionsEntity>>>
      getObjectionRequests(TransactionsRequestsPrams params) {
    // TODO: implement getObjectionRequests
    throw UnimplementedError();
  }
}

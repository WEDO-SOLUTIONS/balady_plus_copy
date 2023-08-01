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
import '../../violations_exports.dart'
    show
        InvoiceStatusesEntity,
        ObjectableTransactionsEntity,
        RequestSubTypeEntity,
        RequestSubTypeParamsModel,
        ViolationsRemoteDataSource,
        ViolationsRepository,
        ViolationsPrams,
        ViolationsEntity,
        ViolationsStatusEntity;

class ViolationsRepositoryImplementation implements ViolationsRepository {
  final ViolationsRemoteDataSource remoteDataSource;

  ViolationsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ViolationsStatusEntity>>>
      getViolationsStatus() async {
    try {
      final data = await remoteDataSource.getViolationsStatuses();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceStatusesEntity>>>
      getInvoiceStatuses() async {
    try {
      final data = await remoteDataSource.getInvoiceStatuses();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ViolationsEntity>>> getViolations(
      ViolationsPrams params) async {
    try {
      final data = await remoteDataSource.getViolations(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}

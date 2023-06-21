import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../invoices_exports.dart'
    show
        InvoicesRepository,
        InvoicesRemoteDataSource,
        InvoiceEntity,
        InvoiceStatusEntity,
        InvoiceSubTypeEntity,
        InvoiceSubTypeParamsModel,
        InvoiceTypeEntity,
        InvoicesPrams;

class InvoicesRepositoryImplementation implements InvoicesRepository {
  final InvoicesRemoteDataSource remoteDataSource;

  InvoicesRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices(
    InvoicesPrams params,
  ) async {
    try {
      final data = await remoteDataSource.getInvoices(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceStatusEntity>>>
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
  Future<Either<Failure, List<InvoiceTypeEntity>>> getInvoiceTypes() async {
    try {
      final data = await remoteDataSource.getInvoiceTypes();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceSubTypeEntity>>> getInvoiceSubTypes(
    InvoiceSubTypeParamsModel params,
  ) async {
    try {
      final data = await remoteDataSource.getInvoiceSubTypes(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}

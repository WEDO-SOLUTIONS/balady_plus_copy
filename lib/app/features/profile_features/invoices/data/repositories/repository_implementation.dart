import 'package:balady_plus/app/features/profile_features/invoices/data/models/invoice_details_params_model.dart';
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
        InvoiceDetailsEntity,
        InvoiceEntity,
        InvoiceStatusEntity,
        InvoiceSubTypeEntity,
        InvoiceSubTypeParamsModel,
        InvoiceTypeEntity,
        InvoicesPrams,
        InvoicesRemoteDataSource,
        InvoicesRepository;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

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
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, InvoiceDetailsEntity>> getInvoiceDetails(
    InvoiceDetailsParamsModel params,
  ) async {
    try {
      final data = await remoteDataSource.getInvoiceDetails(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }
}

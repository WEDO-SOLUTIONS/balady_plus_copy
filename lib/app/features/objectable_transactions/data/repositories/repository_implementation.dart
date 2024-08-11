import 'package:balady_plus/app/features/objectable_transactions/domain/entities/create_objection_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/create_objection_response.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/enquiry_objection_reply_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/objection_enquiry_details.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/transaction_details.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/transaction_details_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/upload_file_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/upload_file_response.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/validate_objection_params.dart';
import 'package:balady_plus/app/features/objections/domain/entities/objection_details.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart'
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
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RequestsRepositoryImplementation implements RequestsRepository {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ObjectableTransactionsEntity>>>
      getObjectionRequests(
    TransactionsRequestsPrams params,
  ) async {
    try {
      final data = await remoteDataSource.getObjectionRequests(params);
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
  Future<Either<Failure, List<RequestStatusEntity>>>
      getRequestStatuses() async {
    try {
      final data = await remoteDataSource.getRequestStatuses();
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
  Future<Either<Failure, List<RequestTypeEntity>>> getRequestTypes() async {
    try {
      final data = await remoteDataSource.getRequestTypes();
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
  Future<Either<Failure, List<RequestSubTypeEntity>>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  ) async {
    try {
      final data = await remoteDataSource.getRequestSubTypes(params);
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
  Future<Either<Failure, CreateObjectionResponse>> createObjection(
      {required CreateObjectionParams params}) async {
    try {
      final data = await remoteDataSource.createObjection(params: params);
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
  Future<Either<Failure, UploadFileResponse>> uploadFile(
      {required UploadFileParams params}) async {
    try {
      final data = await remoteDataSource.uploadFile(params: params);
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
  Future<Either<Failure, ObjectionDetails>> getObjectionDetails(
      String id) async {
    try {
      final data = await remoteDataSource.getObjectionDetails(id);
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
  Future<Either<Failure, TransactionDetails>> getTransactionDetails(
      TransactionDetailsParams params) async {
    try {
      final data = await remoteDataSource.getTransactionDetails(params);
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
  Future<Either<Failure, bool>> validateObjectableTransaction(
      ValidateObjectionParams params) async {
    try {
      final data = await remoteDataSource.validateObjectableTransaction(params);
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
  Future<Either<Failure, ObjectionEnquiryDetails>> getEnquiryObjectionDetails(
      String id) async {
    try {
      final data = await remoteDataSource.getEnquiryObjectionDetails(id);
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
  Future<Either<Failure, dynamic>> replyEnquiryObjectionDetails(
      EnquiryObjectionReplyDetails request) async {
    try {
      final data = await remoteDataSource.replyEnquiryObjectionDetails(request);
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
  Future<Either<Failure, UploadFileResponse>> uploadFileV2({required UploadFileParams params})  async {
    try {
      final data = await remoteDataSource.uploadFileV2(params: params);
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

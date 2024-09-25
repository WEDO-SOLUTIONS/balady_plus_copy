import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/commercial_model/features/comercial_license_renew/domain/entities/cr_attachment_request.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../commercial_license/domain/entities/save_shop_details_request.dart';
import '../../domain/entities/save_selected_requests_permits_request.dart';
import '../../domain/entities/save_shop_info_request.dart';
import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';
import '../models/request_attachments/request_attachments.dart';
import '../models/request_permits_model/permit.dart';
import '../models/request_permits_model/request_permits_model.dart';
import '../models/transfer_attachment_response/request_attachments_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RequestApprovalSequenceRepositoryImplementation
    implements RequestApprovalSequenceRepository {
  final RequestPermitsRemoteDataSource remoteDataSource;

  RequestApprovalSequenceRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, RequestPermitsModel>> getRequestPermits(
      int requestNumber) async {
    try {
      final data = await remoteDataSource.getRequestPermits(requestNumber);
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
  Future<Either<Failure, bool>> saveSelectedRequestPermits(
      int requestNumber,
      SaveSelectedRequestsPermitsRequest
          saveSelectedRequestsPermitsRequest) async {
    try {
      final data = await remoteDataSource.saveSelectedRequestsPermits(
          requestNumber, saveSelectedRequestsPermitsRequest);
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
  Future<Either<Failure, bool>> saveShopInfo(
      int requestNumber, SaveShopInfoRequest params) async {
    try {
      final data = await remoteDataSource.saveShopInfo(requestNumber, params);
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
  Future<Either<Failure, bool>> saveShopDetails(
      SaveShopDetailsRequest req) async {
    try {
      final data = await remoteDataSource.saveShopDetails(params: req);
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
  Future<Either<Failure, List<RequestAttachmentsResponse>>> requestAttachments(
      int requestNumber) async {
    try {
      final data = await remoteDataSource.requestAttachments(requestNumber);
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
  Future<Either<Failure, bool?>> uploadAttachments(
      CrAttachmentRequest params) async {
    try {
      final data = await remoteDataSource.uploadAttachments(params: params);
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
  Future<Either<Failure, bool>> saveAttachment(
       CrAttachmentRequest params) async {
    try {
      final data = await remoteDataSource.saveAttachment(params);
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
  Future<Either<Failure, bool>> uploadCredence(CrAttachmentRequest params) async {
    try {
      final data = await remoteDataSource.uploadCredence(params);
      return Right(data!);
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
  Future<Either<Failure, bool>> submitApprovel(int requestNumber) async{
    try {
      final data = await remoteDataSource.submitApprovel(requestNumber);
      return Right(data!);
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
}

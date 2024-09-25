import 'package:balady_plus/app/commercial_model/features/comercial_license_renew/domain/entities/save_renew_request.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import '../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../../../commercial_license/data/models/cr_submit_response_model.dart';
import '../../domain/entities/cr_attachment_response.dart';
import '../../renew_commercial_license_exports.dart';
import '../models/renew_request_details.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RenewCrRepositoryImpl implements RenewCrRepository {
  final RenewCrRemoteDataSource remoteDataSource;

  RenewCrRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CleanContractsResponse>> getCleanContracts(
      CleanContractsRequest? params) async {
    try {
      final data = await remoteDataSource.getCleanContracts(params: params);
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
  Future<Either<Failure, DeedInfoResponse>> getDeedInfo(
      DeedInfoRequest? params) async {
    try {
      final data = await remoteDataSource.getDeedInfo(params: params);
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
  Future<Either<Failure, EjarInfoResponse>> getEjarInfo(
      EjarInfoRequest? params) async {
    try {
      final data = await remoteDataSource.getEjarInfo(params: params);
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
  Future<Either<Failure, InvestmentContractResponse>> getInvestmentContracts(
      InvestmentContractRequest? params) async {
    try {
      final data =
          await remoteDataSource.getInvestmentContracts(params: params);
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
  Future<Either<Failure, CrAttachmentResponse>> getCRAttachments(
      int? params) async {
    try {
      final data = await remoteDataSource.getCRAttachment(params: params);
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
  Future<Either<Failure, bool>> saveAttachment(
      {required CrAttachmentRequest params}) async {
    try {
      final data = await remoteDataSource.saveAttachment(params: params);
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
  Future<Either<Failure, RenewRequestDetails>> getRequestDetails(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getRequestDetails(params: params);
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
  Future<Either<Failure, ResponseBodyModel<int>>> renewApply(
      {required RenewApplyRequest? params}) async {
    try {
      final data = await remoteDataSource.renewApply(params: params);
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
  Future<Either<Failure, ResponseBodyModel<bool>>> validateRenewBeforeApply(
      {required int? params}) async {
    try {
      final data =
          await remoteDataSource.validateRenewBeforeApply(params: params);
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
  Future<Either<Failure, ResponseBodyModel<List<int>>>> getRenewYears(
      {required int? params}) async {
    try {
      final data = await remoteDataSource.renewYears(params: params);
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
  Future<Either<Failure, RenewRequestInfo>> calculateRequestInfo(
      {required RenewInfoRequest? params}) async {
    try {
      final data = await remoteDataSource.calculateRequestInfo(params: params);
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
  Future<Either<Failure, ResponseBodyModel<dynamic>>> saveRenewRequestInfo(
      {required SaveRenewRequest? params}) async {
    try {
      final data = await remoteDataSource.saveRenewRequestInfo(params: params);
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
  Future<Either<Failure, dynamic>> submitRenewAttachments(
      {required int? params}) async {
    try {
      final data =
          await remoteDataSource.submitRenewAttachments(params: params);
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
  Future<Either<Failure, ResponseBodyModel<CrSubmitResponseModel>>> submitRenew(
      {required int params}) async {
    try {
      final data = await remoteDataSource.submitRenew(params: params);
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
}

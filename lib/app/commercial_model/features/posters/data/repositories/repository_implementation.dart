import 'package:balady_plus/app/commercial_model/features/posters/data/models/allowed_actions_response.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/attachment_resposne_model.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/group_item_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/permit_apply_group_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/permit_license_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/permit_poster_types_response.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/permit_submit_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/permits_alerts_response.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/poster_request_details_model.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/posters_upload_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/posters/domain/entities/permit_apply_group_request_params.dart';
import 'package:balady_plus/app/commercial_model/features/posters/domain/entities/permit_licenses_requests_params.dart';
import 'package:balady_plus/app/commercial_model/features/posters/domain/entities/permit_required_types_params.dart';
import 'package:balady_plus/app/commercial_model/features/posters/domain/entities/save_poster_request_params.dart';
import 'package:dartz/dartz.dart';

import 'package:balady_plus/app/core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../domain/repositores/repository.dart';
import '../data_sources/remote_data_source.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class PostersRepositoryImplementation implements PostersRepository {
  final PostersRemoteDataSource remoteDataSource;

  PostersRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, PermitApplyGroupResponse>> applyPermitLicenseGroup(
      {required PermitApplyGroupRequestParams params}) async {
    try {
      final data =
          await remoteDataSource.applyPermitLicenseGroup(params: params);
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
  Future<Either<Failure, AttachmentResponseModel>> getAttachmentTypes(
      {required PermitRequiredTypesParams params}) async {
    try {
      final data = await remoteDataSource.getAttachmentTypes(params: params);
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
  Future<Either<Failure, GroupItemResponseModel>> getGroupItems() async {
    try {
      final data = await remoteDataSource.getGroupItems();
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
  Future<Either<Failure, PermitsLicensesResponse>> getLicensePermits(
      {required PermitLicenseRequestParams params}) async {
    try {
      final data = await remoteDataSource.getLicensePermits(params: params);
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
  Future<Either<Failure, PermitPosterTypeResponse>>
      getPErmitPosterTypes() async {
    try {
      final data = await remoteDataSource.getPErmitPosterTypes();
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
  Future<Either<Failure, dynamic>> savePoster(
      {required SavePosterRequestParams params}) async {
    try {
      final data = await remoteDataSource.savePoster(params: params);
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
  Future<Either<Failure, PostersUploadResponse>> uploadPosterFile(
      {required PermitAttachmentItem params}) async {
    try {
      final data = await remoteDataSource.uploadPosterFile(params: params);
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
  Future<Either<Failure, bool>> addIndivisualRequests(
      {required int params}) async {
    try {
      final data = await remoteDataSource.addIndivisualRequests(params: params);
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
  Future<Either<Failure, PostersSubmitResponseModel>> submit(
      {required int params}) async {
    try {
      final data = await remoteDataSource.submit(params: params);
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
  Future<Either<Failure, PosterRequestDetailsModel>> getPosterRequestDetails(
      {required int params}) async {
    try {
      final data =
          await remoteDataSource.getPosterRequestDetails(params: params);
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
  Future<Either<Failure, bool>> deleteLicenseFromRequest(
      {required int requestId, required int licenseId}) async {
    try {
      final data = await remoteDataSource.deleteLicenseFromRequest(
          requestId: requestId, licenseId: licenseId);
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
  Future<Either<Failure, bool>> deletePermitRequest(
      {required int params}) async {
    try {
      final data =
          await remoteDataSource.deletePermitRequest(requestId: params);
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
  Future<Either<Failure, PermitAlertsResponse>> getPermitsAlerts() async {
    try {
      final data = await remoteDataSource.getPermitsAlerts();
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
  Future<Either<Failure, PermitApplyGroupResponse>> applyLicense(
      {required int params}) async {
    try {
      final data = await remoteDataSource.applyLicense(params: params);
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
  Future<Either<Failure, PosterAllowedAction>> getAllowedActionsOnRequest(
      {required int params}) async {
    try {
      final data =
          await remoteDataSource.getAllowedActionsOnRequest(params: params);
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

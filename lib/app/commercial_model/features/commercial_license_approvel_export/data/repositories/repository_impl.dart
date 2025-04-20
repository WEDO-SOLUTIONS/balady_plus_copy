import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/initialApproval/conclusion_response_entity.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/initialApproval/save_com_submitter_and_owner_request_model.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../models/initialApproval/fees_request.dart';
import '../models/initialApproval/isics_main_activity.dart';
import '../models/initialApproval/request_details_model.dart';
import '../models/initialApproval/save_activity_and_location_response_model.dart';
import '../models/initialApproval/sub_activity_details_data.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;

  RepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ResponseBodyModel<SubActivityDetailsData>>>
      getSubActivityDetails({required String id}) async {
    try {
      final data =
          await remoteDataSource.getSubActivityDetails(subActivityId: id);
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
  Future<Either<Failure, ResponseBodyModel<RequestDetailsModel>>> getInitialApprovalRequestDetails(int requestId) async {
    try {
      final data =
          await remoteDataSource.getInitialApprovalRequestDetails(requestId);

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
  Future<Either<Failure, List<IsicsMainActivity>>> getMainActivities( int requestID) async {
    try {
      final data = await remoteDataSource.getMainActivities(requestID,);

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
  Future<Either<Failure, List<SubActivityEntity>>> getSubActivities( int requestID,int isicCode) async {
    try {
      final data = await remoteDataSource.getSubActivities(requestID, isicCode);

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
  Future<Either<Failure, bool>> addIsicActivities(
      {required AddIsicActivityData params}) async {
    try {
      final data = await remoteDataSource.addIsicActivities(params: params);

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
  Future<Either<Failure, List<LookupsModel>>> getAccommodationTypes() async {
    try {
      final data = await remoteDataSource.getAccommodationTypes();

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
  Future<Either<Failure, int>> saveComSubmitterAndOwner(
      SubmitterAndOwnerRequestModel? params) async {
    try {
      final data =
          await remoteDataSource.saveComSubmitterAndOwner(params: params);
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
  Future<Either<Failure, int>> applyLicenseExport(int request) async {
    try {
      final data =
      await remoteDataSource.applyLicenseExport(request);
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
  Future<Either<Failure, ResponseBodyModel<SaveActivityAndLocationResponseModel>>> saveActivityDetails(
      SubmitActivityDetailRequest? params) async {
    try {
      final data = await remoteDataSource.saveActivityDetails(params: params);
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
  Future<Either<Failure, SaveLocationResponseModel>> saveLocationDetails(
      SaveLocationDataRequest? params) async {
    try {
      final data = await remoteDataSource.saveLocationDetails(params: params);
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
  Future<Either<Failure, CalculateFeesResponseModel>> crCalculateFee(
      {required CrCalculateFeesRequest params}) async {
    try {
      final data = await remoteDataSource.crCalculateFees(params: params);
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



  Future<Either<Failure, CalculateFeesResponseModel>> CalculateFeesInteractively(
      {required FeesRequest params})async{
    try {
      final data = await remoteDataSource.CalculateFeesInteractively(params: params);
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
  Future<Either<Failure, SubmitRequestResponseModel>> submitInitialApproval(int requestId)async {
    try {
      final data = await remoteDataSource.submitInitialApproval(requestId);
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
  Future<Either<Failure, IssueCommercialConculsionEntity>> getCommercialConculsion(
      {required int params}) async {
    try {
      final data =
          await remoteDataSource.getCommercialConculsion(params: params);
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
  Future<Either<Failure, bool>> cancelIntialApproval({required int params})async {
    try {
      final data = await remoteDataSource.cancelIntialApproval( requestId: params);
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
  Future<Either<Failure, String>> getSPLNotification({required String requestId, required String mencipiltyId}) async{
    try {
      final data = await remoteDataSource.getSPLNotification( requestId: requestId,mencipiltyId: mencipiltyId);
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
  Future<Either<Failure, bool>> ReplyWithNote(String requestId,String note,String noteId)async {
    try {
      final data = await remoteDataSource.ReplyWithNotes(requestId,note,noteId);
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

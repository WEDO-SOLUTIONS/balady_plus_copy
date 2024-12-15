import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/additional_activity_details_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/additional_activity_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/board_contract_responseModel.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/citizen_info.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/commercial_request_details_response_entity.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/conclusion_response_entity.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/qr/submit_commercial_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/qr/qr_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/qr/qr_lookup_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/qr/qr_submit_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/qr/save_enterprise_data_request_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/salama_warning_request.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/initialApproval/save_com_submitter_and_owner_request_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/addetional_activity_details_request.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/citizen_info_params.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/cr_submit_request.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/save_shop_details_request.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/verifiy_salama_requst.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../models/attachment_response_entity.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../models/initialApproval/fees_request.dart';
import '../models/initialApproval/isics_main_activity.dart';
import '../models/initialApproval/request_details_model.dart';
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
  Future<Either<Failure, int>> saveActivityDetails(
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
  Future<Either<Failure, CleanContractsResponseEntity>> getCleanContracts(
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
  Future<Either<Failure, DeedInfoResponseModel>> getDeedInfo(
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
  Future<Either<Failure, EjarInfoResponseModel>> getEjarInfo(
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
  Future<Either<Failure, InvestmentContractResponseModel>> getInvestmentContracts(
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
  Future<Either<Failure, AttachmentResponseEntity>> getCRAttachments(
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
  Future<Either<Failure, int>> addBeneficiaryNotes(
      {required CrAddNotesRequest params}) async {
    try {
      final data = await remoteDataSource.addBeneficiaryNotes(params: params);
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
  Future<Either<Failure, ResponseBodyModel<SubmitRequestResponseModel>>> submitCr(
      {required CrSubmitRequest params}) async {
    try {
      final data = await remoteDataSource.submitCr(params: params);
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
  Future<Either<Failure, dynamic>> saveShopDetails(
      {required SaveShopDetailsRequest params}) async {
    try {
      final data = await remoteDataSource.saveShopDetails(params: params);
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
  Future<Either<Failure, CleanOptionResponseEntity>> getCleanOptions(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getCleanOptions(params: params);
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
  Future<Either<Failure, List<String>>> getDeedOptions(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getDeedOptions(params: params);
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
  Future<Either<Failure, CredenceResponseModel>> getRequestCredences(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getRequestCredences(params: params);
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
  Future<Either<Failure, bool>> uploadCredence(
      {required CrAttachmentRequest params}) async {
    try {
      final data = await remoteDataSource.uploadCredence(params: params);
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
  Future<Either<Failure, bool>> validateApprovals({required int params}) async {
    try {
      final data = await remoteDataSource.validateApprovals(params: params);
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
  Future<Either<Failure, int>> validateSalamaAttachments(
      {required ValidateSalamaAttachmentsRequest params}) async {
    try {
      final data =
          await remoteDataSource.validateSalamaAttachments(params: params);
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
  Future<Either<Failure, bool>> fawrySalamaBills({required int params}) async {
    try {
      final data = await remoteDataSource.fawrySalamaBills(params: params);
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
  Future<Either<Failure, bool>> fawrySalamaReport({required int params}) async {
    try {
      final data = await remoteDataSource.fawrySalamaReports(params: params);
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
  Future<Either<Failure, SubmitCommercialResponseModel>> applyCommercialRequest(
      {required int params}) async {
    try {
      final data =
          await remoteDataSource.applyCommercialRequest(params: params);
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
  Future<Either<Failure, AttachmentResponseEntity>> getQrAttachments(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getQrAttachments(params: params);
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
  Future<Either<Failure, QrDetails>> getQrCodeDetails(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getQrCodeDetails(params: params);
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
  Future<Either<Failure, QrSubmitResponse>> qrSubmit(
      {required int params}) async {
    try {
      final data = await remoteDataSource.qrSubmit(params: params);
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
  Future<Either<Failure, int>> saveAddetionalQrData(
      {required AdditionalQrDataRequestModel params}) async {
    try {
      final data = await remoteDataSource.saveAddetionalQrData(params: params);
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
  Future<Either<Failure, int>> saveQrEnterpriseData(
      {required SaveEnterprisDataRequestModel params}) async {
    try {
      final data = await remoteDataSource.saveQrEnterpriseData(params: params);
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
  Future<Either<Failure, int>> saveQrWorkTimesData(
      {required SaveWorkTimesRequestModel params}) async {
    try {
      final data = await remoteDataSource.saveQrWorkTimesData(params: params);
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
  Future<Either<Failure, bool>> uploadQrAttachments(
      {required CrAttachmentRequest params}) async {
    try {
      final data = await remoteDataSource.uploadQrAttachment(params: params);
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
  Future<Either<Failure, QrLookUpResponseModel>> getQrLookUp(
      {required String params}) async {
    try {
      final data = await remoteDataSource.getQrLookUp(params: params);
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

  // @override
  // Future<Either<Failure, AddetionalActivityDetailsResponse>>
  //     getAddetionalDetailsActivites(
  //         {AddetionalActivityDetailsRequest? params}) async {
  //   try {
  //     final data =
  //         await remoteDataSource.getAddetionalDetailsActivites(params: params!);
  //     return Right(data);
  //   } on ServerException catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     return Left(ServerFailure(error.errorMessage,
  //         statusCode: error.statusCode, errorCode: error.errorCode));
  //   }
  // }

  @override
  Future<Either<Failure, QrLookUpResponseModel>> getMalls(
      {required String params}) async {
    try {
      final data = await remoteDataSource.getMalls(params: params!);
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
  Future<Either<Failure, dynamic>> validateSalamaBill(
      {required VerifySalamaRequest params}) async {
    try {
      final data = await remoteDataSource.validateSalamaBill(params: params!);
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
  Future<Either<Failure, dynamic>> validateSalamaPermit(
      {required VerifySalamaRequest params}) async {
    try {
      final data = await remoteDataSource.validateSalamaPermit(params: params!);
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
  Future<Either<Failure, dynamic>> validateSalamaReport(
      {required VerifySalamaRequest params}) async {
    try {
      final data = await remoteDataSource.validateSalamaReport(params: params!);
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
  Future<Either<Failure, String>> getWarningMessage(
      {required SalamaWarningRequest params}) async {
    try {
      final data = await remoteDataSource.getWarningMessage(params: params);
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
  Future<Either<Failure, String>> getWarningWorkFlowMessage(
      {required SalamaWarningRequest params}) async {
    try {
      final data =
          await remoteDataSource.getWarningWorkFlowMessage(params: params);
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
  Future<Either<Failure, BoardContractResponseModel>> getBoardContracts(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getBoardContracts(params: params);
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
  Future<Either<Failure, CitizenInfo>> getCizenInfo(
      {required CitizenInfoParams params}) async {
    try {
      final data = await remoteDataSource.getCizenInfo(params: params);
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
  Future<Either<Failure, CommercialRequestDetailsResponseEntity>> getRequestDetails(
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
}

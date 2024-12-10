import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/qr/submit_commercial_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/salama_warning_request.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../domain/entities/addetional_activity_details_request.dart';
import '../../domain/entities/citizen_info_params.dart';
import '../../domain/entities/cr_submit_request.dart';
import '../../domain/entities/save_shop_details_request.dart';
import '../../domain/entities/verifiy_salama_requst.dart';
import '../models/additional_activity_details_response.dart';
import '../models/additional_activity_response.dart';
import '../models/board_contract_responseModel.dart';
import '../models/citizen_info.dart';
import '../models/commercial_request_details_response_entity.dart';
import '../models/conclusion_response_entity.dart';
import '../models/attachment_response_entity.dart';
import '../models/cr_submit_response_model.dart';
import '../models/isics_main_activity.dart';
import '../models/qr/qr_lookup_model.dart';
import '../models/save_com_submitter_and_owner_request_model.dart';
import 'package:balady_plus/app/core/remote_services/pega_web_service.dart' as web;
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';
import '../models/qr/additional_qr_data_request_model.dart';
import '../models/qr/qr_details.dart';
import '../models/qr/save_enterprise_data_request_model.dart';
import '../models/qr/save_worktimes_request_model.dart';
import '../models/qr/qr_submit_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../models/sub_activity_details_data.dart';

abstract class RemoteDataSource {
  Future<ResponseBodyModel<RecordInfoModel>> getRecordInfo(
      {required String crNumber, required String role});
  Future<List<SubActivityModel>> getSubActivities(int requestID, int isicCode) ;
  Future<List<IsicsMainActivity>> getMainActivities(int requestID);
  Future<ResponseBodyModel<SubActivityDetailsData>> getSubActivityDetails(
      {required String subActivityId});
  Future<bool> addIsicActivities({required AddIsicActivitiesParams params});
  Future<List<LookupsModel>> getAccommodationTypes();

  Future<int> saveComSubmitterAndOwner(
      {SubmitterAndOwnerRequestModel? params});

  Future<int> saveActivityDetails({SubmitActivityDetailRequest? params});

  Future<SaveLocationResponseModel> saveLocationDetails(
      {SaveLocationDataRequest? params});

  Future<DeedInfoResponseModel> getDeedInfo({DeedInfoRequest? params});

  Future<EjarInfoResponseModel> getEjarInfo({EjarInfoRequest? params});

  Future<CleanContractsResponseEntity> getCleanContracts(
      {CleanContractsRequest? params});

  Future<InvestmentContractResponseModel> getInvestmentContracts(
      {InvestmentContractRequest? params});

  Future<AttachmentResponseEntity> getCRAttachment({int? params});

  Future<bool> saveAttachment({required CrAttachmentRequest params});
  Future<dynamic> saveShopDetails({required SaveShopDetailsRequest params});

  Future<CalculateFeesResponseModel> crCalculateFees(
      {required CrCalculateFeesRequest params});
  Future<int> addBeneficiaryNotes({required CrAddNotesRequest params});

  Future<ResponseBodyModel<CrSubmitResponseModel>> submitCr(
      {required CrSubmitRequest params});

  Future<CleanOptionResponseEntity> getCleanOptions({required int params});
  Future<List<String>>? getDeedOptions({required int params});

  Future<CredenceResponseModel>? getRequestCredences({required int params});

  Future<bool>? uploadCredence({required CrAttachmentRequest params});

  Future<bool>? validateApprovals({required int params});

  Future<int>? validateSalamaAttachments(
      {required ValidateSalamaAttachmentsRequest params});

  Future<bool>? fawrySalamaReports({required int params});
  Future<bool>? fawrySalamaBills({required int params});

  Future<AdditionalActivityResponseModel> getAddetionalActivites(
      {final String subActivityId});

  Future<AddetionalActivityDetailsResponse> getAddetionalDetailsActivites(
      {final AddetionalActivityDetailsRequest params});

  Future<BoardContractResponseModel> getBoardContracts({required int params});

// ! QR Flow
  Future<SubmitCommercialResponseModel>? applyCommercialRequest(
      {required int params});
  Future<QrDetails>? getQrCodeDetails({required int params});

  Future<int>? saveQrEnterpriseData({required SaveEnterprisDataRequestModel params});

  Future<int>? saveQrWorkTimesData({required SaveWorkTimesRequestModel params});

  Future<int>? saveAddetionalQrData({required AdditionalQrDataRequestModel params});

  Future<AttachmentResponseEntity>? getQrAttachments({required int params});

  Future<bool> uploadQrAttachment({required CrAttachmentRequest params});

  Future<QrSubmitResponse> qrSubmit({required int params});

  Future<QrLookUpResponseModel> getQrLookUp({required String params});

  Future<QrLookUpResponseModel> getMalls({required String params});

  Future<dynamic> validateSalamaReport({required VerifySalamaRequest params});
  Future<dynamic> validateSalamaBill({required VerifySalamaRequest params});
  Future<dynamic> validateSalamaPermit({required VerifySalamaRequest params});

  Future<String> getWarningMessage({required SalamaWarningRequest params});
  Future<String> getWarningWorkFlowMessage(
      {required SalamaWarningRequest params});

  Future<CitizenInfo> getCizenInfo({required CitizenInfoParams params});

  Future<CommercialRequestDetailsResponseEntity> getRequestDetails(
      {required int params});

  Future<IssueCommercialConculsionEntity> getCommercialConculsion(
      {required int params});
}

class RemoteDataSourceImpl extends RemoteDataSource {
  final WebService webService;

  RemoteDataSourceImpl({required this.webService});

  @override
  Future<List<LookupsModel>> getAccommodationTypes() async {
    var response;


    try {
      response = await webService.dio.get(CommercialModelEndPoints.InitialApprovalAccommodationTypes);

      var data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LookupsModel>(
              (e) => LookupsModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool> addIsicActivities(
      {required AddIsicActivitiesParams params}) async {
    var response;

    try {
      response = await webService.dio.post(CommercialModelEndPoints.addIsicActivities,
          data: params.toJson(),
          options: Options(
            headers: {"sid": ""},
          ));
      print("FHH");

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: true);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ResponseBodyModel<RecordInfoModel>> getRecordInfo(
      {required String crNumber, required String role}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.recordInfo(crNumber: crNumber, role: role),
      );

      var data = response.data["data"]["result"];

      var parsedResult = data != null ? RecordInfoModel.fromJson(data) : null;
      final decodedResponse = ResponseBodyModel<RecordInfoModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<RecordInfoModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<SubActivityModel>> getSubActivities(int requestID, int isicCode) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.InitialApprovalSubActivities(requestID, isicCode),
      );

      var data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<SubActivityModel>(
              (e) => SubActivityModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }


  @override
  Future<List<IsicsMainActivity>> getMainActivities(int requestID) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.InitialApprovalMainActivities(requestID),
      );

      var data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<IsicsMainActivity>(
              (e) => IsicsMainActivity.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }




  @override
  Future<ResponseBodyModel<SubActivityDetailsData>> getSubActivityDetails(
      {required String subActivityId}) async {
    var response;

    try {
      response =
          await webService.dio.get(CommercialModelEndPoints.InitialApprovalsubActivityDetails(subActivityId));

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? SubActivityDetailsData.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<SubActivityDetailsData>.fromMap(response.data,
              parsedResult: parsedResult);

      print(decodedResponse);
      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<SubActivityModelDetailsModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<int> saveComSubmitterAndOwner(
      {SubmitterAndOwnerRequestModel? params}) async {
    var response;

    try {

      response = await webService.dio.post(CommercialModelEndPoints.commercialInitialApprovalApply,
          data: params?.toMap());

      var data = response.data["data"]?["result"];

      return data;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<SubActivityModelDetailsModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }




  @override
  Future<int> saveActivityDetails({SubmitActivityDetailRequest? params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.saveActivityDetails(params!.requestId!),
          data: params.toMap());

      var data = response.data["data"]?["result"];

      return data["requestId"];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<SaveLocationResponseModel> saveLocationDetails(
      {SaveLocationDataRequest? params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.saveLocationDetails(params!.requestId!),
          data: params?.toMap());

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? SaveLocationResponseModel.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<SaveLocationResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      print(decodedResponse);
      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<SaveLocationResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<CleanContractsResponseEntity> getCleanContracts(
      {CleanContractsRequest? params}) async {
    var response;

    try {
      response = await webService.dio
          .get(CommercialModelEndPoints.cleanContracts(params!.requestId), data: params.toMap());

      var data = response.data["data"];

      var parsedResult =
          data != null ? CleanContractsResponseEntity.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<CleanContractsResponseEntity>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CleanContractsResponseEntity>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<DeedInfoResponseModel> getDeedInfo({DeedInfoRequest? params}) async {
    var response;

    try {
      response = await webService.dio.get(
          CommercialModelEndPoints.deedInfoOwnwerShip(
              requestId: params!.requestId, type: params.ownershipType!),
          options: Options(headers: {"deedNumber": params.deedNumber}));

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? DeedInfoResponseModel.fromJson(data) : null;
      final decodedResponse = ResponseBodyModel<DeedInfoResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<DeedInfoResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<EjarInfoResponseModel> getEjarInfo({EjarInfoRequest? params}) async {
    var response;

    try {
      response =
          await webService.dio.post(CommercialModelEndPoints.ejarInfo, data: params?.toMap());

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? EjarInfoResponseModel.fromJson(data) : null;
      final decodedResponse = ResponseBodyModel<EjarInfoResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<EjarInfoResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<InvestmentContractResponseModel> getInvestmentContracts(
      {InvestmentContractRequest? params}) async {
    var response;

    try {
      response = await webService.dio.get(
          CommercialModelEndPoints.investmentContracts(params!.requestId),
          data: params.toMap());

      var data = response.data["data"];

      var parsedResult =
          data != null ? InvestmentContractResponseModel.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<InvestmentContractResponseModel>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<InvestmentContractResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<AttachmentResponseEntity> getCRAttachment({int? params}) async {
    var response;

    try {
      response = await webService.dio.get(CommercialModelEndPoints.crIssueAttachments(params!));

      var data = response.data["data"];

      var parsedResult =
          data != null ? AttachmentResponseEntity.fromMap(data) : null;
      final decodedResponse =
          ResponseBodyModel<AttachmentResponseEntity>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<AttachmentResponseEntity>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool> saveAttachment({required CrAttachmentRequest params}) async {
    final mimeType = lookupMimeType(params.data?.filePath ?? "");

    final body = await locator<web.PegaWebService>().uploadFileSSO(
      CommercialModelEndPoints.crAttachment(params.requestId!, params.data!.id!),
      base64: base64Decode(params.data?.base64 ?? ""),
      fileName: params.data?.fileName,
      mimeType: mimeType,
    );
    ;
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      if (state == true) {
        return true;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: data,
          ),
        );
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(
        "errors_server_error_2".tr(),
        exception: APIException(
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<CalculateFeesResponseModel> crCalculateFees(
      {required CrCalculateFeesRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.crCalculateFess(
            params.requestId!,
          ),
          data: params.toMap());

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? CalculateFeesResponseModel.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<CalculateFeesResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CalculateFeesResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<int> addBeneficiaryNotes({required CrAddNotesRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.addBeneficiaryNotes(
            params.requestId!,
          ),
          data: params.toMap());

      final decodedResponse =
          ResponseBodyModel<int>.fromMap(response.data, parsedResult: null);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CalculateFeesResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ResponseBodyModel<CrSubmitResponseModel>> submitCr(
      {required CrSubmitRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.crSubmit(
            params.requestId!,
          ),
          data: params.toMap());

      var data = response.data["data"]["result"];
      var parsedResult =
          data != null ? CrSubmitResponseModel.fromJson(data) : null;

      final decodedResponse = ResponseBodyModel<CrSubmitResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CalculateFeesResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future saveShopDetails({required SaveShopDetailsRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.saveShopDetails(
            params.requestId!,
          ),
          data: params.toMap());

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: null);

      return null;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<CleanOptionResponseEntity> getCleanOptions(
      {required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.cleanOptions(
          params,
        ),
      );

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? CleanOptionResponseEntity.fromMap(data) : null;
      final decodedResponse =
          ResponseBodyModel<CleanOptionResponseEntity>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CleanOptionResponseEntity>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<String>>? getDeedOptions({required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.deedOptions(
          params,
        ),
      );

      List<String> data = response.data["data"]["result"].cast<String>();

      final decodedResponse = ResponseBodyModel<List<String>>.fromMap(
          response.data,
          parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<List<String>>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<CredenceResponseModel>? getRequestCredences({required int params}) async {
    var response;

    try {
      response = await webService.dio.get(CommercialModelEndPoints.getCredences(params));

      var data = response.data["data"]["result"];

      var parsedResult = data != null ? CredenceResponseModel.fromJson(data) : null;
      final decodedResponse = ResponseBodyModel<CredenceResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<CredenceResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool>? uploadCredence({required CrAttachmentRequest params}) async {
    final mimeType = lookupMimeType(params.data?.filePath ?? "");

    final body = await locator<web.PegaWebService>().uploadFileSSO(
      CommercialModelEndPoints.uploadCredences(params.requestId!, params.data!.id),
      base64: base64Decode(params.data?.base64 ?? ""),
      fileName: params.data?.fileName,
      mimeType: mimeType,
    );
    ;
    print(CommercialModelEndPoints.uploadCredences(params.requestId!, params.data!.id));
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      if (state == true) {
        return true;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: data,
          ),
        );
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(
        "errors_server_error_2".tr(),
        exception: APIException(
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<bool>? validateApprovals({required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.validateApprovals(
          params,
        ),
      );

      var data = response.data["data"]["result"];

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<bool>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<int>? validateSalamaAttachments(
      {required ValidateSalamaAttachmentsRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
        CommercialModelEndPoints.validateSalamaAttachmentsInfo(
          params.requestId!,
        ),
        data: params.toMap(),
      );

      var data = response.data["data"]["result"];

      final decodedResponse =
          ResponseBodyModel<int>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<bool>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool>? fawrySalamaBills({required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.fawrySalamaBills(
          params,
        ),
      );

      var data = response.data["data"]["result"]["IsFawry"];

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<bool>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool>? fawrySalamaReports({required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.fawrySalamaReports(
          params,
        ),
      );

      var data = response.data["data"]["result"]["IsFawry"];

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<bool>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<SubmitCommercialResponseModel>? applyCommercialRequest(
      {required int params}) async {
    var response;

    try {
      response = await webService.dio.post(
        CommercialModelEndPoints.applyCommercialRequest(
          params,
        ),
      );

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? SubmitCommercialResponseModel.fromJson(data) : null;

      final decodedResponse =
          ResponseBodyModel<SubmitCommercialResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<SubmitCommercialResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<QrDetails>? getQrCodeDetails({required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.getQrCodeDetails(
          params,
        ),
      );

      var data = response.data["data"]["result"];

      var parsedResult = data != null ? QrDetails.fromJson(data) : null;

      final decodedResponse = ResponseBodyModel<QrDetails>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<QrDetails>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<int>? saveQrEnterpriseData(
      {required SaveEnterprisDataRequestModel params}) async {
    // TODO: implement saveQrEnterpriseData
    //{{baseURL}}/

    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.saveQrEnterpriseData(
            params.requestId!,
          ),
          data: params.toJson());

      var data = response.data["data"]["result"];

      final decodedResponse =
          ResponseBodyModel<int>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<int>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<int>? saveQrWorkTimesData(
      {required SaveWorkTimesRequestModel params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.saveQrWorkTimesData(
            params.requestId!,
          ),
          data: params.toJson());

      var data = response.data["data"]["result"];

      final decodedResponse =
          ResponseBodyModel<int>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<int>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<int>? saveAddetionalQrData(
      {required AdditionalQrDataRequestModel params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.saveAddetionalQrData(
            params.requestId!,
          ),
          data: params.toJson());

      var data = response.data["data"]["result"];

      final decodedResponse =
          ResponseBodyModel<int>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<int>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<AttachmentResponseEntity>? getQrAttachments(
      {required int params}) async {
    var response;

    try {
      response = await webService.dio.get(CommercialModelEndPoints.qrAttachments(params!));

      var data = response.data["data"];

      var parsedResult =
          data != null ? AttachmentResponseEntity.fromMap(data) : null;
      final decodedResponse =
          ResponseBodyModel<AttachmentResponseEntity>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<AttachmentResponseEntity>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool> uploadQrAttachment({required CrAttachmentRequest params}) async {
    final mimeType = lookupMimeType(params.data?.filePath ?? "");

    final body = await locator<web.PegaWebService>().uploadFileSSO(
      CommercialModelEndPoints.qrUploadAttachments(params.requestId!, params.data!.id!),
      base64: base64Decode(params.data?.base64 ?? ""),
      fileName: params.data?.fileName,
      mimeType: mimeType,
    );
    ;
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      if (state == true) {
        return true;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: data,
          ),
        );
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(
        "errors_server_error_2".tr(),
        exception: APIException(
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<QrSubmitResponse> qrSubmit({required int params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.qrSubmit(
            params!,
          ),
          data: params.toJson());

      var data = response.data["data"]["result"];

      var parsedResult = data != null ? QrSubmitResponse.fromJson(data) : null;

      final decodedResponse = ResponseBodyModel<QrSubmitResponse>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<QrSubmitResponse>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<QrLookUpResponseModel> getQrLookUp({required String params}) async {
    var response;

    try {
      response = await webService.dio.get(
          CommercialModelEndPoints.qrLookUp(
            params,
          ),
          data: params.toJson());

      var data = response.data["data"];

      var parsedResult = data != null ? QrLookUpResponseModel.fromJson(data) : null;

      final decodedResponse = ResponseBodyModel<QrLookUpResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<QrLookUpResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<AdditionalActivityResponseModel> getAddetionalActivites(
      {String? subActivityId}) async {
    var response;

    try {
      response = await webService.dio.get(CommercialModelEndPoints.addetionalActivites(
        subActivityId!,
      ));

      var data = response.data["data"];

      var parsedResult =
          data != null ? AdditionalActivityResponseModel.fromJson(data) : null;

      final decodedResponse =
          ResponseBodyModel<AdditionalActivityResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<AdditionalActivityResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<AddetionalActivityDetailsResponse> getAddetionalDetailsActivites(
      {AddetionalActivityDetailsRequest? params}) async {
    var response;

    try {
      response = await webService.dio.get(CommercialModelEndPoints.InitialApprovalAddetionalDetailsActivity(
        params!.subActivityId,
        params.addetionalActivityId,
      ));

      var data = response.data["data"];

      var parsedResult = data != null
          ? AddetionalActivityDetailsResponse.fromJson(data)
          : null;

      final decodedResponse =
          ResponseBodyModel<AddetionalActivityDetailsResponse>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<AddetionalActivityDetailsResponse>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<QrLookUpResponseModel> getMalls({required String params}) async {
    var response;

    try {
      response = await webService.dio.get(
          CommercialModelEndPoints.mallsList(
            params,
          ),
          data: params.toJson());

      var data = response.data["data"];

      var parsedResult = data != null ? QrLookUpResponseModel.fromJson(data) : null;

      final decodedResponse = ResponseBodyModel<QrLookUpResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<QrLookUpResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<dynamic> validateSalamaBill(
      {required VerifySalamaRequest params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.validateSalamaBill(params.requestId, params.number),
      );

      var data = response.data["data"]["result"];

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<dynamic> validateSalamaPermit(
      {required VerifySalamaRequest params}) async {
    var response;

    try {
      response = await webService.dio.get(
          CommercialModelEndPoints.validateSalamaPermit(
            params.requestId,
          ),
          options: Options(headers: {"salamaPermitNumber": params.number}));

      var data = response.data["data"]["result"];

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<dynamic> validateSalamaReport(
      {required VerifySalamaRequest params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.validateSalamaReport(params.requestId, params.number),
      );

      var data = response.data["data"]["result"];

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<String> getWarningMessage(
      {required SalamaWarningRequest params}) async {
    var response;

    try {
      response = await webService.dio
          .post(CommercialModelEndPoints.salamaWarningMessage, data: params.toJson());

      var data = response.data["data"]["result"] != null
          ? (response.data["data"]["result"]?["message"] ?? "")
          : "";

      final decodedResponse =
          ResponseBodyModel<String>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<bool>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<String> getWarningWorkFlowMessage(
      {required SalamaWarningRequest params}) async {
    var response;

    try {
      response = await webService.dio
          .post(CommercialModelEndPoints.salamaWarningWorkFlowMessage, data: params.toJson());

      var data = response.data["data"]["result"] != null
          ? response.data["data"]["result"][0]["workflowName"]
          : "";

      final decodedResponse =
          ResponseBodyModel<String>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<bool>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<BoardContractResponseModel> getBoardContracts({required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.boardContracts(params),
      );

      var data = response.data["data"];

      var parsedResult =
          data != null ? BoardContractResponseModel.fromJson(data) : null;

      final decodedResponse = ResponseBodyModel<BoardContractResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<BoardContractResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<CitizenInfo> getCizenInfo(
      {required CitizenInfoParams params}) async {
    var response;

    try {
      response = await webService.dio
          .get(CommercialModelEndPoints.crCitizenInfo, queryParameters: params.toMap());

      var data = response.data["data"]["result"];

      var parsedResult = data != null ? CitizenInfo.fromJson(data) : null;

      final decodedResponse = ResponseBodyModel<CitizenInfo>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<CitizenInfo>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<CommercialRequestDetailsResponseEntity> getRequestDetails(
      {required int params}) async {
    var response;

    try {
      response =
          await webService.dio.get(CommercialModelEndPoints.requestDetailsCommercial(params));

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? CommercialRequestDetailsResponseEntity.fromJson(data) : null;

      final decodedResponse =
          ResponseBodyModel<CommercialRequestDetailsResponseEntity>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CommercialRequestDetailsResponseEntity>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<IssueCommercialConculsionEntity> getCommercialConculsion(
      {required int params}) async {
    var response;

    try {
      response =
          await webService.dio.get(CommercialModelEndPoints.requestConclusionCommercial(params));

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? IssueCommercialConculsionEntity.fromJson(data) : null;

      final decodedResponse =
          ResponseBodyModel<IssueCommercialConculsionEntity>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<IssueCommercialConculsionEntity>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}

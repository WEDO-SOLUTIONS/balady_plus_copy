
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../models/initialApproval/conclusion_response_entity.dart';
import '../models/initialApproval/save_activity_and_location_response_model.dart';
import '../models/initialApproval/submit_request_response_model.dart';
import '../models/initialApproval/fees_request.dart';
import '../models/initialApproval/isics_main_activity.dart';
import '../models/initialApproval/request_details_model.dart';
import '../models/initialApproval/save_com_submitter_and_owner_request_model.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../models/initialApproval/sub_activity_details_data.dart';

abstract class RemoteDataSource {
  Future<ResponseBodyModel<RequestDetailsModel>> getInitialApprovalRequestDetails( int requestId) ;
  Future<List<SubActivityModel>> getSubActivities(int requestID, int isicCode) ;
  Future<List<IsicsMainActivity>> getMainActivities(int requestID);
  Future<ResponseBodyModel<SubActivityDetailsData>> getSubActivityDetails(
      {required String subActivityId});
  Future<bool> addIsicActivities({required AddIsicActivityData params});
  Future<List<LookupsModel>> getAccommodationTypes();

  Future<int> saveComSubmitterAndOwner(
      {SubmitterAndOwnerRequestModel? params});

  Future<int> applyLicenseExport(int params);

  Future<ResponseBodyModel<SaveActivityAndLocationResponseModel>> saveActivityDetails({SubmitActivityDetailRequest? params});

  Future<SaveLocationResponseModel> saveLocationDetails(
      {SaveLocationDataRequest? params});

  Future<CalculateFeesResponseModel> crCalculateFees(
      {required CrCalculateFeesRequest params});
  Future<CalculateFeesResponseModel> CalculateFeesInteractively(
      {required FeesRequest params});

  Future<SubmitRequestResponseModel> submitInitialApproval(int requestId);

  Future<IssueCommercialConculsionEntity> getCommercialConculsion(
      {required int params});

  Future<bool> cancelIntialApproval({required int requestId});
  Future<String> getSPLNotification({required String requestId,required String mencipiltyId});
  Future<bool> ReplyWithNotes( String requestId, String note,String noteId);
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
      {required AddIsicActivityData params}) async {
    var response;

    try {
      response = await webService.dio.post(CommercialModelEndPoints.InitialApprovalAddIsicActivities(params.requestId!),
          data: params.toJson(),
          options: Options(
            headers: {"sid": ""},
          ));


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
  Future<ResponseBodyModel<RequestDetailsModel>> getInitialApprovalRequestDetails( int requestId) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.InitialApprovalRequestDetails(requestId),
      );

      var data = response.data["data"]["result"];

      var parsedResult = data != null ? RequestDetailsModel.fromJson(data) : null;
      final decodedResponse = ResponseBodyModel<RequestDetailsModel>.fromMap(
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
      // "DioError $error".errorLog();
      // if (error is NoDataFoundException) {
      //   rethrow;
      // }
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
  Future<int> applyLicenseExport(int params) async {
    var response;

    try {

      response = await webService.dio.post(CommercialModelEndPoints.applyLicenseExport(params),
      data: {"submitterType":CommonProperties.getCurrentUserProfile()?.getRole() ??"",});
      var data = response.data["data"]?["result"]["requestNumber"];


      return data;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );

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
  Future<ResponseBodyModel<SaveActivityAndLocationResponseModel>> saveActivityDetails({SubmitActivityDetailRequest? params}) async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.InitialApprovalSaveActivityAndSites(params!.requestId!),
          data: params.toJson());

      var data = response.data["data"]?["result"];



      var parsedResult =
      data != null ? SaveActivityAndLocationResponseModel.fromJson(data) : null;
      final decodedResponse =
      ResponseBodyModel<SaveActivityAndLocationResponseModel>.fromMap(response.data,
          parsedResult: parsedResult);


      return decodedResponse.toFuture();


     // return data["requestId"];
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

  Future<CalculateFeesResponseModel> CalculateFeesInteractively(
      {required FeesRequest params})async {
    var response;

    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.InitialApprovalCalculateFessInteractively(
            params.requestId!,
          ),
          data: params.toJson());

      var data = response.data["data"]["result"]["calculatorResponseBody"];

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
  Future<SubmitRequestResponseModel> submitInitialApproval(int requestId) async {
    var response;

    try {
      response = await webService.dio.post(CommercialModelEndPoints.InitialApprovalSubmit(requestId));

      var data = response.data["data"];

      var parsedResult =
          data != null ? SubmitRequestResponseModel.fromJson(data["result"]) : null;

      final decodedResponse =
          ResponseBodyModel<SubmitRequestResponseModel>.fromMap(response.data,
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
      response = await webService.dio.get(CommercialModelEndPoints.intialApprovalConclusion(params));

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



  @override
  Future<bool> cancelIntialApproval({required int requestId}) async {
    var response;

    try {
      response = await webService.dio.delete(CommercialModelEndPoints.cancelIntialApproval(requestId),);


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
  Future<String> getSPLNotification({required String requestId,required String mencipiltyId}) async {
    var response;

    try {
      response = await webService.dio.get(CommercialModelEndPoints.getSPLNotifcation,
          queryParameters: {
            "requestTypeId":requestId,
            "guid":mencipiltyId
          }

      );

      var data = response.data["data"]["result"];
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
  Future<bool> ReplyWithNotes( String requestId,  String note, String noteId) async {
    var response;

    try {
      response = await webService.dio.post(CommercialModelEndPoints.replyWithNote(requestId),
      data: {
        "noteId":noteId,
        "replyText":note
      }
      );


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


}

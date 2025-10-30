import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:dio/dio.dart' show DioError, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart'
    show APIException, NoDataFoundException, ServerException;
import '../../../../../core/services/global/crm_web_service.dart';
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart'
    show ApiUrl, CommonProperties, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../../../transaction_inquiry/presentation/core/models/download_file_result.dart';
import '../../domain/entities/download_file_params.dart';
import '../../domain/entities/reply_retrive_car_params.dart';
import '../../domain/entities/reply_retrive_car_response.dart';
import '../models/request_details_response.dart';
import '../models/request_details_response_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class RequestsRemoteDataSource {
  Future<RequestDetailsResponse> getCRMIncidentRequestDetails(
    String params,
  );

  Future<RequestDetailsResponse> getCRMREQRequestDetails(
    String params,
  );

  Future<RequestDetailsResponse> getCRMINQRequestDetails(
    String params,
  );

  Future<CrmRequestDetailsModel> getRequestDetails({required String params});

  Future<DownloadFileResult?> downloadFile(
      {required DownLoadFileParams params});

  Future<ReplyRetriveCarResponse> replyRetriveCar(
      {required ReplyRetriveCarParams params});
}

class RequestsRemoteDataSourceImplementation
    implements RequestsRemoteDataSource {
  final WebService webService;
  // final CRMWebService crmWebService;

  RequestsRemoteDataSourceImplementation({
    required this.webService,
    // required this.crmWebService,
  });

  @override
  Future<RequestDetailsResponse> getCRMIncidentRequestDetails(
      String params) async {
    var response;
    try {
      Map<String, dynamic> queryParms = {};
      if (CommonProperties.userInfo?.idNo != null) {
        queryParms = {
          if (CommonProperties.userInfo!.idNo!.startsWith("1"))
            "NationalID": "${CommonProperties.userInfo!.idNo}"
          else
            "IqamaID": "${CommonProperties.userInfo!.idNo}",
          "pzInsKey": params
        };
      }

      response = await webService.dio
          .get(ApiUrl.IncidentRequestDetails, queryParameters: queryParms);

      final result =
          RequestDetailsResponse.fromJson(response.data["data"]["result"]);

      return result;
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
  Future<RequestDetailsResponse> getCRMINQRequestDetails(String params) async {
    var response;
    try {
      Map<String, dynamic> queryParms = {};
      if (CommonProperties.userInfo?.idNo != null) {
        queryParms = {
          if (CommonProperties.userInfo!.idNo!.startsWith("1"))
            "NationalID": "${CommonProperties.userInfo!.idNo}"
          else
            "IqamaID": "${CommonProperties.userInfo!.idNo}",
          "pzInsKey": params
        };
      }

      response = await webService.dio
          .get(ApiUrl.FetchInquiryRequest, queryParameters: queryParms);

      final data = response.data;
      data.toString().successLog();

      final result =
          RequestDetailsResponse.fromJson(response.data["data"]["result"]);

      return result;
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
  Future<RequestDetailsResponse> getCRMREQRequestDetails(String params) async {
    var response;
    try {
      Map<String, dynamic> queryParms = {};
      if (CommonProperties.userInfo?.idNo != null) {
        queryParms = {
          if (CommonProperties.userInfo!.idNo!.startsWith("1"))
            "NationalID": "${CommonProperties.userInfo!.idNo}"
          else
            "IqamaID": "${CommonProperties.userInfo!.idNo}",
          "pzInsKey": params
        };
      }
      response = await webService.dio
          .get(ApiUrl.FetchMuncipalServiceRequest, queryParameters: queryParms);

      // fawzi change api tp apigee

      final result = RequestDetailsResponse.fromJson(
          response.data["data"]["result"],
          type: RequestsType.REQ);

      return result;
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
  Future<CrmRequestDetailsModel> getRequestDetails(
      {required String params}) async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.requestDetails,
          queryParameters: {"IncidentID": params},
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return CrmRequestDetailsModel.fromJson(result);
      return result;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      var errorCode;

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
          //  CommonFunctions.sendExceptionLog(exception:  error, response: response);
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
  Future<DownloadFileResult?> downloadFile(
      {required DownLoadFileParams params}) async {
    var response;

    try {
      Map<String, dynamic> queryParms = {};
      if (CommonProperties.userInfo?.idNo != null) {
        queryParms = {
          if (CommonProperties.userInfo!.idNo!.startsWith("1"))
            "NationalID": "${CommonProperties.userInfo!.idNo}"
          else
            "IqamaID": "${CommonProperties.userInfo!.idNo}",
          "FileKey": params.fileKey,
          if (params.daemId != null && params.daemId!.isNotEmpty)
            "DaemID": params.daemId
        };
      }

      response = await webService.dio
          .get(ApiUrl.IncidentDownloadFile, queryParameters: queryParms);

      final result =
          DownloadFileResult.fromJson(response.data['data']['result']);
      return result;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      var errorCode;

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
          //  CommonFunctions.sendExceptionLog(exception:  error, response: response);
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
  Future<ReplyRetriveCarResponse> replyRetriveCar(
      {required ReplyRetriveCarParams params}) async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.veichleRecoveryNotes,
          data: params.toMap(),
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      final data = response.data;
      data.toString().successLog();

      //   final result = ResponseBodyModel.fromMap(data).data?.result;

      return ReplyRetriveCarResponse();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      var errorCode;

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
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
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
}

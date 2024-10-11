import 'dart:convert';

import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/extensions/log.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import 'package:balady_plus/app/core/remote_services/pega_web_service.dart' as web;

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import '../models/allowed_actions_response.dart';
import '../models/calculate_cost_response_model.dart';
import '../models/permit_submit_response_model.dart';
import '../models/permit_request_details_model.dart';
import '../models/permits_alerts_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';

abstract class Permits24RemoteDataSource {
  Future<Permit24AllowedAction> getPermitAllowedActions({required int params});

  Future<PermitAlertsResponse> getPermitsAlerts(String type);
  Future<bool> validateBeforeApply({required int params});

  Future<PermitSubmitResponseModel> submit({required int params});

  Future<Permit24RequestDetailsModel> getPermitRequestDetails(
      {required int params});

  Future<CalculateCost24PermitResponse> calculatePermit24HourCost(
      {required int params});

  Future<bool> deletePermitRequest({required int requestId});
}

class Permits24RemoteDataSourceImpl implements Permits24RemoteDataSource {
  final WebService webService;

  Permits24RemoteDataSourceImpl({required this.webService});

  @override
  Future<PermitSubmitResponseModel> submit({required int params}) async {
    var response;
    try {
      response = await webService.dio.post(
        CommercialModelEndPoints.permit24Submit(params),
      );

      final data = response.data;
      data.toString().successLog();

      return PermitSubmitResponseModel.fromJson(data["data"]["result"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
  Future<bool> deletePermitRequest({required int requestId}) async {
    var response;
    try {
      response = await webService.dio.delete(
        CommercialModelEndPoints.deletePermit24Request(requestId),
      );

      final data = response.data;
      data.toString().successLog();

      return data["data"]["result"] as bool;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
  Future<PermitAlertsResponse> getPermitsAlerts(String type) async {
    var response;
    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.permits24Alerts(type),
      );

      final data = response.data;
      data.toString().successLog();

      return PermitAlertsResponse.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
  Future<Permit24AllowedAction> getPermitAllowedActions(
      {required int params}) async {
    var response;
    try {
      response =
          await webService.dio.get(CommercialModelEndPoints.permit24AlllowedAction(params));

      final data = response.data;
      data.toString().successLog();

      return Permit24AllowedAction.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
  Future<bool> validateBeforeApply({required int params}) async {
    var response;
    try {
      response =
          await webService.dio.get(CommercialModelEndPoints.permit24ValidateBeforeApply(params));

      final data = response.data;
      data.toString().successLog();

      return data["data"]["result"];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
  Future<Permit24RequestDetailsModel> getPermitRequestDetails(
      {required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.permit24RequestDetails(params),
      );

      final data = response.data;
      data.toString().successLog();

      return Permit24RequestDetailsModel.fromJson(data["data"]?["result"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      "DioError $error".errorLog();

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
      ;
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
  Future<CalculateCost24PermitResponse> calculatePermit24HourCost(
      {required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.permit24Calclaute(params),
      );

      final data = response.data;
      data.toString().successLog();

      return CalculateCost24PermitResponse.fromJson(data["data"]?["result"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      "DioError $error".errorLog();

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
      ;
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
}

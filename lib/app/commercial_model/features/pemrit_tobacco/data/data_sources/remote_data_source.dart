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
import '../../domain/entities/permit_tobacco_caclualte_request.dart';
import '../../domain/entities/submit_tobacco_request.dart';
import '../../domain/entities/validate_hotel_license_request.dart';
import '../models/allowed_actions_response.dart';
import '../models/calculate_cost_response_model.dart';
import '../models/permit_submit_response_model.dart';
import '../models/permit_request_details_model.dart';
import '../models/permits_alerts_response.dart';
import '../models/validate_hotel_license.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';

abstract class PermitsTobaccoRemoteDataSource {
  Future<PermitTobaccoAllowedAction> getPermitAllowedActions(
      {required int params});

  Future<PermitTobaccoAlertsResponse> getPermitsAlerts();
  Future<bool> validateBeforeApply({required int params});

  Future<PermitTobaccoSubmitResponseModel> submit(
      {required SubmitTobaccoRequest params});

  Future<PermitTobaccoRequestDetailsModel> getPermitRequestDetails(
      {required int params});

  Future<CalculateCostPermitTobaccoResponse> calculatePermit24HourCost(
      {required PermitTobaccoCalculateRequest params});

  Future<bool> deletePermitRequest({required int requestId});

  Future<PermitTobaccoValidateHotelLicense> validateHotelLicense(
      {required ValidateHotelLicenseRequest params});
}

class PermitsTobaccoRemoteDataSourceImpl
    implements PermitsTobaccoRemoteDataSource {
  final WebService webService;

  PermitsTobaccoRemoteDataSourceImpl({required this.webService});

  @override
  Future<PermitTobaccoSubmitResponseModel> submit(
      {required SubmitTobaccoRequest params}) async {
    var response;
    try {
      response = await webService.dio.post(
          CommercialModelEndPoints.permitTobaccoSubmit(params.licenseNumber),
          queryParameters: {
            if (params.requestId != null) "requestId": params.requestId
          },
          data: {
            "insideHotel": params.insideHotel,
            if (params.hotelLicenseNumber != null)
              "hotelLicenseNumber": params.hotelLicenseNumber,
          });

      final data = response.data;
      data.toString().successLog();

      return PermitTobaccoSubmitResponseModel.fromJson(data["data"]["result"]);
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
        CommercialModelEndPoints.deletePermitTobaccoRequest(requestId),
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
  Future<PermitTobaccoAlertsResponse> getPermitsAlerts() async {
    var response;
    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.permitsTobaccoAlerts,
      );

      final data = response.data;
      data.toString().successLog();

      return PermitTobaccoAlertsResponse.fromJson(data["data"]);
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
  Future<PermitTobaccoAllowedAction> getPermitAllowedActions(
      {required int params}) async {
    var response;
    try {
      response =
          await webService.dio.get(CommercialModelEndPoints.permitTobaccoAlllowedAction(params));

      final data = response.data;
      data.toString().successLog();

      return PermitTobaccoAllowedAction.fromJson(data["data"]);
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
      response = await webService.dio
          .get(CommercialModelEndPoints.permitTobaccoValidateBeforeApply(params));

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
  Future<PermitTobaccoRequestDetailsModel> getPermitRequestDetails(
      {required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.permitTobaccoRequestDetails(params),
      );

      final data = response.data;
      data.toString().successLog();

      return PermitTobaccoRequestDetailsModel.fromJson(data["data"]?["result"]);
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
  Future<CalculateCostPermitTobaccoResponse> calculatePermit24HourCost(
      {required PermitTobaccoCalculateRequest params}) async {
    var response;

    try {
      response = await webService.dio.get(
          CommercialModelEndPoints.permitTobaccoCalclaute(params.licenseNumber),
          queryParameters: {
            "insideHotel": params.insideHotel,
            if (params.hotelLicenseNumber != null)
              "hotelLicenseNumber": params.hotelLicenseNumber
          });

      final data = response.data;
      data.toString().successLog();

      return CalculateCostPermitTobaccoResponse.fromJson(
          data["data"]?["result"]);
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
  Future<PermitTobaccoValidateHotelLicense> validateHotelLicense(
      {required ValidateHotelLicenseRequest params}) async {
    var response;

    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.PermitTobaccoValidateHotelLicense(
            params.licenseNumber, params.hotelLicense),
      );

      final data = response.data;
      data.toString().successLog();

      return PermitTobaccoValidateHotelLicense.fromJson(
          data["data"]?["result"]);
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

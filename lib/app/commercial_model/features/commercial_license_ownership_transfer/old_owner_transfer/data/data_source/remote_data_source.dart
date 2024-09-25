import 'dart:convert';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/core/utils/extensions/json_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import '../../domain/entity/permits_response_entity.dart';
import '../../domain/entity/transfer_license_request.dart';
import '../model/apply_request_data_model.dart';
import '../model/permits_response_data_model.dart';
import '../model/validate_license_data_model.dart';
import '../model/validate_owner_data_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';

abstract class LicensePermitsRemoteDataSource {
  Future<ResponseBodyModel<PermitsResponseDataModel>> getLicensePermits(
      String licenseNumber);
  Future<ResponseBodyModel<ValidateOwnerDataModel>> validateNewOwner(
      String licenseNumber, String crNumber);

  Future<ResponseBodyModel<ValidateLicenseDataModel>> validateLicense(
      String licenseNumber);

  Future<ResponseBodyModel<ApplyRequestDataModel>> sendToNewOwner(
      String licenseNumber, TransferLicenseRequest request);
}

class LicensePermitsRemoteDataSourceImplementation
    implements LicensePermitsRemoteDataSource {
  final WebService webService;

  LicensePermitsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<ResponseBodyModel<PermitsResponseDataModel>> getLicensePermits(
      String licenseNumber) async {
    var response;
    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.getLicensePermits(licenseNumber),
      );
      final data = response.data;

      var parsedResult = data != null
          ? PermitsResponseDataModel.fromJson(data["data"]["result"])
          : null;
      final decodedResponse =
          ResponseBodyModel<PermitsResponseDataModel>.fromMap(data,
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
      // "Catched $error".errorLog();

      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<ValidateOwnerDataModel>> validateNewOwner(
      String licenseNumber, String crNumber) async {
    var response;
    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.validateNewOwner(licenseNumber, crNumber),
      );
      final data = response.data;

      var parsedResult =
          data != null ? ValidateOwnerDataModel.fromJson(data["data"]) : null;
      final decodedResponse = ResponseBodyModel<ValidateOwnerDataModel>.fromMap(
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
      // "Catched $error".errorLog();

      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<ValidateLicenseDataModel>> validateLicense(
      String licenseNumber) async {
    var response;
    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.validateLicenseTrnasfer(licenseNumber),
      );
      final data = response.data;

      var parsedResult =
          data != null ? ValidateLicenseDataModel.fromJson(data["data"]) : null;
      final decodedResponse =
          ResponseBodyModel<ValidateLicenseDataModel>.fromMap(response.data,
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
      // "Catched $error".errorLog();

      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<ApplyRequestDataModel>> sendToNewOwner(
      String licenseNumber, TransferLicenseRequest request) async {
    var response;
    try {
      response = await webService.dio
          .post(CommercialModelEndPoints.sendToNewOwner(licenseNumber), data: request.toJson());
      final data = response.data;

      var parsedResult =
          data != null ? ApplyRequestDataModel.fromJson(data["data"]) : null;
      final decodedResponse = ResponseBodyModel<ApplyRequestDataModel>.fromMap(
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
      // "Catched $error".errorLog();

      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }
}

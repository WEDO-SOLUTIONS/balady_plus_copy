import 'dart:convert';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/core/utils/extensions/json_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dio/dio.dart' show DioError, DioException, Response;
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../commercial_license/domain/entities/save_shop_details_request.dart';
import '../../domain/entities/save_selected_requests_permits_request.dart';
import '../../domain/entities/save_shop_info_request.dart';
import '../models/request_permits_model/permit.dart';
import '../models/request_permits_model/request_permits_model.dart';

abstract class RequestPermitsRemoteDataSource {
  Future<RequestPermitsModel> getRequestPermits(int requestNumber);

  Future<bool> saveSelectedRequestsPermits(int requestNumber,
      SaveSelectedRequestsPermitsRequest params);

  Future<bool> saveShopInfo(int requestNumber , SaveShopInfoRequest params);
  Future saveShopDetails({required SaveShopDetailsRequest params});
}

class RequestPermitsRemoteDataSourceImplementation
    implements RequestPermitsRemoteDataSource {
  final WebService webService;

  RequestPermitsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<RequestPermitsModel> getRequestPermits(int requestNumber) async {
    Response? response;

    try {
      response =
          await webService.dio.get(ApiUrl.getRequestPermits(requestNumber));
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return RequestPermitsModel.fromJson(result);
    } on DioException catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<bool> saveSelectedRequestsPermits(
      int requestNumber,
      SaveSelectedRequestsPermitsRequest
          params) async {
    Response? response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveSelectedRequestPermits(requestNumber),
          data: params.toJson());
      final data = response.data;

      final statusCode = ResponseBodyModel.fromMap(data).statusDetails!.code;
      if (statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<bool> saveShopInfo(int requestNumber,SaveShopInfoRequest params) async {
    Response? response;

    try {
      response =
          await webService.dio.post(ApiUrl.transferShopInfo(requestNumber),
                    data: params.toJson());
      final data = response.data;

      final statusCode = ResponseBodyModel.fromMap(data).statusDetails!.code;
      if (statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future saveShopDetails({required SaveShopDetailsRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveShopDetails(
            params.requestId!,
          ),
          data: params.toMap());

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: null);

      return null;
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }
}

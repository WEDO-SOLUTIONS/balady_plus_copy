import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/api_url.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel;

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, WithDelay;
import 'package:balady_plus/etmam_app/features/otp/data/models/send_otp_response_model.dart';
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart'
    show SendOTPParamas, OTPVerifyParamas;

abstract class OTPRemoteDataSource {
  Future<ApigeeResponse<SendOTPResponseModel>> sendOTP(
      {required SendOTPParamas params});

  Future<ApigeeResponse> verifyOTP({required OTPVerifyParamas params});
}

class OTPRemoteDataSourceImpl extends OTPRemoteDataSource {
  final WebService webService;

  OTPRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<SendOTPResponseModel>> sendOTP(
      {required SendOTPParamas params}) async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.sendOTP,
          data: {
            "expireSeconds": params.expireSeconds,
            "serviceId": params.serviceId
          },
          options: Options(
            headers: {
              "Authorization": "Bearer " + (CommonProperties.token ?? ""),
              ApiHeaders.xFeappId: CommonProperties.appName,
              ApiHeaders.xFeDeviceId: CommonProperties.deviceId,
              ApiHeaders.xFeDeviceOs: CommonProperties.deviceOs,
              ApiHeaders.xCorrelationId: CommonFunctions.generateGUID(),
              ApiHeaders.xSessionId: CommonProperties.sessionId,
              "x-fe-client-ip": CommonProperties.clientIP,
              "x-fe-deployment-id": CommonProperties.appVersion,
              "Accept-Language": "ar",
              "x-fe-service-id": "submit",
              "Content-Type": "application/json",
            },
          ));

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? SendOTPResponseModel.fromMap(data) : null;
      final decodedResponse = ApigeeResponseModel<SendOTPResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);
      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            trans("errors_server_error_1");
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }
      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse> verifyOTP({required OTPVerifyParamas params}) async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.verifyOTP,
          data: {
            "otpId": params.otpId,
            "serviceId": params.serviceId,
            "token": params.token
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? ""),
            ApiHeaders.xFeappId: CommonProperties.appName,
            ApiHeaders.xFeDeviceId: CommonProperties.deviceId,
            ApiHeaders.xFeDeviceOs: CommonProperties.deviceOs,
            ApiHeaders.xCorrelationId: CommonFunctions.generateGUID(),
            ApiHeaders.xSessionId: CommonProperties.sessionId,
            "x-fe-client-ip": CommonProperties.clientIP,
            "x-fe-deployment-id": CommonProperties.appVersion,
            "Accept-Language": "ar",
            "x-fe-service-id": "submit",
            "Content-Type": "application/json",
          }));

      var data = response.data["data"]?["result"];

      final decodedResponse = ApigeeResponseModel.fromMap(response.data);

      /*if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            trans("errors_server_error_1");
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }*/
      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }
}

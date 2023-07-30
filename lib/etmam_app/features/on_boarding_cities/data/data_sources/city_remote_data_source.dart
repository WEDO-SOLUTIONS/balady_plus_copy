import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel, CityResponseModel;

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;

abstract class CityRemoteDataSource {
  Future<ApigeeResponse<CityResponseModel>> getCities();
}

class CityRemoteDataSourceImpl extends CityRemoteDataSource {
  final WebService webService;

  CityRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<CityResponseModel>> getCities() async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.cities,
        queryParameters: {
          ApiParams.page_No: 1,
          // ApiParams.page_Size: 100,
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult = data != null ? CityResponseModel.fromMap(data) : null;
      final decodedResponse = ApigeeResponseModel<CityResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);
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

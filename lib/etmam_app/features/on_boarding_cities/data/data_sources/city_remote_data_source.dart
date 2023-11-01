import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel, CityResponseModel;

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show APIException, ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../domain/entities/city_params.dart';

abstract class CityRemoteDataSource {
  Future<ApigeeResponse<CityResponseModel>> getCities(CityParams params);
}

class CityRemoteDataSourceImpl extends CityRemoteDataSource {
  final WebService webService;

  CityRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<CityResponseModel>> getCities(CityParams params) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.cities,
        queryParameters: params.toMap(),
      );

      var data = response.data["data"]?["result"];

      var parsedResult = data != null ? CityResponseModel.fromMap(data) : null;
      final decodedResponse = ApigeeResponseModel<CityResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);
      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        String? errorCode = "";
        try {
          final decodedResponse =
              ApigeeResponseModel<CityResponseModel>.fromMap(response.data,
                  parsedResult: null);
          errorCode = decodedResponse.data?.responseCode;
          CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}

        throw ServerException("errors_server_error_2".tr(),
            errorCode: errorCode,
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }
}

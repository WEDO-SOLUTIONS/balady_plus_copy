import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel, ProvidersResponseModel;

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show ProviderParams, ProviderDetailsParams, ProviderDetailsResponseModel;

abstract class ProvidersRemoteDataSource {
  Future<ApigeeResponse<ProvidersResponseModel>> getProviders(
      {required ProviderParams params});
  Future<ApigeeResponse<ProviderDetailsResponseModel>> getProviderDetails(
      {required ProviderDetailsParams params});
}

class ProvidersRemoteDataSourceImpl extends ProvidersRemoteDataSource {
  final WebService webService;

  ProvidersRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<ProvidersResponseModel>> getProviders(
      {required ProviderParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.topOrderedServiceProviders,
        queryParameters: {
          ApiParams.cityId: params.cityId,
          ApiParams.maxCount: params.pageIndex
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? ProvidersResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<ProvidersResponseModel>.fromMap(response.data,
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
  Future<ApigeeResponse<ProviderDetailsResponseModel>> getProviderDetails(
      {required ProviderDetailsParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.providers + params.providerId,
        queryParameters: {
          ApiParams.cityId: params.cityId,
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? ProviderDetailsResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<ProviderDetailsResponseModel>.fromMap(
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
}

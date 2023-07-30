import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel;

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay, CommonProperties;
import 'package:balady_plus/etmam_app/features/services/data/models/service_details/service_details_response_model.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show
        ServicesResponseModel,
        ServiceParams,
        ServiceDetailsParams,
        RelationResponseModel,
        RelationParams;

abstract class ServicesRemoteDataSource {
  Future<ApigeeResponse<ServicesResponseModel>> getServices(
      {required ServiceParams params});
  Future<ApigeeResponse<ServiceDetailsResponseModel>> getServiceDetails(
      {required ServiceDetailsParams params});

  Future<ApigeeResponse<RelationResponseModel>> getRelations(
      {required RelationParams params});
}

class ServicesRemoteDataSourceImpl extends ServicesRemoteDataSource {
  final WebService webService;

  ServicesRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<ServicesResponseModel>> getServices(
      {required ServiceParams params}) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.services + params.subServiceId,
        queryParameters: {
          ApiParams.pageNo: params.pageIndex,
          ApiParams.pageSize: 10,
          ApiParams.cityId: params.cityId,
          ApiParams.name: params.name
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? ServicesResponseModel.fromMap(data) : null;
      parsedResult?.serviceId = params.subServiceId;
      parsedResult?.serviceName = params.subServiceName;
      final decodedResponse =
          ApigeeResponseModel<ServicesResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            trans("errors_server_error_1");
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse =
            ApigeeResponseModel<ServicesResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, errorCode: errorCode);
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
  Future<ApigeeResponse<ServiceDetailsResponseModel>> getServiceDetails(
      {required ServiceDetailsParams params}) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.serviceDetails +
            params.serviceProviderId +
            "/services/" +
            params.subServiceId,
        queryParameters: {ApiParams.cityId: params.cityId},
      );

      var data = response.data["data"]?["result"];
      var parsedResult =
          data != null ? ServiceDetailsResponseModel.fromMap(data) : null;

      final decodedResponse =
          ApigeeResponseModel<ServiceDetailsResponseModel>.fromMap(
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
  Future<ApigeeResponse<RelationResponseModel>> getRelations(
      {required RelationParams params}) async {
    var response;
    try {
      response = await webService.dio.get(
          ApiUrl.relationsByService + params.subServiceId,
          queryParameters: {ApiParams.cityId: params.cityId},
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? RelationResponseModel.fromMap(data) : null;
      parsedResult?.serviceId = params.subServiceId;
      final decodedResponse =
          ApigeeResponseModel<RelationResponseModel>.fromMap(response.data,
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

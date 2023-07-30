import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel, ProvidersResponseModel;
import 'package:balady_plus/etmam_app/features/home/data/models/ads/ads_reponse_model.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        MainServiceParams,
        MainServicesResponseModel,
        TopRatedProviderParams,
        SubServiceParams,
        TopOrderedSubServiceParams,
        SubServicesResponseModel;
import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;

import '../../../../../app/core/services/global/web_service.dart';

abstract class HomeRemoteDataSource {
  Future<ApigeeResponse<MainServicesResponseModel>> getMainServices(
      {required MainServiceParams params});

  Future<ApigeeResponse<SubServicesResponseModel>> getTopOrderedSubServices(
      {required TopOrderedSubServiceParams params});

  Future<ApigeeResponse<ProvidersResponseModel>> getTopRatedProviders(
      {required TopRatedProviderParams params});

  Future<ApigeeResponse<SubServicesResponseModel>> getSubServices(
      {required SubServiceParams params});

  Future<ApigeeResponse<AdResponseModel>> getAds();
}

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final WebService webService;

  HomeRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<MainServicesResponseModel>> getMainServices(
      {required MainServiceParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.mainServices,
        queryParameters: {
          ApiParams.pageNo: params.pageIndex,
          ApiParams.pageSize: params.pageSize,
          ApiParams.cityId: params.cityId
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? MainServicesResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<MainServicesResponseModel>.fromMap(response.data,
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
  Future<ApigeeResponse<SubServicesResponseModel>> getTopOrderedSubServices(
      {required TopOrderedSubServiceParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.topOrderedServices,
        queryParameters: {
          ApiParams.cityId: params.cityId,
          ApiParams.pageSize: params.pageSize,
          ApiParams.pageNo: params.pageIndex,
          ApiParams.sort: ApiParams.desc
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? SubServicesResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<SubServicesResponseModel>.fromMap(response.data,
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
  Future<ApigeeResponse<ProvidersResponseModel>> getTopRatedProviders(
      {required TopRatedProviderParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.topOrderedServiceProviders,
        queryParameters: {
          ApiParams.cityId: params.cityId,
          ApiParams.pageNo: params.pageIndex,
          ApiParams.pageSize: params.pageSize,
          ApiParams.name: params.name,
          ApiParams.sort: ApiParams.desc
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
      var errorCode;
      try {
        final decodedResponse =
            ApigeeResponseModel<ProvidersResponseModel>.fromMap(
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
  Future<ApigeeResponse<SubServicesResponseModel>> getSubServices(
      {required SubServiceParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.subServices + params.mainServiceId,
        queryParameters: {
          ApiParams.cityId: params.cityId,
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? SubServicesResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<SubServicesResponseModel>.fromMap(response.data,
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
  Future<ApigeeResponse<AdResponseModel>> getAds() async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.ads,
        queryParameters: {
          ApiParams.page_Size: 3,
          ApiParams.page_No: 1,
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult = data != null ? AdResponseModel.fromMap(data) : null;
      final decodedResponse = ApigeeResponseModel<AdResponseModel>.fromMap(
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

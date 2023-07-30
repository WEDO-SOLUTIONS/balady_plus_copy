import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerException;
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/models/apigee_response_model.dart';
import 'package:balady_plus/etmam_app/features/search/search_exports.dart';

abstract class SearchRemoteDataSource {
  Future<ApigeeResponse<SearchResponseModel>> getSearchData(
      {required SearchParams params});
}

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  final WebService webService;

  SearchRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponseModel<SearchResponseModel>> getSearchData(
      {required SearchParams params}) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.search,
        queryParameters: {
          ApiParams.text: params.text,
          ApiParams.pageIndex: params.pageIndex,
          ApiParams.pageSize: 10,
          ApiParams.cityId: CommonProperties.cityId
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? SearchResponseModel.fromMap(data) : null;
      final decodedResponse = ApigeeResponseModel<SearchResponseModel>.fromMap(
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

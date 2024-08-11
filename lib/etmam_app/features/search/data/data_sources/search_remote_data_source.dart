import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show APIException, ServerException;
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/models/apigee_response_model.dart';
import 'package:balady_plus/etmam_app/features/search/search_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

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
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception: error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}

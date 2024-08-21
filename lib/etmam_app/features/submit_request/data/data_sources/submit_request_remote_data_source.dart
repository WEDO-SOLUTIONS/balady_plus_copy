import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel;

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show APIException, ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;
import 'package:balady_plus/etmam_app/features/submit_request/data/models/submit_request/submit_response_model.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_response.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class SubmitRequestRemoteDataSource {
  Future<ApigeeResponse<SubmitRespone>> submitRequest(
      {required SubmitParams params});
}

class SubmitRequestRemoteDataSourceImpl extends SubmitRequestRemoteDataSource {
  final WebService webService;

  SubmitRequestRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<SubmitRespone>> submitRequest(
      {required SubmitParams params}) async {
    var response;
    try {
      var body = params.changeProvider == true
          ? {
              "providerId": params.providerId,
              "orderId": params.orderId,
              "profileId": CommonProperties.profileId,
            }
          : {
              ApiParams.cityId: params.cityId,
              "providerId": params.providerId,
              "relationId": params.relationId,
              "profileId": CommonProperties.profileId,
              if (params.subOrders != null)
                "subOrders": params.subOrders!
                    .map((e) => {
                          "providerId": e.providerId,
                          "subRelationId": e.subRelationId
                        })
                    .toList(),
              if (params.fields != null && params.fields!.isNotEmpty)
                "inputs": {
                  "fields": params.fields!.map((key, value) {
                    return MapEntry(key, {"value": value});
                  }),
                  "id": params.formId
                },
            };
      var url;
      url = params.changeProvider == true
          ? ApiUrl.changeProvider
          : ApiUrl.submitRequest;

      if (params.changeProvider == true)
        response = await webService.dio.put(url,
            data: body,
            options: Options(headers: {
              "Authorization": "Bearer " + (CommonProperties.token ?? "")
            }));
      else {
        response = await webService.dio.post(url,
            data: body,
            options: Options(headers: {
              "Authorization": "Bearer " + (CommonProperties.token ?? "")
            }));
      }
      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? SubmitResponseModel.fromMap(data) : null;

      final decodedResponse = ApigeeResponseModel<SubmitResponseModel>.fromMap(
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
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
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

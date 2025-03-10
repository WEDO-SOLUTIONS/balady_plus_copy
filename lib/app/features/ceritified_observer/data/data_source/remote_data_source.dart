import 'dart:convert';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import '../../domain/entity/observer_status_entity.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class CertifiedObserverRemoteDataSource {
  Future<ResponseBodyModel<ObserverStatusEntity>> getObserverStatus(String identityNumber);

}

class CertifiedObserverRemoteDataSourceImplementation implements CertifiedObserverRemoteDataSource {
  final WebService webService;

  CertifiedObserverRemoteDataSourceImplementation({required this.webService});

  @override
  Future<ResponseBodyModel<ObserverStatusEntity>> getObserverStatus(String identityNumber) async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.getObserverStatus(identityNumber));
      final data = response.data;

      var parsedResult = data != null
          ? ObserverStatusEntity.fromJson(data["data"]["result"])
          : null;
      final decodedResponse = ResponseBodyModel<ObserverStatusEntity>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }
}

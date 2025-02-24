import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/splash/data/model/splash_model.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class SplashRemoteDataSource {
  Future<SplashModel> getSplash();
}

class SplashRemoteDataSourceImpl extends SplashRemoteDataSource {
  final WebService webService;

  SplashRemoteDataSourceImpl({required this.webService});

  @override
  Future<SplashModel> getSplash() async {
    Response response;
    try {
      response = await webService.dio.get(
        ApiUrl.splash,
      );
      final decodedResponse = SplashResponse.fromJson(
          response.data);

      return decodedResponse.data.result.first;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }
}

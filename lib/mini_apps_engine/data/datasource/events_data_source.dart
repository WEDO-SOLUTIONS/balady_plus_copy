import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../app/core/errors/exceptions.dart';
import '../../../app/events_logs/controller/logs_controller.dart';
import '../../../app/events_logs/events_names.dart';
import '../../../app/events_logs/models/error_exception_model.dart';

abstract class MiniAppsLocalDataSource {
  Future<List<MiniAppModel>> getAllServices();
  Future<String> getMiniAppAcessToken(String serviceId);
}

class MiniAppsDataSourceImplementation implements MiniAppsLocalDataSource {
  final WebService webServices;

  MiniAppsDataSourceImplementation({required this.webServices});

  @override
  Future<List<MiniAppModel>> getAllServices() async {
    Response? response;
    try {
      response = await webServices.dio.get("/v1/balady-mini-apps/services");

      var result = response.data["data"]["result"]['items'];
      List<MiniAppModel> list = result.map<MiniAppModel>((e) => MiniAppModel.fromJson(e)).toList();
      return list;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );

      var errorCode = error.response?.data;
      throw ServerException(
        error.toString(),
        errorCode: errorCode,
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
          exception: APIException(errorMessage: error.toString()),
          response: response,
        );
      }
    }
  }

  @override
  Future<String> getMiniAppAcessToken(String serviceId) async {
    Response? response;
    try {
      response = await webServices.dio.post("/v1/balady-mini-apps/services/5D9B75C5-4F10-4D2D-A8EB-08DD972A4B5A/token");

      var result = response.data["data"]["result"]['token'];

      return result;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );

      var errorCode = error.response?.data;
      throw ServerException(
        error.toString(),
        errorCode: errorCode,
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
          exception: APIException(errorMessage: error.toString()),
          response: response,
        );
      }
    }
  }
}

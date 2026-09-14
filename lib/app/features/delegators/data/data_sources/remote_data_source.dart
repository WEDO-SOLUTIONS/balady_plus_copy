import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/log.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../delegators_exports.dart' show DelegatorModel, AgentModel;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class DelegatorsRemoteDataSource {
  Future<List<DelegatorModel>> getDelegators();
  Future<List<AgentModel>> getAgents();
}

class DelegatorsRemoteDataSourceImplementation implements DelegatorsRemoteDataSource {
  final WebService webService;

  DelegatorsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<DelegatorModel>> getDelegators() async {
    Response? response;
    try {
      response = await webService.dio.get(ApiUrl.delegators);

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result.map<DelegatorModel>((e) => DelegatorModel.fromMap(e as Map<String, dynamic>)).toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      String? errorCode;
      try {
        final decodedResponse = ResponseBodyModel.fromMap(error.response?.data);
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }

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
      "Catched $error".errorLog();
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
  Future<List<AgentModel>> getAgents() async {
    Response? response;
    try {
      response = await webService.dio.get(ApiUrl.agents);

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result.map<AgentModel>((e) => AgentModel.fromMap(e as Map<String, dynamic>)).toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

      String? errorCode;
      try {
        final decodedResponse = ResponseBodyModel.fromMap(error.response?.data);
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }

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
      "Catched $error".errorLog();
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

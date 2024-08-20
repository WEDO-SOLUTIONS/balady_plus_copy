import 'dart:async';

import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:dio/dio.dart' show Response, DioError;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class CommercialDebtsDataSources {
  Future<CommercialDebt> getDebts({
    required TransactionType transactionType,
    required int transactionId,
    required String stepId,
  });
}

class ChatBotDataSourcesImplementation extends CommercialDebtsDataSources {
  final WebService webService;

  ChatBotDataSourcesImplementation({required this.webService});

  @override
  Future<CommercialDebt> getDebts({
    required TransactionType transactionType,
    required int transactionId,
    required String stepId,
  }) async {
    Response? response;
    try {
      response = await webService.dio.post(
        CommercialModelEndPoints.getDebts(
          transactionId: transactionId,
          transactionType: transactionType.name,
        ),
        queryParameters: {
          "channelId": "mobile",
          "platform": "baladyservices",
          "stepId": stepId,
        },
      );
      return CommercialDebt.fromJson(response.data);
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

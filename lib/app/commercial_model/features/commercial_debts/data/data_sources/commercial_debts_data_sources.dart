import 'dart:async';

import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_list_debts_model.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dio/dio.dart' show DioError, Options, Response;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class CommercialDebtsDataSources {
  Future<CommercialDebt> checkDebts({
    required TransactionType transactionType,
    required int transactionId,
    required String stepId,
    required CommercialLicenseServiceId serviceId,
  });

  Future<CommercialListDebt> getListDebts({
    required String referenceId,
    required int transactionId,
    required TransactionType transactionType,
    required int pageNumber,
  });
}


class CommercialDebtsDataSourcesImplementation
    implements CommercialDebtsDataSources {
  final WebService webService;

  CommercialDebtsDataSourcesImplementation({required this.webService});




  @override
  Future<CommercialDebt> checkDebts({
    required TransactionType transactionType,
    required int transactionId,
    required String stepId,
    required CommercialLicenseServiceId serviceId,
  }) async {
    Response? response;
    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.checkDebts(
          transactionId: transactionId,
          transactionType: transactionType.name,
        ),
        queryParameters: {"stepId": stepId},
        options: Options(
          headers: {
            "x-platform-id": "baladyservices",
            "x-channel-id": "mobile",
            "x-intg-service-id": serviceId.id,
          },
        ),
      );
      var result = ResponseBodyModel.fromMap(response.data).data?.result;
      return CommercialDebt.fromJson(result);
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
      if (error is ServerException) {
        rethrow;
      } else {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
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

  @override
  Future<CommercialListDebt> getListDebts({
    required String referenceId,
    required int transactionId,
    required TransactionType transactionType,
    required int pageNumber,
  }) async {
    Response? response;
    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.getListDebtsPaging(
          transactionId: transactionId,
          transactionType: transactionType.name,
          referenceId: referenceId,
        ),
        queryParameters: {
          "page-number": pageNumber,
          "page-size": 10
        },
        options: Options(
          headers: {
            "x-platform-id": "baladyservices",
            "x-channel-id": "mobile",
          },
        ),
      );

      var result = ResponseBodyModel.fromMap(response.data).data?.result;
      return CommercialListDebt.fromJson(result);
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
      if (error is ServerException) {
        rethrow;
      } else {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(errorMessage: error.toString()),
          response: response,
        );
      }
    }
  }
}

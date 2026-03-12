import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/events_logs/controller/logs_controller.dart';
import 'package:balady_plus/app/events_logs/events_names.dart';
import 'package:balady_plus/app/events_logs/models/error_exception_model.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/dashboard/data/models/dashboard_card_model.dart';
import 'package:balady_plus/app/features/dashboard/data/models/dashboard_product_model.dart';
import 'package:balady_plus/app/features/dashboard/data/models/dashboard_products_param_model.dart';
import 'package:balady_plus/app/features/dashboard/data/models/dashboard_statistics_model.dart';
import 'package:balady_plus/app/features/dashboard/data/models/dashboard_statistics_param_model.dart';
import 'package:balady_plus/app/features/dashboard/data/models/volunteering_statistics_model.dart';
import 'package:dio/dio.dart' show DioException, Response;
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/extensions/log.dart';

abstract class DashboardRemoteDataSource {
  Future<List<DashboardCardModel>> getDashboardCards();

  Future<List<DashboardProductModel>> getCardProducts(DashboardProductsParamsModel params);

  Future<List<DashboardStatisticsModel>> getCardStatistics(DashboardStatisticsParamsModel params);

  Future<VolunteeringStatisticsModel> getVolunteeringStatistics();
}

class DashboardRemoteDataSourceImplementation implements DashboardRemoteDataSource {
  final WebService webService;

  DashboardRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<DashboardCardModel>> getDashboardCards() async {
    Response? response;
    try {
      response = await webService.dio.get(
        ApiUrl.dashboardCards,
      );

      final data = response.data;
      data.toString().successLog();
      //TODO:
      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result.map<DashboardCardModel>((e) => DashboardCardModel.fromMap(e as Map<String, dynamic>)).toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<DashboardProductModel>> getCardProducts(DashboardProductsParamsModel params) async {
    Response? response;
    try {
      response = await webService.dio.get(
        ApiUrl.dashboardCardProducts(params.cardId),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<DashboardProductModel>((e) => DashboardProductModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<DashboardStatisticsModel>> getCardStatistics(DashboardStatisticsParamsModel params) async {
    Response? response;
    try {
      response = await webService.dio.get(
        ApiUrl.dashboardCardStatistics,
        queryParameters: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<DashboardStatisticsModel>((e) => DashboardStatisticsModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<VolunteeringStatisticsModel> getVolunteeringStatistics() async {
    Response? response;
    try {
      response = await webService.dio.get(ApiUrl.volunteerCardStatistics);

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return VolunteeringStatisticsModel.fromJson(result as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
            nameEvent: EventsName.handledException, message: error.toString(), stackTrace: stackTrace.toString()),
      );
      "DioError $error".errorLog();
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Caught $error".errorLog();
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

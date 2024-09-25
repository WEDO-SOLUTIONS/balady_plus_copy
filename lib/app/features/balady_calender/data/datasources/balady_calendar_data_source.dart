import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_response.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/list_events_details.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/filter/filter_response.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_months_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_details_params.dart';
import '../../../../core/services/global/web_service.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class BaladyCalendarRemoteDataSource {
  Future<Filter> getFilteredEvents();

  Future<EventsCountInYears> getEventsCountInYears({
    required EventsCommonParams params,
  });

  Future<List<MonthsEventsCount>> getEventsCountInMonths({
    required EventsCountInMonthsParams params,
  });

  Future<EventsDetails> getEventsDetails({required EventsDetailsParams params});
}

class CalendarBaladyRemoteDataSourceImpl
    extends BaladyCalendarRemoteDataSource {
  final WebService webService;

  CalendarBaladyRemoteDataSourceImpl({required this.webService});

  @override
  Future<Filter> getFilteredEvents() async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.baladyCalendarFilter,
        options: Options(
          headers: {
            /*"Authorization": token*/
          },
        ),
      );
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return Filter.fromJson(result);
    } on DioException catch (error, stackTrace) {
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

  @override
  Future<EventsCountInYears> getEventsCountInYears(
      {required EventsCommonParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.baladyCalendarEventsCountInYears,
        queryParameters: params.toJson(),
        options: Options(
          headers: {
            /*"Authorization": token*/
          },
        ),
      );
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return EventsCountInYears.fromJson(result);
    } on DioException catch (error, stackTrace) {
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

  @override
  Future<List<MonthsEventsCount>> getEventsCountInMonths(
      {required EventsCountInMonthsParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.baladyCalendarEventsCountInMonths,
        queryParameters: params.toJson(),
        options: Options(
          headers: {
            /*"Authorization": token*/
          },
        ),
      );
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return monthsListFromMap(result);
    } on DioException catch (error, stackTrace) {
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

  @override
  Future<EventsDetails> getEventsDetails(
      {required EventsDetailsParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.baladyCalendarEvents,
        queryParameters: params.toJson(),
      );
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return EventsDetails.fromJson(result);
    } on DioException catch (error, stackTrace) {
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

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/events/data/models/events_category/events_cateogry_response_model.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_params.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/services/global/web_service.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entities/search_calendar/calendar_details_response.dart';
import '../../domain/entities/search_calendar/search_calendar_params.dart';
import '../models/calendar_details/calendar_detail_model.dart';
import '../models/search_calendar/search_calendars_response_model.dart';

abstract class CalendarRemoteDataSource {
  Future<SearchCalendarResponseModel> getSearchEvents(
      {required SearchCalendarParams params});

  Future<EventsCategoryResponseModel> getEventCategory(
      {required EventsCategoryParams params});

  Future<CalendarDetailsModel> getEventDetails({required String params});
}

class CalendarRemoteDataSourceImpl extends CalendarRemoteDataSource {
  final WebService webService;
  CalendarRemoteDataSourceImpl({required this.webService});

  @override
  Future<SearchCalendarResponseModel> getSearchEvents(
      {required SearchCalendarParams params}) async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.calendarSearch,
          queryParameters: params.toMap(),
          options: Options(headers: {
            /*"Authorization": token*/
          }));
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return SearchCalendarResponseModel.fromMap(result);
    } on DioError catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<EventsCategoryResponseModel> getEventCategory(
      {required EventsCategoryParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.eventsCategory}/${params.key}",
      );

      var data = response.data;

      return EventsCategoryResponseModel.fromMap(data["data"]);
    } on DioError catch (error) {
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<CalendarDetailsModel> getEventDetails({required String params}) async {
    var response;
    try {
      response = await webService.dio.get(
        "${ApiUrl.calendarDetails}/${params}",
        options: Options(headers: {/*"Authorization": token*/}),
      );

      var data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;

      return CalendarDetailsModel.fromJson(result);
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          dioError: error,
          errorCode: error is NoDataFoundException ? "2" : null);
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }
}

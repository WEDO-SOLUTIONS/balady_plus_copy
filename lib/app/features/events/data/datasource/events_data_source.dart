import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/events/data/models/event_details/events_detail_item_model.dart';
import 'package:balady_plus/app/features/events/data/models/events_category/events_cateogry_response_model.dart';
import 'package:balady_plus/app/features/events/data/models/search_events/search_events_response_model.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_params.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/services/global/web_service.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class EventsRemoteDataSource {
  final String token =
      'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE2OTQzNDQzNzMsImlhdCI6MTY5NDM0NDM3MywiZXhwIjoxNjk1NTUzOTczLCJhdWQiOlsiRW1wbG95ZWVBZG1pbnN0cmF0aW9uLkFwaSIsImh0dHBzOi8vc3NvYXBwZGV2Lm1vbXJhLmdvdi5zYS9yZXNvdXJjZXMiXSwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIkVtcGxveWVlQWRtaW5zdHJhdGlvbi5BcGkiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl0sImNsaWVudF9pZCI6ImJhbGFkeV9tb2JpbGVfYXBwIiwic3ViIjoiOTk1ZDgwZDItNzI5NC00N2VmLWJiNTQtY2I0YzY5MmQ3ZDJlIiwiYXV0aF90aW1lIjoxNjk0MzQ0MzcyLCJpZHAiOiJsb2NhbCIsImVtYWlsIjoiYWFsYnVoYXlyaUBtb21yYWguZ292LnNhIiwicGhvbmVfbnVtYmVyIjoiNTY4NjE2OTE5IiwibmFtZSI6IjEwOTM2NjA1NTEiLCJ0aWQiOiIzMjEiLCJ0bm0iOiLYo9mF2KfZhtipINmF2YbYt9mC2Kkg2KfZhNix2YrYp9i2IiwibWFpbCI6ImFhbGJ1aGF5cmlAbW9tcmFoLmdvdi5zYSIsInNleCI6IjEiLCJkb2IiOiIxMi8wNy8xOTk0IiwicGhvbmUiOiIwNTY4NjE2OTE5IiwiYXJfbmFtZSI6Iti52KjYr9in2YTZhdit2LPZhiDYudio2K_Yp9mE2LnYstmK2LIg2YXYrdmF2K8g2KfZhNio2K3Zitix2YoiLCJlbl9uYW1lIjoiQUJEVUxNT0hTRU4gQUJEVUxBWklaIE1PSEFNTUVEIEFMQlVIQVlSSSIsImlkX25vIjoiMTA5MzY2MDU1MSIsIm5pZCI6IjExMyIsIm5hdGlvbmFsaXR5Ijoi2LPYudmI2K_ZiiIsImlkX3R5cGUiOiIxIiwic25hbWUiOiLYudio2K_Yp9mE2YXYrdiz2YYs2LnYqNiv2KfZhNi52LLZitiyLNmF2K3ZhdivLNin2YTYqNit2YrYsdmKIiwidGVuYW50cyI6Ilt7XCJUZW5hbnROYW1lXCI6XCLYo9mF2KfZhtipINmF2YbYt9mC2Kkg2KfZhNix2YrYp9i2XCIsXCJUZW5hbnRJZFwiOjMyMSxcIlRlbmFudFR5cGVcIjpudWxsLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6dHJ1ZX0se1wiVGVuYW50TmFtZVwiOlwi2KjZhNiv2YrYqSDYp9mE2K_ZiNin2K_ZhdmKXCIsXCJUZW5hbnRJZFwiOjMzNyxcIlRlbmFudFR5cGVcIjpudWxsLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9XSIsImJtYWlsIjoiIiwic2lkIjoiNDY3QjI0Q0QyNjQ2MDMyMzMxNUIzNUY2OEQ1NDUzQTQiLCJqdGkiOiJDQkYwODQ3Q0E4OTkyMUVDODExNzgzQjVFMjNGMzA5OSJ9.cb8LCag7JCPwAsBhBqq1Gzwk2zxGYErBnOQSof_bXglN1aV6rUEu9PQjSwUqPRioUq3WsN8lXqE7R4woaH1vYBHt__Vx4tJGaMV8YKpTIrS5kdFqrd9jp2JY8ubd7pe6nuSKe4eKluQqAlhy1oVT852-2ZHiSRVQbqBXek6T1YAflY2J1hYh7CqoiFsAMnoClN5UkrT7V4mYZW2gdOsb4feZDcoTztY4F-CIZgEY2hQGO9G_kZLRrLLpjNXQZjc3i3tTUYnU7AFosvzgVebzjRDR7_X105xp8s0zFudSoZwp3YML2oRKPmurlcSjJyNCXxL5m-ip32cCNDtGjW6ZjA';
  Future<SearchEventResponseModel> getSearchEvents({required SearchEventsParams params});

  Future<EventsDetailsItemModel> getEventDetails({required EventDetailsParams params});
  Future<EventsCategoryResponseModel> getEventCategory({required EventsCategoryParams params});
}

class EventDataSourceImpl extends EventsRemoteDataSource {
  final WebService webService;
  EventDataSourceImpl({required this.webService});

  @override
  Future<SearchEventResponseModel> getSearchEvents({required SearchEventsParams params}) async {
    Response? response;
    try {
      response = await webService.dio.get(
        ApiUrl.eventsSearch,
        queryParameters: params.toMap(),
        options: Options(
          headers: {
            /*"Authorization": token*/
          },
        ),
      );
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return SearchEventResponseModel.fromMap(result);
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

      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
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
  Future<EventsDetailsItemModel> getEventDetails({required EventDetailsParams params}) async {
    Response? response;
    try {
      response = await webService.dio.get(
        "${ApiUrl.eventsDetails}/${params.key}",
        queryParameters: params.toMap(),
        options: Options(headers: {/*"Authorization": token*/}),
      );

      var data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;

      return EventsDetailsItemModel.fromJson(result);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
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
  Future<EventsCategoryResponseModel> getEventCategory({required EventsCategoryParams params}) async {
    Response? response;
    try {
      response = await webService.dio.get("${ApiUrl.eventsCategory}/${params.key}");

      var data = response.data;

      return EventsCategoryResponseModel.fromMap(data["data"]);
    } on DioException catch (error, stackTrace) {
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
        errorCode: error is NoDataFoundException ? "2" : null,
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

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/errors_exports.dart' show APIException, ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiHeader, ApiUrl, CommonFunctions, EnvType, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart' show ResponseBodyModel;
import '../../prayer_times_exports.dart'
    show
        PrayerTimeRangeParams,
        PrayerTimeRangeResponseModel,
        PrayerTimesParams,
        PrayerTimesResponse,
        PrayerTimesResponseModel;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class PrayerTimesRemoteDataSource {
  Future<PrayerTimesResponse> getPrayerTimes(PrayerTimesParams params);
  Future<List<PrayerTimeRangeResponseModel>> getPrayerTimesRange(PrayerTimeRangeParams params);
}

class PrayerTimesRemoteDataSourceImplementation implements PrayerTimesRemoteDataSource {
  final WebService webService;

  PrayerTimesRemoteDataSourceImplementation({required this.webService});

  @override
  Future<PrayerTimesResponse> getPrayerTimes(PrayerTimesParams params) async {
    Response? response;
    try {
      response = await webService.dio.get(ApiUrl.prayerTimes, queryParameters: params.toMap());

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return PrayerTimesResponseModel.fromMap(result as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
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
  Future<List<PrayerTimeRangeResponseModel>> getPrayerTimesRange(PrayerTimeRangeParams params) async {
    Response? response;
    try {
      String q = "${sl<EnvType>().domain}v1/kacst/prayer-times-range?";
      params.toMap().forEach((key, value) {
        q += "$key=$value&";
      });
      q = q.substring(0, q.length - 1);
      response = await webService.dio.get(
        ApiUrl.prayerTimesRange,
        queryParameters: params.toMap(),
        options: Options(
          headers: {
            ApiHeader.requiresToken.eName: false,
            ApiHeader.verifyingKEY.name: CommonFunctions.hashRequest(q, "GET"),
          },
        ),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result != null ? ((result) as List).map((i) => PrayerTimeRangeResponseModel.fromJson(i)).toList() : [];
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
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

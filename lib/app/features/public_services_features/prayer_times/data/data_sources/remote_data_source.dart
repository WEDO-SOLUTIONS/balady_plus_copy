import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../prayer_times_exports.dart'
    show PrayerTimesParams, PrayerTimesResponse, PrayerTimesResponseModel;

abstract class PrayerTimesRemoteDataSource {
  Future<PrayerTimesResponse> getPrayerTimes(
    PrayerTimesParams params,
  );
}

class PrayerTimesRemoteDataSourceImplementation
    implements PrayerTimesRemoteDataSource {
  final WebService webService;

  PrayerTimesRemoteDataSourceImplementation({
    required this.webService,
  });

  @override
  Future<PrayerTimesResponse> getPrayerTimes(
    PrayerTimesParams params,
  ) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.prayerTimes,
        queryParameters: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return PrayerTimesResponseModel.fromMap(result as Map<String, dynamic>);
    } on DioError catch (error) {
      "DioError $error".errorLog();

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }
}

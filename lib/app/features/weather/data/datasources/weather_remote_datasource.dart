import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/errors_exports.dart';
import '../../../../core/services/global/web_service.dart';
import '../../../../core/utils/utils_exports.dart' show ApiHeader, ApiUrl, CommonFunctions, EnvType;
import '../../weather_exports.dart'
    show
        AlertsModel,
        AllWeatherInfoModel,
        AstroModel,
        ConditionsModel,
        CurrentModel,
        DayModel,
        ForecastDayModel,
        ForecastModel,
        HourModel,
        LocationModel,
        WeatherParams;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class WeatherRemoteDataSource {
  Future<AllWeatherInfoModel> getAllWeatherInfoForLocation({required WeatherParams params});
}

class WeatherRemoteDataSourceImpl extends WeatherRemoteDataSource {
  final WebService webService;

  WeatherRemoteDataSourceImpl({required this.webService});
  @override
  Future<AllWeatherInfoModel> getAllWeatherInfoForLocation({required WeatherParams params}) async {
    Response? response;
    String weatherAPI = ApiUrl.weatherForcastAPI;
    try {
      String q = "${sl<EnvType>().domain}v1/weather-services/forecast?";
      params.toMap().forEach((key, value) {
        q += "$key=$value&";
      });
      q = q.substring(0, q.length - 1);
      response = await webService.dio.get(
        weatherAPI,
        queryParameters: params.toMap(),
        options: Options(
          headers: {
            "Accept-Language": "ar",
            ApiHeader.requiresToken.eName: false,
            ApiHeader.verifyingKEY.name: CommonFunctions.hashRequest(q, "GET"),
          },
        ),
      );
      var locationData = response.data['data']['result']['location'];
      var currentData = response.data['data']['result']['current'];
      var forecastData = response.data['data']['result']['forecast'];
      var alertsData = response.data['data']['result']['alerts'];

      CurrentModel? decodedCurrentResponse;
      final decodedAlertsResponse = AlertsModel.fromJson(alertsData);

      final List forecastDayData = forecastData['forecastday'];

      final decodedLocationResponse = LocationModel.fromMap(locationData);
      final currentCondition = currentData['condition'];

      if (currentCondition != null) {
        decodedCurrentResponse = CurrentModel.fromMap(currentData, ConditionsModel.fromMap(currentCondition));
      }

      final List<ForecastDayModel> decodedForecastDayResponse = forecastDayData.map((forecastDay) {
        final List hourData = forecastDay['hour'];
        final dayData = forecastDay['day'];
        final astroData = forecastDay['astro'];

        final List<HourModel> hourDataList = hourData.map((hour) {
          final ConditionsModel decodedHourConditionResponse = ConditionsModel.fromMap(hour['condition']);
          return HourModel.fromMap(hour, decodedHourConditionResponse);
        }).toList();
        ConditionsModel? decodedDayConditionResponse;
        final dayConditionData = dayData['condition'];
        if (dayConditionData != null) {
          decodedDayConditionResponse = ConditionsModel.fromMap(dayConditionData);
        }

        return decodedDayConditionResponse != null
            ? ForecastDayModel.fromMap(
                forecastDay,
                AstroModel.fromMap(astroData),
                DayModel.fromMap(dayData, decodedDayConditionResponse),
                hourDataList,
              )
            : ForecastDayModel();
      }).toList();

      final allWeatherData = AllWeatherInfoModel(
        alerts: decodedAlertsResponse,
        location: decodedLocationResponse,
        current: decodedCurrentResponse,
        forecast: ForecastModel(forecastday: decodedForecastDayResponse),
      );

      return allWeatherData;
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
        try {} catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(errorMessage: error.toString()),
          response: response,
        );
      }
    }
  }
}

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/errors/errors_exports.dart';
import '../../../../core/services/global/web_service_weather.dart';
import '../../../../core/utils/utils_exports.dart' show ApiUrl;
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

abstract class WeatherRemoteDataSource {
  Future<AllWeatherInfoModel> getAllWeatherInfoForLocation(
      {required WeatherParams params});
}

class WeatherRemoteDataSourceImpl extends WeatherRemoteDataSource {
  final WebServiceWeather webServiceWeather;

  WeatherRemoteDataSourceImpl({required this.webServiceWeather});
  @override
  Future<AllWeatherInfoModel> getAllWeatherInfoForLocation(
      {required WeatherParams params}) async {
    var response;
    String weatherAPI = ApiUrl.weatherForcastAPI;
    try {
      response = await webServiceWeather.dio
          .get(weatherAPI, queryParameters: params.toMap());
      var locationData = response.data['location'];
      var currentData = response.data['current'];
      var forecastData = response.data['forecast'];
      var alertsData = response.data['alerts'];
      // print(alertsData);

      final decodedAlertsResponse = AlertsModel.fromJson(alertsData);

      final List forecastDayData = forecastData['forecastday'];

      final decodedLocationResponse = LocationModel.fromMap(locationData);
      final currentCondition = currentData['condition'];
      final decodedCurrentResponse = CurrentModel.fromMap(
          currentData, ConditionsModel.fromMap(currentCondition));

      final List<ForecastDayModel> decodedForecastDayResponse =
          forecastDayData.map((forecastDay) {
        final List hourData = forecastDay['hour'];
        final dayData = forecastDay['day'];
        final astroData = forecastDay['astro'];

        final List<HourModel> hourDataList = hourData.map((hour) {
          final ConditionsModel decodedHourConditionResponse =
              ConditionsModel.fromMap(hour['condition']);
          return HourModel.fromMap(hour, decodedHourConditionResponse);
        }).toList();
        final dayConditionData = dayData['condition'];
        final ConditionsModel decodedDayConditionResponse =
            ConditionsModel.fromMap(dayConditionData);

        return ForecastDayModel.fromMap(
          forecastDay,
          AstroModel.fromMap(astroData),
          DayModel.fromMap(dayData, decodedDayConditionResponse),
          hourDataList,
        );
      }).toList();

      final allWeatherData = AllWeatherInfoModel(
        alerts: decodedAlertsResponse,
        location: decodedLocationResponse,
        current: decodedCurrentResponse,
        forecast: ForecastModel(
          forecastday: decodedForecastDayResponse,
        ),
      );

      return allWeatherData;
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {} catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }
}

part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherForLocation extends WeatherEvent {
  final WeatherParams params = WeatherParams(
      latitude: 24.716145351886862,
      longitude: 46.700150027419696,
      languageCode: 'ar',
      alert: 'yes',
      numberOfDays: 7,
      key: '93974ccfab054bcabd763207232307');

  final bool? showLoading;

  GetWeatherForLocation({this.showLoading = true});
}

part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherForLocation extends WeatherEvent {
  final WeatherParams params = WeatherParams(
      languageCode: 'ar',
      alert: 'yes',
      numberOfDays: 7,
      key: '7fb258f132b04a298ae154452233007');

  final bool? showLoading;

  GetWeatherForLocation({this.showLoading = true});
}

class RefreshWeatherForLocation extends WeatherEvent {
  final WeatherParams params = WeatherParams(
      languageCode: 'ar',
      alert: 'yes',
      numberOfDays: 7,
      key: '7fb258f132b04a298ae154452233007');

  final bool? showLoading;

  RefreshWeatherForLocation({this.showLoading = true});
}

class ChangeIndexEvent extends WeatherEvent {
  final int index;
  const ChangeIndexEvent({required this.index});
}

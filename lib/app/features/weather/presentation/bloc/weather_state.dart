// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final BlocStatus allWeatherInfoStatus;
  final String? errorMessage;
  final AllWeatherInfoEntity? allWeatherInfo;
  final GISResponse? gisResponse;
  const WeatherState(
      {this.allWeatherInfoStatus = BlocStatus.initial,
      this.errorMessage,
      this.allWeatherInfo,
      this.gisResponse});

  @override
  List<Object?> get props => [allWeatherInfoStatus, gisResponse];

  WeatherState copyWith(
      {BlocStatus? allWeatherInfoStatus,
      String? errorMessage,
      AllWeatherInfoEntity? allWeatherInfo,
      GISResponse? gisResponse}) {
    return WeatherState(
        allWeatherInfoStatus: allWeatherInfoStatus ?? this.allWeatherInfoStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        allWeatherInfo: allWeatherInfo ?? this.allWeatherInfo,
        gisResponse: gisResponse ?? this.gisResponse);
  }
}

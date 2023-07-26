// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final BlocStatus allWeatherInfoStatus;
  final String? errorMessage;
  final AllWeatherInfoEntity? allWeatherInfo;
  const WeatherState({
    this.allWeatherInfoStatus = BlocStatus.initial,
    this.errorMessage,
    this.allWeatherInfo,
  });

  @override
  List<Object> get props => [allWeatherInfoStatus];

  WeatherState copyWith({
    BlocStatus? allWeatherInfoStatus,
    String? errorMessage,
    AllWeatherInfoEntity? allWeatherInfo,
  }) {
    return WeatherState(
      allWeatherInfoStatus: allWeatherInfoStatus ?? this.allWeatherInfoStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      allWeatherInfo: allWeatherInfo ?? this.allWeatherInfo,
    );
  }
}

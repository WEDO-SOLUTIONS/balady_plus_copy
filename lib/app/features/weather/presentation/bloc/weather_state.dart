part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final BlocStatus allWeatherInfoStatus;
  final String? errorMessage;
  final AllWeatherInfoEntity? allWeatherInfo;
  final GISResponse? gisResponse;
  final bool? showLocationError;
  final GISParams? location;
  final int? selectedTile;
  const WeatherState(
      {this.allWeatherInfoStatus = BlocStatus.initial,
      this.errorMessage,
      this.allWeatherInfo,
      this.showLocationError,
      this.location,
      this.gisResponse,
      this.selectedTile});

  @override
  List<Object?> get props => [allWeatherInfoStatus, gisResponse, allWeatherInfo, showLocationError, selectedTile];

  WeatherState copyWith(
      {BlocStatus? allWeatherInfoStatus,
      String? errorMessage,
      AllWeatherInfoEntity? allWeatherInfo,
      bool? showLocationError,
      GISParams? location,
      GISResponse? gisResponse,
      int? selectedTile}) {
    return WeatherState(
        allWeatherInfoStatus: allWeatherInfoStatus ?? this.allWeatherInfoStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        allWeatherInfo: allWeatherInfo ?? this.allWeatherInfo,
        showLocationError: showLocationError ?? this.showLocationError,
        location: location ?? this.location,
        selectedTile: selectedTile ?? this.selectedTile,
        gisResponse: gisResponse ?? this.gisResponse);
  }
}

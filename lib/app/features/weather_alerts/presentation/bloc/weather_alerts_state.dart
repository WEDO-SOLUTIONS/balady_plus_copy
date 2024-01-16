// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_alerts_cubit.dart';

class WeatherAlertsState extends Equatable {
  final BlocStatus status;
  final Location? location;

  const WeatherAlertsState({this.status = BlocStatus.initial, this.location});

  @override
  List<Object?> get props => [status, location];

  WeatherAlertsState copyWith({
    BlocStatus? status,
    Location? location,
  }) {
    return WeatherAlertsState(
      status: status ?? this.status,
      location: location ?? this.location,
    );
  }
}

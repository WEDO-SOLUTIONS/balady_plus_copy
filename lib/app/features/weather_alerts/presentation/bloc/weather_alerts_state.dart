// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_alerts_cubit.dart';

class WeatherAlertsState extends Equatable {
  final BlocStatus status;
  final Location? location;
  final DateTime? updateTime;

  const WeatherAlertsState(
      {this.status = BlocStatus.initial, this.location, this.updateTime});

  @override
  List<Object?> get props => [status, location, updateTime];

  WeatherAlertsState copyWith(
      {BlocStatus? status, Location? location, DateTime? updateTime}) {
    return WeatherAlertsState(
        status: status ?? this.status,
        location: location ?? this.location,
        updateTime: updateTime ?? this.updateTime);
  }
}

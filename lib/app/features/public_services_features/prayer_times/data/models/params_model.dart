// class PrayerTimesParams
import 'package:equatable/equatable.dart';

class PrayerTimesParamsModel extends Equatable {
  final DateTime date;
  final double latitude;
  final double longitude;

  const PrayerTimesParamsModel({
    required this.date,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        date,
        latitude,
        longitude,
      ];

  //tomap
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timezone': date.timeZoneOffset.inHours,
      'isFormat24Hours': true,
      'year': date.year,
      'month': date.month,
      'day': date.day,
    };
  }
}

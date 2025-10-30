// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class WeatherAlertRequestModel extends Equatable {
  final double lat;
  final double lon;

  final String fcmToken;
  const WeatherAlertRequestModel({
    required this.lat,
    required this.lon,
    required this.fcmToken,
  });

  @override
  List<Object> get props => [lat, lon, fcmToken];

  WeatherAlertRequestModel copyWith({
    double? lat,
    double? lon,
    String? fcmToken,
  }) {
    return WeatherAlertRequestModel(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  factory WeatherAlertRequestModel.fromMap(Map<String, dynamic> map) {
    return WeatherAlertRequestModel(
      lat: map['lat'] as double,
      lon: map['lon'] as double,
      fcmToken: map['fcmToken'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lon': lon,
      'fcmToken': fcmToken,
    };
  }
}

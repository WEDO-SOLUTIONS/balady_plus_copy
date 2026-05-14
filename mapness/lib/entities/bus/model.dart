import 'dart:ui';

import 'package:equatable/equatable.dart';

class BusStation extends Equatable {
  final int stationId;
  final String nameEn;
  final String nameAr;
  final BusCoordinates coordinates;
  final List<String> lineIds;

  const BusStation({
    required this.stationId,
    required this.nameEn,
    required this.nameAr,
    required this.coordinates,
    required this.lineIds,
  });

  @override
  List<Object?> get props => [stationId, nameEn, nameAr, coordinates, lineIds];
}

class BusLine extends Equatable {
  final String routeNameEn;
  final String routeNameAr;
  final List<BusStation> stations;
  final List<BusCoordinates> polylineCoordinates;
  final int color;

  const BusLine({
    required this.routeNameEn,
    required this.routeNameAr,
    required this.stations,
    required this.polylineCoordinates,
    required this.color,
  });

  @override
  List<Object?> get props => [routeNameEn, routeNameAr, stations, polylineCoordinates, color];
}

class BusCoordinates extends Equatable {
  final double latitude;
  final double longitude;

  const BusCoordinates({
    required this.latitude,
    required this.longitude,
  });

  BusCoordinates.list(List<double> coordinates) : this(longitude: coordinates[0], latitude: coordinates[1]);

  @override
  List<Object?> get props => [latitude, longitude];
}

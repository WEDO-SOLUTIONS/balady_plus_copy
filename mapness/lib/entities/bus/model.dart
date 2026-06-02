import 'dart:ui';

import 'package:equatable/equatable.dart';

class BusStation extends Equatable {
  final int stationId;
  final String nameEn;
  final String nameAr;
  final BusCoordinates coordinates;
  final List<BusLineId> lineIds;

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
  final BusLineId id;
  final String routeShortNameEn;
  final String routeShortNameAr;
  final String routeLongNameEn;
  final String routeLongNameAr;
  final List<BusStation> stations;
  final List<BusCoordinates> polylineCoordinates;
  final int color;

  const BusLine({
    required this.id,
    required this.routeShortNameEn,
    required this.routeShortNameAr,
    required this.routeLongNameEn,
    required this.routeLongNameAr,
    required this.stations,
    required this.polylineCoordinates,
    required this.color,
  });

  @override
  List<Object?> get props => [
    id,
    routeShortNameEn,
    routeShortNameAr,
    routeLongNameEn,
    routeLongNameAr,
    stations,
    polylineCoordinates,
    color,
  ];

  Color get flutterColor => Color(color);
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

class BusLineId extends Equatable {
  final String name;
  final BusLineDirection direction;

  const BusLineId({
    required this.name,
    required this.direction,
  });

  @override
  List<Object?> get props => [name, direction];
}

enum BusLineDirection {
  forward,
  backward;

  static BusLineDirection fromString(String s) {
    for (final v in values) {
      if (v.name == s) {
        return v;
      }
    }
    throw UnimplementedError();
  }
}

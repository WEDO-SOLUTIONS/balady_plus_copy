import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GISParams extends Equatable {
  double x;
  double y;

  GISParams({required this.x, required this.y});

  @override
  List<Object?> get props => [x, y];

  LatLng getLatLng() {
    return LatLng(y, x);
  }

  Map<String, dynamic> toMap() {
    return {
      "x": x,
      "y": y,
    };
  }
}

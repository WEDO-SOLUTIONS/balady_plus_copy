import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  final String? x;
  final String? y;

  Location({
    this.x,
    this.y,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };

  LatLng? get mapLatLng =>
      double.tryParse(x ?? "") != null && double.tryParse(y ?? "") != null
          ? LatLng(double.tryParse(y ?? "")!, double.tryParse(x ?? "")!)
          : null;
}

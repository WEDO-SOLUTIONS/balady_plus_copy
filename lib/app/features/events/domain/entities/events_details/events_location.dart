

import 'package:dgis_map/library.dart';

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
          ? LatLng(latitude:double.tryParse(y ?? "")!, longitude:double.tryParse(x ?? "")!)
          : null;
}

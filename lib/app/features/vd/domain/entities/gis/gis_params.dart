import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GISParams extends Equatable {
  double x;
  double y;
  int? requestNo;

  GISParams({required this.x, required this.y, this.requestNo});

  @override
  List<Object?> get props => [x, y];

  LatLng getLatLng() {
    return LatLng(y, x);
  }

  double get lat => y;
  double get lon => x;

  factory GISParams.fromMap(Map<String, dynamic> json) {
    return GISParams(
      x: json["x"],
      y: json["y"],
    );
  }
  Map<String, dynamic> toMap() {
    return {"x": x, "y": y, if (requestNo != null) "reqNo": requestNo};
  }
}

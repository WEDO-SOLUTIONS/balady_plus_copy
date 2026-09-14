// import 'package:dgis_map/library.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';

class GISParams extends Equatable {
  final double x;
  final double y;
  final int? requestNo;

  const GISParams({required this.x, required this.y, this.requestNo});

  @override
  List<Object?> get props => [x, y];

  LatLng getLatLng() {
    return LatLng(latitude: y, longitude: x);
  }

  double get lat => y;
  double get lon => x;

  factory GISParams.fromMap(Map<String, dynamic> json) {
    return GISParams(x: json["x"], y: json["y"]);
  }
  Map<String, dynamic> toMap() {
    return {"x": x, "y": y, if (requestNo != null) "reqNo": requestNo};
  }
}

import 'package:dgis_map/library.dart';

extension CameraPositionMessageExt on CameraPositionMessage {
  CameraPositionMessage copyWith({
    GeoPointMessage? point,
    double? zoom,
    double? tilt,
    double? bearing,
  }) =>
      CameraPositionMessage(
        point: point ?? this.point,
        zoom: zoom ?? this.zoom,
        tilt: tilt ?? this.tilt,
        bearing: bearing ?? this.bearing,
      );
}

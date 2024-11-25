import 'package:flutter/foundation.dart';

@immutable
class PoiCameraConfig {
  final double? zoom;
  final double? tilt;
  final double? bearing;

  const PoiCameraConfig({
    this.zoom,
    this.tilt,
    this.bearing,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PoiCameraConfig && other.zoom == zoom && other.tilt == tilt && other.bearing == bearing;
  }

  @override
  int get hashCode => Object.hash(zoom, tilt, bearing);
}

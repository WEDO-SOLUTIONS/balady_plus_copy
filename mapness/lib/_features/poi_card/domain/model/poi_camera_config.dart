class PoiCameraConfig {

  PoiCameraConfig({
    this.zoom,
    this.tilt,
    this.bearing,
  });
  final double? zoom;
  final double? tilt;
  final double? bearing;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PoiCameraConfig &&
        other.zoom == zoom &&
        other.tilt == tilt &&
        other.bearing == bearing;
  }

  @override
  int get hashCode => Object.hash(zoom, tilt, bearing);

}

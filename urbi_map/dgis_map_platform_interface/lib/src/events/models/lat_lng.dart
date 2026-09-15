/// A point on the map.
class LatLng {
  /// Creates a point from its [latitude] and [longitude] in degrees.
  const LatLng({required this.latitude, required this.longitude});

  /// Degrees north of the equator.
  final double latitude;

  /// Degrees east of the prime meridian.
  final double longitude;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is LatLng && other.latitude == latitude && other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

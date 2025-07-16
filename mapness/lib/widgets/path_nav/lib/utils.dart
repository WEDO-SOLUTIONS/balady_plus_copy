/// Configuration constants for distance and duration calculations
class PathNavConfig {
  static const int maxDistanceDisplayLength = 5;
  static const double pedestrianSpeedKmh = 5.0;
  static const double metersPerKilometer = 1000.0;
  static const double minutesPerHour = 60.0;
  static const double millimetersPerMeter = 1000.0;
}

/// Formats distance string by removing decimal details for cleaner display.
///
/// Distance could be in format "1544.8" where "0.8" is details compared to "1544" km.
/// This function removes the decimal part to show cleaner distance values.
///
/// Examples:
/// - "1544.8" -> "1544"
/// - "2.5" -> "2.5" (unchanged if length <= 5)
/// - "1234,56" -> "1234" (handles comma delimiters)
String formatDistance(String distanceEtaKm) {
  if (distanceEtaKm.length > PathNavConfig.maxDistanceDisplayLength) {
    // Handle different locale delimiters (comma or period)
    final delimiter = distanceEtaKm.contains(',') ? ',' : '.';
    return distanceEtaKm.split(delimiter).first;
  }
  return distanceEtaKm;
}

/// Calculates walking duration in minutes based on distance.
///
/// Uses a standard walking speed of 5 km/h to estimate travel time.
///
/// [distanceMillimeters] - Distance in millimeters
/// Returns estimated walking time in minutes
int durationByFoot(int distanceMillimeters) {
  // Convert speed from km/h to meters per minute
  final speedInMetersPerMinute =
      PathNavConfig.pedestrianSpeedKmh * PathNavConfig.metersPerKilometer / PathNavConfig.minutesPerHour;

  // Convert distance from millimeters to meters
  final lengthInMeters = (distanceMillimeters / PathNavConfig.millimetersPerMeter).round();

  // Calculate time in minutes
  final timeInMinutes = lengthInMeters / speedInMetersPerMinute;
  return timeInMinutes.round();
}

/// Distance could be in format 1544.8 and 0.8 is details compare to 1544 km
/// So to show it right we have do throw away details
String formatDistance(String distanceEtaKm) {
  if (distanceEtaKm.length > 5) {
    // For different locales we can see that delimiter is comma or period
    final String delimiter = distanceEtaKm.contains(',') ? ',' : '.';
    return distanceEtaKm.split(delimiter).first;
  }
  return distanceEtaKm;
}
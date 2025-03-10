class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates({
    required this.latitude,
    required this.longitude,
  });

  const Coordinates.ltlg(this.latitude, this.longitude);

  static const Coordinates zero = Coordinates(latitude: 0, longitude: 0);
}

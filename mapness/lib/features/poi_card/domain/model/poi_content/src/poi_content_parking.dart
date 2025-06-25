/// [PoiContentParkingModel] is a model for the parking section of a POI card.
class PoiContentParkingModel {
  /// Title of the parking section
  final String title;

  /// Subtitle of the parking section
  final String? subtitle;

  /// Whether the parking is paid
  final bool isPaid;

  const PoiContentParkingModel({
    required this.title,
    this.subtitle,
    this.isPaid = false,
  });
}

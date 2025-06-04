class PoiContentParkingModel {
  final String title;
  final String? subtitle;
  final bool isPaid;

  const PoiContentParkingModel({
    required this.title,
    this.subtitle,
    this.isPaid = false,
  });
}

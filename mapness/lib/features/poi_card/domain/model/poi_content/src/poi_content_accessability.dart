/// [PoiContentAccessibilityModel] is a model for the accessibility section of a POI card.
class PoiContentAccessibilityModel {
  /// The title that the delivery available in the POI
  final String? deliveryAvailableTitle;

  /// The title that the serve disable persons in the POI
  final String? serveDisablePersonsTitle;

  const PoiContentAccessibilityModel({
    required this.deliveryAvailableTitle,
    this.serveDisablePersonsTitle,
  });
}

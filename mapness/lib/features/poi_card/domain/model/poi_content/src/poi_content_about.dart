/// [PoiContentAboutModel] is a model for the about section of a POI card.
class PoiContentAboutModel {
  /// The title of the about section.
  final String aboutTitle;

  /// The text about the POI
  final String text;

  /// The title of the show more button.
  final String showMoreTitle;

  /// The title of the show less button.
  final String showLessTitle;

  const PoiContentAboutModel({
    required this.aboutTitle,
    required this.text,
    required this.showMoreTitle,
    required this.showLessTitle,
  });
}

/// [PoiContentDataIncorrectModel] is a model for the feedback section of a POI card.
class PoiContentDataIncorrectModel {
  /// Callback for feedback tap
  final void Function()? onFeedbackTap;

  /// Title of the data incorrect section
  final String title;

  const PoiContentDataIncorrectModel({
    required this.title,
    this.onFeedbackTap,
  });
}

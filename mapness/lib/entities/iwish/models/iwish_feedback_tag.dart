class IwishFeedbackTag {
  const IwishFeedbackTag({
    required this.id,
    required this.displayName,
    required this.assetUrl,
    this.rtlAsset = false,
  });
  final String id;
  final String displayName;
  final String assetUrl;
  final bool rtlAsset;
}

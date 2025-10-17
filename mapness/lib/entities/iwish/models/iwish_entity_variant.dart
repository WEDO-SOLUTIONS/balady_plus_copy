class IwishEntityVariant {
  IwishEntityVariant({
    required this.id,
    required this.title,
    required this.preview,
    required this.photos,
  });
  final int id;
  final String title;
  final String preview;
  final List<String> photos;
}

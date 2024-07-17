class StoryThumbnailData {
  final String title;
  final String? imageUrl;

  const StoryThumbnailData({
    required this.title,
    this.imageUrl,
  });

  StoryThumbnailData copyWith({
    String? title,
    String? imageUrl,
  }) =>
      StoryThumbnailData(
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}

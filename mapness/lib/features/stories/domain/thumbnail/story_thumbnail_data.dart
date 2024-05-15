class StoryThumbnailData {
  StoryThumbnailData({
    required this.title,
    required this.imageUrl,
  });
  final String title;
  final String imageUrl;

  StoryThumbnailData copyWith({
    String? title,
    String? imageUrl,
  }) =>
      StoryThumbnailData(
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}

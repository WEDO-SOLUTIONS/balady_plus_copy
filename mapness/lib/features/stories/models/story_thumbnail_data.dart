class StoryThumbnailData {
  final String? imageUrl;
  final String? title;

  const StoryThumbnailData({
    this.imageUrl,
    this.title,
  });

  StoryThumbnailData copyWith({
    String? imageUrl,
    String? title,
  }) =>
      StoryThumbnailData(
        imageUrl: imageUrl ?? this.imageUrl,
        title: title ?? this.title,
      );
}

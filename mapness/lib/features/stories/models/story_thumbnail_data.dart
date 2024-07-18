class StoryThumbnailData {
  final String? imageUrl;

  const StoryThumbnailData({
    this.imageUrl,
  });

  StoryThumbnailData copyWith({
    String? imageUrl,
  }) =>
      StoryThumbnailData(
        imageUrl: imageUrl ?? this.imageUrl,
      );
}

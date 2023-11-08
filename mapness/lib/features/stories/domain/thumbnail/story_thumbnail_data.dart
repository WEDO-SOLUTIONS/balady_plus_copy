class StoryThumbnailData {
  final String title;
  final String imageUrl;

  StoryThumbnailData({
    required this.title,
    required this.imageUrl,
  });

  StoryThumbnailData copyWith({
    String? title,
    String? imageUrl,
  }) {
    return StoryThumbnailData(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

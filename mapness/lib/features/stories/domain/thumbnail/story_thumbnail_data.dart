class StoryThumbnailData {
  final String title;
  final String storyId;
  final String imageUrl;
  final bool isWatched;

  StoryThumbnailData({
    required this.storyId,
    required this.title,
    required this.imageUrl,
    required this.isWatched,
  });

  StoryThumbnailData copyWith({
    String? title,
    String? storyId,
    String? imageUrl,
    bool? isWatched,
  }) {
    return StoryThumbnailData(
      title: title ?? this.title,
      storyId: storyId ?? this.storyId,
      imageUrl: imageUrl ?? this.imageUrl,
      isWatched: isWatched ?? this.isWatched,
    );
  }
}

/// Represents the data for a story thumbnail.
///
/// The thumbnail is a small image that represents the story.
class StoryThumbnailData {
  final String? imageUrl;
  final String? title;

  /// Constructs a new [StoryThumbnailData] instance.
  const StoryThumbnailData({
    this.imageUrl,
    this.title,
  });

  /// Creates a copy of this [StoryThumbnailData] instance with the specified fields replaced.
  StoryThumbnailData copyWith({
    String? imageUrl,
    String? title,
  }) =>
      StoryThumbnailData(
        imageUrl: imageUrl ?? this.imageUrl,
        title: title ?? this.title,
      );
}

class StoryThumbnailData {
  final String title;
  final String imageUrl;
  final bool isWatched;
  final bool isLoading;

  StoryThumbnailData({
    required this.isLoading,
    required this.title,
    required this.imageUrl,
    required this.isWatched,
  });
}

/// Data model for story videos.
///
/// Supports both network URLs and local asset videos.
///
/// **Usage:**
/// ```dart
/// // Network video
/// StoryVideoData(url: 'https://example.com/video.mp4')
///
/// // Local asset video
/// StoryVideoData.asset('assets/videos/intro.mp4')
/// ```
class StoryVideoData {
  /// The URL or asset path of the video.
  final String url;

  /// Optional resolution hint (e.g., '1080p', '720p').
  final String? resolution;

  /// Whether [url] is a local asset path.
  ///
  /// When `true`, the video player will use `VideoPlayerController.asset()`
  /// instead of downloading from network.
  final bool isAsset;

  const StoryVideoData({
    required this.url,
    this.resolution,
    this.isAsset = false,
  });

  /// Creates a [StoryVideoData] for a local asset video.
  ///
  /// Example:
  /// ```dart
  /// StoryVideoData.asset('assets/balady-splashscreen.mp4')
  /// ```
  const StoryVideoData.asset(
    String assetPath, {
    this.resolution,
  })  : url = assetPath,
        isAsset = true;

  StoryVideoData copyWith({
    String? url,
    String? resolution,
    bool? isAsset,
  }) =>
      StoryVideoData(
        url: url ?? this.url,
        resolution: resolution ?? this.resolution,
        isAsset: isAsset ?? this.isAsset,
      );
}

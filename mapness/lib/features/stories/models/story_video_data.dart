class StoryVideoData {
  final String url;
  final String? resolution;

  const StoryVideoData({
    required this.url,
    this.resolution,
  });

  StoryVideoData copyWith({
    String? url,
    String? resolution,
  }) =>
      StoryVideoData(
        url: url ?? this.url,
        resolution: resolution ?? this.resolution,
      );
}

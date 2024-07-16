import 'dart:ui';

class StoryThumbnailData {
  final String title;
  final String imageUrl;
  final Color? linearTrackColor;
  final Color? animationColor;
  final Color? closeButtonColor;

  StoryThumbnailData({
    required this.title,
    required this.imageUrl,
    this.linearTrackColor,
    this.animationColor,
    this.closeButtonColor,
  });

  StoryThumbnailData copyWith({
    String? title,
    String? imageUrl,
    Color? linearTrackColor,
    Color? animationColor,
    Color? closeButtonColor,
  }) =>
      StoryThumbnailData(
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        linearTrackColor: linearTrackColor ?? this.linearTrackColor,
        animationColor: animationColor ?? this.animationColor,
        closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      );
}

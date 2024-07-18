import 'dart:ui';

class StoryThumbnailData {
  final String title;
  final String imageUrl;
  final Color? linearTrackColor;
  final Color? animationColor;
  final Color? closeButtonColor;
  final Color? iconColor;

  StoryThumbnailData({
    required this.title,
    required this.imageUrl,
    this.linearTrackColor,
    this.animationColor,
    this.closeButtonColor,
    this.iconColor,
  });

  StoryThumbnailData copyWith({
    String? title,
    String? imageUrl,
    Color? linearTrackColor,
    Color? animationColor,
    Color? closeButtonColor,
    Color? iconColor,
  }) =>
      StoryThumbnailData(
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        linearTrackColor: linearTrackColor ?? this.linearTrackColor,
        animationColor: animationColor ?? this.animationColor,
        closeButtonColor: closeButtonColor ?? this.closeButtonColor,
        iconColor: iconColor ?? this.iconColor,
      );
}

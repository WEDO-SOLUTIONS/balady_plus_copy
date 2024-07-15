import 'dart:ui';

class StoryThumbnailData {
  final String title;
  final String imageUrl;
  final Color? backgroundColor;
  final Color? animationColor;
  final Color? closeButtonColor;

  const StoryThumbnailData({
    required this.title,
    required this.imageUrl,
    this.backgroundColor,
    this.animationColor,
    this.closeButtonColor,
  });

  StoryThumbnailData copyWith({
    String? title,
    String? imageUrl,
    Color? backgroundColor,
    Color? animationColor,
    Color? closeButtonColor,
  }) =>
      StoryThumbnailData(
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        animationColor: animationColor ?? this.animationColor,
        closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      );
}

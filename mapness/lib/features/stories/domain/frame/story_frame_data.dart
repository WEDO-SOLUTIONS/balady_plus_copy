import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension StoryFrameDataX on StoryFrameData {
  String titleOrFailback(AppLocalizations locale) => switch (storyId) {
        'route1' => locale.whatCanTheNavigatorDo,
        'route2' => locale.theShortestRoute,
        'route3' => locale.focusOnTheRoad,
        _ => title,
      };

  String? descriptionOrFailback(AppLocalizations locale) => switch (storyId) {
        'route1' => locale.route1description,
        'route2' => locale.route2description,
        'route3' => locale.route3description,
        _ => description,
      };
}

class StoryFrameData {
  const StoryFrameData({
    required this.duration,
    required this.storyId,
    required this.isWatched,
    required this.title,
    required this.imageUrl,
    this.titleStyle,
    this.descriptionStyle,
    this.subtitle,
    this.description,
    this.action,
    this.isAssetImage = false,
  });
  final String storyId;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final String? description;
  final StoryTextStyle? titleStyle;
  final StoryTextStyle? descriptionStyle;
  final bool isWatched;
  final StoryFrameAction? action;
  final int duration;
  final bool? isAssetImage;

  StoryFrameData copyWith({
    String? storyId,
    String? title,
    String? imageUrl,
    String? subtitle,
    String? description,
    StoryTextStyle? titleStyle,
    StoryTextStyle? descriptionStyle,
    bool? isWatched,
    StoryFrameAction? action,
    int? duration,
    bool? isAssetImage,
  }) =>
      StoryFrameData(
        isAssetImage: isAssetImage ?? this.isAssetImage,
        storyId: storyId ?? this.storyId,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        subtitle: subtitle ?? this.subtitle,
        description: description ?? this.description,
        titleStyle: titleStyle ?? this.titleStyle,
        descriptionStyle: descriptionStyle ?? this.descriptionStyle,
        isWatched: isWatched ?? this.isWatched,
        action: action ?? this.action,
        duration: duration ?? this.duration,
      );
}

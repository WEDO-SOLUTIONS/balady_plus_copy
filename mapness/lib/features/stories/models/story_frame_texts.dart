import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Represents the texts for a story frame.
class StoryFrameTexts {
  final String title;
  final String? subTitle;
  final String? description;

  /// Constructs a [StoryFrameTexts] instance.
  StoryFrameTexts({
    required this.title,
    this.description,
    this.subTitle,
  });

  /// Constructs a [StoryFrameTexts] instance from an ID.
  factory StoryFrameTexts.fromId(AppLocalizations l10n, String id) => StoryFrameTexts(
        title: _titleFromId(l10n, id),
        subTitle: l10n.theShortestRoute,
        description: _descriptionFromId(l10n, id),
      );

  /// Retrieves the title based on the ID.
  static String _titleFromId(AppLocalizations l10n, String id) => switch (id) {
        'route1' => l10n.whatCanTheNavigatorDo,
        'route2' => l10n.theShortestRoute,
        'route3' => l10n.focusOnTheRoad,
        'onboarding1' => l10n.onboardingBaladyAppTitle,
        'onboarding2' => l10n.onboardingRoutesTitle,
        'onboarding3' => l10n.onboardingCapabilitiesTitle,
        _ => 'No title',
      };

  /// Retrieves the description based on the ID.
  static String? _descriptionFromId(AppLocalizations l10n, String id) => switch (id) {
        'route1' => l10n.route1description,
        'route2' => l10n.route2description,
        'route3' => l10n.route3description,
        'onboarding1' => l10n.onboardingBaladyAppDescription,
        'onboarding2' => l10n.onboardingRoutesDescription,
        'onboarding3' => l10n.onboardingCapabilitiesDescription,
        _ => null,
      };

  /// Retrieves the thumbnail text based on the story type.
  static String thumbnailTextFromType(AppLocalizations l10n, StoryTypes type) =>
      type == StoryTypes.route ? 'Route' : 'Onboarding';

  /// Creates a copy of this [StoryFrameTexts] instance with the specified fields replaced.
  StoryFrameTexts copyWith({
    String? title,
    String? subTitle,
    String? description,
  }) =>
      StoryFrameTexts(
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        description: description ?? this.description,
      );
}

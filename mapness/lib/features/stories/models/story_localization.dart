// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

class StoryFrameTexts {
  final String title;
  final String? subTitle;
  final String? description;

  StoryFrameTexts({
    required this.title,
    this.description,
    this.subTitle,
  });

  factory StoryFrameTexts.fromId(AppLocalizations l10n, String id) => StoryFrameTexts(
        title: _titleFromId(l10n, id),
        subTitle: l10n.theShortestRoute,
        description: _descriptionFromId(l10n, id),
      );
  static String _titleFromId(AppLocalizations l10n, String id) => switch (id) {
        'route1' => l10n.whatCanTheNavigatorDo,
        'route2' => l10n.theShortestRoute,
        'route3' => l10n.focusOnTheRoad,
        'onboarding1' => l10n.onboardingBaladyAppTitle,
        'onboarding2' => l10n.onboardingRoutesTitle,
        'onboarding3' => l10n.onboardingCapabilitiesTitle,
        _ => 'No title',
      };
  static String? _descriptionFromId(AppLocalizations l10n, String id) => switch (id) {
        'route1' => l10n.route1description,
        'route2' => l10n.route2description,
        'route3' => l10n.route3description,
        'onboarding1' => l10n.onboardingBaladyAppDescription,
        'onboarding2' => l10n.onboardingRoutesDescription,
        'onboarding3' => l10n.onboardingCapabilitiesDescription,
        _ => null,
      };
  static String thumbnailTextFromType(AppLocalizations l10n, StoryTypes type) =>
      type == StoryTypes.route ? 'Route' : 'Onboarding';

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

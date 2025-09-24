import 'dart:ui';

import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Represents the texts for a story frame.
class StoryFrameTexts {
  final String title;
  final String? subTitle;
  final String? description;
  final TextAlign? titleAlign;

  /// Constructs a [StoryFrameTexts] instance.
  const StoryFrameTexts({
    required this.title,
    this.description,
    this.subTitle,
    this.titleAlign,
  });

  /// Constructs a [StoryFrameTexts] instance from an ID.
  factory StoryFrameTexts.fromId(AppLocalizations l10n, String id) => StoryFrameTexts(
        title: _titleFromId(l10n, id),
        description: _descriptionFromId(l10n, id),
        titleAlign: _titleAlignFromId(l10n, id),
        subTitle: _subTitleFromId(l10n, id),
      );

  static String? _subTitleFromId(AppLocalizations l10n, String id) => switch (id) {
        'saudiDay' => l10n.saudiDayTitle.split(RegExp(r'[,\u060C]')).last,
        _ => null,
      };

  /// Retrieves the title based on the ID.
  static String _titleFromId(AppLocalizations l10n, String id) => switch (id) {
        'route1' => l10n.whatCanTheNavigatorDo,
        'route2' => l10n.theShortestRoute,
        'route3' => l10n.focusOnTheRoad,
        // TODO: After release delete next keys from localyze
        // onboardingBaladyAppTitle, onboardingRoutesTitle, onboardingCapabilitiesTitle
        // This keys is deprecated and should be removed after release
        'onboarding1' => l10n.onboarding1Title,
        'onboarding2' => l10n.onboarding2Title,
        'onboarding3' => l10n.onboarding3Title,
        'saudiDay' => () {
            final text = l10n.saudiDayTitle;
            final match = RegExp(r'[,\u060C]').firstMatch(text);
            final separator = match?.group(0) ?? '';
            final firstPart = text.split(RegExp(r'[,\u060C]')).first;
            return '$firstPart$separator';
          }(),
        _ => 'No title',
      };

  /// Retrieves the description based on the ID.
  static String? _descriptionFromId(AppLocalizations l10n, String id) => switch (id) {
        'route1' => l10n.route1description,
        'route2' => l10n.route2description,
        'route3' => l10n.route3description,
        // TODO: After release delete next keys from localyze
        // onboardingBaladyAppDescription, onboardingRoutesDescription, onboardingCapabilitiesDescription
        // This keys is deprecated and should be removed after release
        'onboarding1' => l10n.onboarding1Description,
        'onboarding2' => l10n.onboarding2Description,
        'onboarding3' => l10n.onboarding3Description,
        _ => null,
      };

  /// Retrieves the title align based on the ID.
  static TextAlign? _titleAlignFromId(AppLocalizations l10n, String id) => switch (id) {
        'saudiDay' => TextAlign.center,
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

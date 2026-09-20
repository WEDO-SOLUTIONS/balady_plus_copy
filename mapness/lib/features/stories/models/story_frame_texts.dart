import 'dart:ui';

import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Represents the texts for a story frame.
class StoryFrameTexts {
  final String title;
  final String? description;
  final TextAlign? titleAlign;

  /// Upper bound on title lines. When set, the title shrinks to fit within
  /// that many lines instead of wrapping past them — for titles typeset as a
  /// fixed number of lines (see [_saudiDayTitle]).
  final int? titleMaxLines;

  /// Constructs a [StoryFrameTexts] instance.
  const StoryFrameTexts({
    required this.title,
    this.description,
    this.titleAlign,
    this.titleMaxLines,
  });

  /// Constructs a [StoryFrameTexts] instance from an ID.
  factory StoryFrameTexts.fromId(AppLocalizations l10n, String id) => StoryFrameTexts(
    title: _titleFromId(l10n, id),
    description: _descriptionFromId(l10n, id),
    titleAlign: _titleAlignFromId(l10n, id),
    titleMaxLines: _titleMaxLinesFromId(id),
  );

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
    'saudiDay' => _saudiDayTitle(l10n),
    _ => 'No title',
  };

  /// The National Day title is typeset as two short centred lines, and the
  /// translations carry the line break themselves. Rendering it as a single
  /// text keeps both lines centred with the font's own line spacing —
  /// splitting it into two widgets (as before) left the second line
  /// start-aligned (right-hugging in Arabic) and a full title padding away
  /// from the first.
  ///
  /// If a translator drops the break, fall back to breaking after the first
  /// comma (Latin or Arabic) so it still reads as two lines.
  static String _saudiDayTitle(AppLocalizations l10n) {
    final text = l10n.saudiDayTitle.trim();
    if (text.contains('\n')) {
      return text;
    }

    final match = RegExp(r'[,،]').firstMatch(text);
    if (match == null) {
      return text;
    }

    final head = text.substring(0, match.end).trimRight();
    final tail = text.substring(match.end).trim();
    return tail.isEmpty ? head : '$head\n$tail';
  }

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

  /// Retrieves the title line limit based on the ID.
  static int? _titleMaxLinesFromId(String id) => switch (id) {
    'saudiDay' => 2,
    _ => null,
  };

  /// Retrieves the thumbnail text based on the story type.
  static String thumbnailTextFromType(AppLocalizations l10n, StoryTypes type) =>
      type == StoryTypes.route ? 'Route' : 'Onboarding';

  /// Creates a copy of this [StoryFrameTexts] instance with the specified fields replaced.
  StoryFrameTexts copyWith({
    String? title,
    String? description,
    TextAlign? titleAlign,
    int? titleMaxLines,
  }) => StoryFrameTexts(
    title: title ?? this.title,
    description: description ?? this.description,
    titleAlign: titleAlign ?? this.titleAlign,
    titleMaxLines: titleMaxLines ?? this.titleMaxLines,
  );
}

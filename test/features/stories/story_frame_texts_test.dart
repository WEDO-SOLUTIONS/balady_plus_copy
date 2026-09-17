import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/stories/models/story_frame_texts.dart';
import 'package:mapness/l10n/generated/app_localizations_ar.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';

/// Simulates a translator dropping the line break from the English title.
class _EnglishWithoutBreak extends AppLocalizationsEn {
  @override
  String get saudiDayTitle => 'With values set to guide our way, we scale new heights every day';
}

/// Simulates a translator dropping the line break from the Arabic title.
class _ArabicWithoutBreak extends AppLocalizationsAr {
  @override
  String get saudiDayTitle => 'دلالتنا إرثٌ وقيمٌ، ووجهتنا قمم';
}

void main() {
  group('StoryFrameTexts saudiDay title', () {
    for (final (name, l10n) in [('en', AppLocalizationsEn()), ('ar', AppLocalizationsAr())]) {
      test('$name: is one centred title of exactly two lines, with no separate subtitle', () {
        final texts = StoryFrameTexts.fromId(l10n, 'saudiDay');

        expect(texts.title, l10n.saudiDayTitle.trim(), reason: 'the translation is rendered as-is');
        expect('\n'.allMatches(texts.title).length, 1, reason: 'exactly two lines');
        expect(texts.title.split('\n').every((line) => line.trim().isNotEmpty), isTrue);
        expect(texts.titleAlign, TextAlign.center);
        expect(texts.titleMaxLines, 2, reason: 'shrinks to fit rather than wrapping past two lines');
        expect(texts.description, isNull);
      });
    }

    test('falls back to breaking after the Latin comma when the translation has no line break', () {
      final texts = StoryFrameTexts.fromId(_EnglishWithoutBreak(), 'saudiDay');

      expect(texts.title, 'With values set to guide our way,\nwe scale new heights every day');
    });

    test('falls back to breaking after the Arabic comma when the translation has no line break', () {
      final texts = StoryFrameTexts.fromId(_ArabicWithoutBreak(), 'saudiDay');

      expect(texts.title, 'دلالتنا إرثٌ وقيمٌ،\nووجهتنا قمم');
    });
  });
}

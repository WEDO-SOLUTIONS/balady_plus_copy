import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/providers/app_language.dart';

// TODO(Sergei): remove rubrics and rename to QuickSearch when quick search feature is approved
enum QuickFilter {
  eatOut,
  mosques,
  markets,
  hotels,
  fuel,
}

sealed class QuickFilterBase {
  const QuickFilterBase();

  List<QuickFilter> get list;
}

class QuickFilterList extends QuickFilterBase {
  @override
  List<QuickFilter> get list => QuickFilter.values;
}

class NaviQuickFilterList extends QuickFilterBase {
  @override
  List<QuickFilter> get list => [
        QuickFilter.eatOut,
        QuickFilter.mosques,
        QuickFilter.markets,
        QuickFilter.hotels,
        QuickFilter.fuel,
      ];
}

extension QuickFilterExtension on QuickFilter {
  String title(AppLocalizations locale, {bool isShort = false}) => switch (this) {
        QuickFilter.mosques => locale.mosques,
        QuickFilter.fuel => locale.fuel,
        QuickFilter.hotels => locale.hotels,
        QuickFilter.markets => locale.market,
        QuickFilter.eatOut => locale.eatOut,
      };

  IconData? get icon => switch (this) {
        QuickFilter.eatOut => PlacesIcons.restaurant,
        QuickFilter.mosques => PlacesIcons.mosques,
        QuickFilter.markets => PlacesIcons.markets,
        QuickFilter.hotels => PlacesIcons.hotels,
        QuickFilter.fuel => PlacesIcons.gasstation,
      };

  MapMarkersType? get markerType => switch (this) {
        QuickFilter.eatOut => MapMarkersType.restaurants,
        QuickFilter.mosques => MapMarkersType.mosques,
        QuickFilter.markets => MapMarkersType.markets,
        QuickFilter.hotels => MapMarkersType.hotels,
        QuickFilter.fuel => MapMarkersType.gasStation,
      };

  Map<Language, String> get query => switch (this) {
        QuickFilter.mosques => {
            Language.english: 'Mosques',
            Language.arabic: 'المساجد',
          },
        QuickFilter.fuel => {
            Language.english: 'Fuel',
            Language.arabic: 'وقود',
          },
        QuickFilter.hotels => {
            Language.english: 'Hotels',
            Language.arabic: 'فنادق',
          },
        QuickFilter.markets => {
            Language.english: 'Market',
            Language.arabic: 'سوق',
          },
        QuickFilter.eatOut => {
            Language.english: 'Eat out',
            Language.arabic: 'تناول الطعام بالخارج',
          },
      };

  List<int> get rubrics => switch (this) {
        QuickFilter.mosques => const [13374],
        QuickFilter.fuel => const [18547],
        QuickFilter.hotels => const [269],
        QuickFilter.eatOut => const [161, 165, 161, 9786, 162, 469, 58871],
        QuickFilter.markets => const [
            112589,
            361,
            12127,
            47633,
            67763,
            363,
            110485,
            557,
            469,
            3232,
            562,
            712,
            564,
            5843,
            558,
            112589,
            561,
            376,
            611,
            10904,
            544,
            398,
          ],
      };
}

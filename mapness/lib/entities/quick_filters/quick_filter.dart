import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/providers/app_language.dart';

// TODO(Sergei): remove rubrics and rename to QuickSearch when quick search feature is approved
enum QuickFilter {
  eatOut,
  markets,
  hotels,
  mosques,
  gasStation,
  carServices,
  hospitals,
  dentalCenters,
  pharmacies,
  sportClubs,
  parks,
  recreationCenters,
  beauty,
  barbershops,
  schools,
  shopping,
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
        QuickFilter.gasStation,
        QuickFilter.eatOut,
        QuickFilter.markets,
        QuickFilter.hotels,
        QuickFilter.mosques,
      ];
}

extension QuickFilterExtension on QuickFilter {
  String title(AppLocalizations locale, {bool isShort = false}) => switch (this) {
        QuickFilter.mosques => locale.mosques,
        QuickFilter.gasStation => isShort ? locale.fuel : locale.gasStations,
        QuickFilter.parks => locale.parks,
        QuickFilter.hospitals => locale.hospitals,
        QuickFilter.schools => locale.schools,
        QuickFilter.pharmacies => locale.pharmacies,
        QuickFilter.dentalCenters => locale.dentalCenters,
        QuickFilter.hotels => locale.hotels,
        QuickFilter.beauty => locale.beauty,
        QuickFilter.recreationCenters => locale.recreationalCenters,
        QuickFilter.sportClubs => locale.sportClubs,
        QuickFilter.carServices => locale.carServices,
        QuickFilter.markets => isShort ? locale.market : locale.markets,
        QuickFilter.eatOut => locale.eatOut,
        QuickFilter.barbershops => locale.barbershops,
        QuickFilter.shopping => locale.placesToShop,
      };

  IconData? get icon => switch (this) {
        QuickFilter.mosques => PlacesIcons.mosques,
        QuickFilter.gasStation => PlacesIcons.gasstation,
        QuickFilter.hotels => PlacesIcons.hotels,
        QuickFilter.markets => PlacesIcons.markets,
        QuickFilter.eatOut => PlacesIcons.restaurant,
        _ => null,
      };

  MapMarkersType? get markerType => switch (this) {
        QuickFilter.mosques => MapMarkersType.mosques,
        QuickFilter.gasStation => MapMarkersType.gasStation,
        QuickFilter.parks => MapMarkersType.parks,
        QuickFilter.hospitals => MapMarkersType.hospitals,
        QuickFilter.schools => MapMarkersType.schools,
        QuickFilter.pharmacies => MapMarkersType.pharmacies,
        QuickFilter.dentalCenters => MapMarkersType.dentalCenters,
        QuickFilter.hotels => MapMarkersType.hotels,
        QuickFilter.sportClubs => MapMarkersType.gym,
        QuickFilter.carServices => MapMarkersType.carServices,
        QuickFilter.markets => MapMarkersType.markets,
        QuickFilter.eatOut => MapMarkersType.restaurants,
        QuickFilter.shopping => MapMarkersType.shopping,
        QuickFilter.beauty => MapMarkersType.beauty,
        QuickFilter.barbershops => MapMarkersType.barbershops,
        QuickFilter.recreationCenters => MapMarkersType.recreationCenters,
        _ => null,
      };

  Map<Language, String> get query => switch (this) {
        QuickFilter.mosques => {
            Language.english: 'Mosques',
            Language.arabic: 'مساجد',
          },
        QuickFilter.gasStation => {
            Language.english: 'Gas stations',
            Language.arabic: 'محطات وقود',
          },
        QuickFilter.parks => {
            Language.english: 'Parks',
            Language.arabic: 'حدائق',
          },
        QuickFilter.hospitals => {
            Language.english: 'Hospitals',
            Language.arabic: 'مستشفيات',
          },
        QuickFilter.schools => {
            Language.english: 'Schools',
            Language.arabic: 'مدارس',
          },
        QuickFilter.pharmacies => {
            Language.english: 'Pharmacies',
            Language.arabic: 'صيدليات',
          },
        QuickFilter.dentalCenters => {
            Language.english: 'Dental centers',
            Language.arabic: 'عيادات طب الأسنان',
          },
        QuickFilter.hotels => {
            Language.english: 'Hotels',
            Language.arabic: 'فنادق',
          },
        QuickFilter.sportClubs => {
            Language.english: 'Sport clubs',
            Language.arabic: 'اللياقة البدنية',
          },
        QuickFilter.carServices => {
            Language.english: 'Car service centers',
            Language.arabic: 'تصليح وصيانة مركبات',
          },
        QuickFilter.markets => {
            Language.english: 'Markets',
            Language.arabic: 'أسواق',
          },
        QuickFilter.eatOut => {
            Language.english: 'Eat out',
            Language.arabic: 'مطاعم',
          },
        QuickFilter.recreationCenters => {
            Language.english: 'Recreation centers',
            Language.arabic: 'مراكز ترفيهية',
          },
        QuickFilter.beauty => {
            Language.english: 'Beauty',
            Language.arabic: 'صالونات التجميل',
          },
        QuickFilter.barbershops => {
            Language.english: 'Barbershops',
            Language.arabic: 'صالونات حلاقة رجالية',
          },
        QuickFilter.shopping => {
            Language.english: 'Shopping centers',
            Language.arabic: 'مراكز تسوق',
          },
      };

  List<int> get rubrics => switch (this) {
        QuickFilter.mosques => const [13374],
        QuickFilter.gasStation => const [18547],
        QuickFilter.hospitals => const [201],
        QuickFilter.schools => const [245],
        QuickFilter.pharmacies => const [207],
        QuickFilter.dentalCenters => const [222],
        QuickFilter.hotels => const [269],
        QuickFilter.eatOut => const [161, 165, 161, 9786, 162, 469, 58871],
        QuickFilter.barbershops => const [110352],
        QuickFilter.beauty => const [
            56759,
            110351,
            382,
            4521,
            4517,
            5603,
            651,
            58858,
            4518,
            652,
            13726,
            110355,
            13102,
            53986,
            695,
            51009,
          ],
        QuickFilter.recreationCenters => const [
            537,
            169,
            169,
            170,
            110358,
            51001,
            24472,
            173,
            110300,
            630,
            110388,
            110358,
            190,
            110358
          ],
        QuickFilter.sportClubs => const [
            261,
            262,
            266,
            267,
            268,
            309,
            633,
            634,
            696,
            764,
            20228,
            51241,
            51256,
            110498,
          ],
        QuickFilter.carServices => const [
            404,
            405,
            409,
            414,
            425,
            427,
            524,
            1141,
            3237,
            4532,
            7689,
            7691,
            7692,
            7693,
            7694,
            7695,
            7697,
            7757,
            8466,
            9041,
            9867,
            10792,
            18630,
            20989,
            54884,
            110301,
            110302,
            110482,
            18436,
            103524,
            417,
            428,
            431,
            18974,
            418,
            721,
            429,
            1156,
          ],
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
        QuickFilter.parks => const [],
        QuickFilter.shopping => const [],
      };
}

import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/shared/providers/app_language.dart';

enum QuickFilterType {
  restaurants,
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
  beautyCenters,
  salons,
  schools,
}

const quickFilters = [
  QuickFilter(
    type: QuickFilterType.restaurants,
    query: {
      Language.english: 'Restaurants',
      Language.arabic: 'المطاعم'
    },
    rubrics: [161, 165, 161, 9786, 162, 469, 58871],
  ),
  QuickFilter(
    type: QuickFilterType.markets,
    query: {
      Language.english: 'Markets',
      Language.arabic: 'الأسواق'
    },
    rubrics: [
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
  ),
  QuickFilter(
    type: QuickFilterType.hotels,
    query: {
      Language.english: 'Hotels',
      Language.arabic: 'الفنادق'
    },
    rubrics: [269],
  ),
  QuickFilter(
    type: QuickFilterType.mosques,
    query: {
      Language.english: 'Mosques',
      Language.arabic: 'المساجد'
    },
    rubrics: [13374],
  ),
  QuickFilter(
    type: QuickFilterType.gasStation,
    query: {
      Language.english: 'Gas stations',
      Language.arabic: 'محطات الوقود'
    },
    rubrics: [18547],
  ),
  QuickFilter(
    type: QuickFilterType.carServices,
    query: {
      Language.english: 'Car services',
      Language.arabic: 'خدمات السيارات'
    },
    rubrics: [
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
  ),
  QuickFilter(
    type: QuickFilterType.hospitals,
    query: {
      Language.english: 'Hospitals',
      Language.arabic: 'المستشفيات'
    },
    rubrics: [201],
  ),
  QuickFilter(
    type: QuickFilterType.dentalCenters,
    query: {
      Language.english: 'Dental centers',
      Language.arabic: 'مراكز طب الأسنان'
    },
    rubrics: [222],
  ),
  QuickFilter(
    type: QuickFilterType.pharmacies,
    query: {
      Language.english: 'Pharmacies',
      Language.arabic: 'الصيدليات'
    },
    rubrics: [207],
  ),
  QuickFilter(
    type: QuickFilterType.sportClubs,
    query: {
      Language.english: 'Sport clubs',
      Language.arabic: 'الأندية الرياضية'
    },
    rubrics: [
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
  ),
  QuickFilter(
    type: QuickFilterType.parks,
    query: {
      Language.english: 'Parks',
      Language.arabic: 'الحدائق'
    },
    rubrics: [],
  ),
  QuickFilter(
    type: QuickFilterType.recreationCenters,
    query: {
      Language.english: 'Recreation centers',
      Language.arabic: 'مراكز الترفيه'
    },
    rubrics: [
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
      110358,
    ],
  ),
  QuickFilter(
    type: QuickFilterType.beautyCenters,
    query: {
      Language.english: 'Beauty centers',
      Language.arabic: 'مراكز التجميل'
    },
    rubrics: [
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
  ),
  QuickFilter(
    type: QuickFilterType.salons,
    query: {
      Language.english: 'Salons',
      Language.arabic: 'الصالونات'
    },
    rubrics: [110352],
  ),
  QuickFilter(
    type: QuickFilterType.schools,
    query: {
      Language.english: 'Schools',
      Language.arabic: 'المدارس'
    },
    rubrics: [245],
  ),
];

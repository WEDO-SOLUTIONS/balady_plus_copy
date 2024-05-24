import 'package:mapness/features/quick_filters/providers/quick_filters_data.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension QuickFilterExtension on QuickFilter {
  String title(AppLocalizations locale) => switch (query) {
        'beaches' => locale.beaches,
        'parks' => locale.parks,
        _ => switch (type) {
            QuickFilterType.mosques => locale.mosques,
            QuickFilterType.gasStation => locale.gasStations,
            QuickFilterType.parks => locale.parks,
            QuickFilterType.hospitals => locale.hospitals,
            QuickFilterType.schools => locale.schools,
            QuickFilterType.pharmacies => locale.pharmacies,
            QuickFilterType.dentalCenters => locale.dentalCenters,
            QuickFilterType.hotels => locale.hotels,
            QuickFilterType.beautyCenters => locale.beautyCenters,
            QuickFilterType.recreationCenters => locale.recreationalCenters,
            QuickFilterType.sportClubs => locale.sportClubs,
            QuickFilterType.carServices => locale.carServices,
            QuickFilterType.markets => locale.markets,
            QuickFilterType.restaurants => locale.restaurants,
            QuickFilterType.salons => locale.salons,
          },
      };
}

class QuickFilter {
  final QuickFilterType type;
  final String? query;
  final List<int> rubrics;
  final String uiIcon;
  final String mapIcon;

  const QuickFilter({
    required this.type,
    required this.rubrics,
    required this.uiIcon,
    required this.mapIcon,
    this.query,
  });
}

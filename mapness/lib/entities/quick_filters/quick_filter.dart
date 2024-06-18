import 'package:mapness/features/quick_filters/providers/quick_filters_data.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/providers/app_language.dart';

// TODO(Sergei): remove rubrics and rename to QuickSearch when quick search feature is approved
class QuickFilter {
  final QuickFilterType type;
  final Map<Language, String> query;
  final List<int> rubrics;

  const QuickFilter({
    required this.type,
    required this.rubrics,
    required this.query,
  });
}

extension QuickFilterExtension on QuickFilter {
  String title(AppLocalizations locale) => switch (type) {
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
      };

  MapMarkersType? get markerType => switch (type) {
        QuickFilterType.mosques => MapMarkersType.mosques,
        QuickFilterType.gasStation => MapMarkersType.gasStation,
        QuickFilterType.parks => MapMarkersType.parks,
        QuickFilterType.hospitals => MapMarkersType.hospitals,
        QuickFilterType.schools => MapMarkersType.schools,
        QuickFilterType.pharmacies => MapMarkersType.pharmacies,
        QuickFilterType.dentalCenters => MapMarkersType.dentalCenters,
        QuickFilterType.hotels => MapMarkersType.hotels,
        QuickFilterType.sportClubs => MapMarkersType.gym,
        QuickFilterType.carServices => MapMarkersType.carServices,
        QuickFilterType.markets => MapMarkersType.markets,
        QuickFilterType.restaurants => MapMarkersType.restaurants,
        _ => null,
      };
}

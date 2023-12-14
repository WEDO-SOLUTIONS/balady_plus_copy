import 'package:mapness/l10n/generated/app_localizations.dart';

extension QuickFilterExtension on QuickFilter {
  String titleOrFailback(AppLocalizations locale) {
    return switch (query) {
      'beach' => locale.beaches,
      _ => rubrics.isEmpty
          ? title
          : switch (rubrics.first) {
              13374 => locale.mosques,
              18547 => locale.gasStations,
              168 => locale.parks,
              201 => locale.hospitals,
              245 => locale.schools,
              207 => locale.pharmacies,
              222 => locale.dentalCenters,
              269 => locale.hotels,
              56759 => locale.beautyCenters,
              537 => locale.recreationalCenters,
              261 => locale.sportClubs,
              404 => locale.carServices,
              112589 => locale.markets,
              _ => title,
            },
    };
  }
}

class QuickFilter {
  QuickFilter({
    required this.rubrics,
    required this.title,
    required this.uiIcon,
    required this.mapIcon,
    this.query,
  });

  final String? query;
  final List<int> rubrics;
  final String title;
  final String uiIcon;
  final String mapIcon;
}

import 'package:mapness/l10n/generated/app_localizations.dart';

extension QuickFilterExtension on QuickFilter {
  String titleOrFailback(AppLocalizations locale) {
    return switch (rubrics.first) {
      13374 => locale.mosques,
      18547 => locale.gasStations,
      168 => locale.parks,
      201 => locale.hospitals,
      245 => locale.schools,
      207 => locale.pharmacies,
      222 => locale.dentalCenters,
      _ => title,
    };
  }
}

class QuickFilter {
  QuickFilter({
    required this.rubrics,
    required this.title,
    required this.uiIcon,
    required this.mapIcon,
  });

  final List<int> rubrics;
  final String title;
  final String uiIcon;
  final String mapIcon;
}

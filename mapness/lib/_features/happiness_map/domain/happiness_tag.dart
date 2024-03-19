import 'package:mapness/l10n/generated/app_localizations.dart';

extension HappinessTagX on HappinessTag {
  String titleOrFallback(AppLocalizations locale) => switch (code) {
        'visual_aesthetic' => locale.visualAesthetic,
        'parks' => locale.parks,
        'buildings' => locale.buildings,
        'streets' => locale.streets,
        'comfort' => locale.comfort,
        'lighting' => locale.lightning,
        'cleanness' => locale.clean,
        _ => title,
      };
}

class HappinessTag {

  HappinessTag({
    required this.code,
    required this.title,
    required this.iconAsset,
  });
  final String code;
  final String title;
  final String iconAsset;
}

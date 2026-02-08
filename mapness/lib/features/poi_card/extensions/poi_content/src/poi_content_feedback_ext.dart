import 'dart:ui';

import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_feedback.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension PoiContentFeedbackExt on PoiContentFeedbackType {
  String title(AppLocalizations l10n) => switch (this) {
        PoiContentFeedbackType.addPlace => l10n.addPlace,
        PoiContentFeedbackType.addPhoto => l10n.addPhotoPOICardTitle,
        PoiContentFeedbackType.cityExpert => l10n.cityExpert,
      };

  String subtitle(AppLocalizations l10n) => switch (this) {
        PoiContentFeedbackType.addPlace => l10n.addNewPlace,
        PoiContentFeedbackType.addPhoto => l10n.addPhotosDescription,
        PoiContentFeedbackType.cityExpert => l10n.cityExpertDescription,
      };

  String get path => switch (this) {
        PoiContentFeedbackType.addPlace => Assets.images.addCompany.keyName,
        PoiContentFeedbackType.addPhoto => Assets.images.addPhoto.keyName,
        PoiContentFeedbackType.cityExpert =>
          SaudiNationalDay.isNow() ? Assets.images.cityExpertSaudiDay.keyName : Assets.images.cityExpert.keyName
      };

  List<Color> get gradientColors => switch (this) {
        PoiContentFeedbackType.addPlace => const [Color(0xFF9F6AD7), Color(0xFF7035AF)],
        PoiContentFeedbackType.addPhoto => const [Color(0xFF396372), Color(0xFF013449)],
        PoiContentFeedbackType.cityExpert => SaudiNationalDay.isNow()
            ? const [Color(0xFF008A4A), Color(0xFF00542B)]
            : const [Color(0xFF3AB7AE), Color(0xFF238A82)],
      };
}

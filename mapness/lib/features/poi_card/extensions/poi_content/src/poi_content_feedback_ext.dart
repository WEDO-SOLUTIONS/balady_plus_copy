import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/city_event/city_event.dart';
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

  String pathBuilder(CityEventType? activeCityEvent) => switch (this) {
    PoiContentFeedbackType.addPlace => switch (activeCityEvent) {
      CityEventType.foundingDay => Assets.images.addCompanyFoundingDay.keyName,
      _ => Assets.images.addCompany.keyName,
    },
    PoiContentFeedbackType.addPhoto => switch (activeCityEvent) {
      CityEventType.foundingDay => Assets.images.addPhotoFoundingDay.keyName,
      _ => Assets.images.addPhoto.keyName,
    },
    PoiContentFeedbackType.cityExpert => switch (activeCityEvent) {
      CityEventType.saudiNationalDay => Assets.images.cityExpertSaudiDay.keyName,
      CityEventType.foundingDay => Assets.images.cityExpertFoundingDay.keyName,
      _ => Assets.images.cityExpert.keyName,
    },
  };

  List<Color> gradientColorsBuilder(BuildContext context, CityEventType? activeCityEvent) => switch (this) {
    PoiContentFeedbackType.addPlace => switch (activeCityEvent) {
      CityEventType.foundingDay => const [
        Color(0xFFB28F64),
        Color(0xFF846743),
      ],
      _ => [context.colors.accentMuted, context.colors.accentDefault],
    },
    PoiContentFeedbackType.addPhoto => switch (activeCityEvent) {
      CityEventType.foundingDay => const [
        Color(0xFFB28F64),
        Color(0xFF846743),
      ],
      _ => [context.colors.accentMuted, context.colors.accentDefault], //const [Color(0xFF396372), Color(0xFF013449)],
    },
    PoiContentFeedbackType.cityExpert => switch (activeCityEvent) {
      CityEventType.saudiNationalDay => const [Color(0xFF008A4A), Color(0xFF00542B)],
      CityEventType.foundingDay => const [
        Color(0xFFB28F64),
        Color(0xFF846743),
      ],
      _ => [context.colors.accentMuted, context.colors.accentDefault], //const [Color(0xFF3AB7AE), Color(0xFF238A82)],
    },
  };
}

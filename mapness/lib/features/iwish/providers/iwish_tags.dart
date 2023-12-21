import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_feedback_tag.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

List<IwishFeedbackTag> iwishTags(AppLocalizations l10n, ParkSize parkSize) {
  return switch (parkSize) {
    ParkSize.small => [
        ("play_ground", l10n.iwish_play_ground),
        ("free_area", l10n.iwish_free_area),
        ("sport_court", l10n.iwish_sport_court),
        ("green_spaces", l10n.iwish_green_spaces),
      ],
    ParkSize.medium => [
        ("play_ground", l10n.iwish_play_ground),
        ("outdoor_club", l10n.iwish_outdoor_club),
        ("sport_court", l10n.iwish_sport_court),
        ("running", l10n.iwish_running),
        ("sitting_benches", l10n.iwish_sitting_benches),
        ("free_area", l10n.iwish_free_area),
      ],
    ParkSize.large || ParkSize.unknown => [
        ("play_ground", l10n.iwish_play_ground),
        ("sport_court", l10n.iwish_sport_court),
        ("running", l10n.iwish_running),
        ("sitting_benches", l10n.iwish_sitting_benches),
        ("fountain", l10n.iwish_fountain),
        ("vending_machine", l10n.iwish_vending_machine),
        ("food_truck", l10n.iwish_food_truck),
        ("free_area", l10n.iwish_free_area),
      ],
  }
      .map(
        (e) => IwishFeedbackTag(
          id: e.$1,
          displayName: e.$2,
          assetUrl: 'assets/icons/svg/ic_${e.$1}.svg',
        ),
      )
      .toList();
}

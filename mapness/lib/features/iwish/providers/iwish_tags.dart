import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_feedback_tag.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

List<IwishFeedbackTag> iwishTags(AppLocalizations l10n, ParkSize parkSize) => [
      ('sitting_area', l10n.sitting_area),
      ('green_spaces', l10n.green_spaces),
      ('lighting', l10n.lighting),
      ('signage', l10n.signage),
      ('dustbins', l10n.dustbins),
      ('parking', l10n.parking),
      ('wc', l10n.wc),
      ('circulation', l10n.circulation),
      ('shaded_area', l10n.shaded_area),
    ]
        .map(
          (e) => IwishFeedbackTag(
            id: e.$1,
            displayName: e.$2,
            rtlAsset: e.$1 == 'lighting' || e.$1 == 'circulation',
            assetUrl: 'assets/icons/svg/${e.$1}.svg',
          ),
        )
        .toList();

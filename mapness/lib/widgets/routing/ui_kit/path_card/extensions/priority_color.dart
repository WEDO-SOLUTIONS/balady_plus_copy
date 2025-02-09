import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_status.dart';

extension PathBadgeColor on PathCardStatusPriority {
  Color iconColor(BuildContext context) => switch (this) {
        PathCardStatusPriority.critical => context.colorsV2.errorDefault,
        PathCardStatusPriority.warning => context.colorsV2.extra01Default,
        PathCardStatusPriority.info => context.colorsV2.warningDefault,
      };

  Color textColor(BuildContext context) => switch (this) {
        PathCardStatusPriority.critical => context.colorsV2.errorDefault,
        PathCardStatusPriority.warning => context.colorsV2.extra01Default,
        PathCardStatusPriority.info => context.colorsV2.warningDefault,
      };
}

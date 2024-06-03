import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_status.dart';

extension PathBadgeColor on PathCardStatusPriority {
  Color iconColor(BuildContext context) => switch (this) {
        PathCardStatusPriority.critical => context.staticColor.surfaceStatusNegative,
        PathCardStatusPriority.warning => context.staticColor.surfaceStatusAttention,
        PathCardStatusPriority.info => context.color.textAndIconsBaseSecondary,
      };

  Color textColor(BuildContext context) => switch (this) {
        PathCardStatusPriority.critical => context.color.textAndIconsStatusNegative,
        PathCardStatusPriority.warning => context.color.textAndIconsStatusAttention,
        PathCardStatusPriority.info => context.color.textAndIconsBaseSecondary,
      };
}

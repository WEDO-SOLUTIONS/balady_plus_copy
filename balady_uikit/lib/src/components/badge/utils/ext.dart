import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/components/badge/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BadgeTypeExt on BadgeType {
  Color backgroundColor(BadgeTypeColorScheme scheme, BuildContext context) {
    return switch (scheme) {
      BadgeTypeColorScheme.tertiary => Colors.transparent,
      BadgeTypeColorScheme.primary => switch (this) {
          BadgeType.neutral => context.colors.neutralDefault,
          BadgeType.success => context.colors.successDefault,
          BadgeType.warning => context.colors.warningDefault,
          BadgeType.error => context.colors.errorDefault,
          BadgeType.info1 => context.colors.accentDefault,
          BadgeType.info2 => context.colors.accentSecondaryDefault,
          BadgeType.info3 => context.colors.extra01Default,
        },
      BadgeTypeColorScheme.secondary => switch (this) {
          BadgeType.neutral => context.colors.neutralContainerDefault,
          BadgeType.success => context.colors.successContainerDefault,
          BadgeType.warning => context.colors.warningContainerDefault,
          BadgeType.error => context.colors.errorContainerDefault,
          BadgeType.info1 => context.colors.accentContainerDefault,
          BadgeType.info2 => context.colors.accentSecondaryContainerDefault,
          BadgeType.info3 => context.colors.extra01ContainerDefault,
        },
    };
  }

  Color textColor(BadgeTypeColorScheme scheme, BuildContext context) {
    return switch (scheme) {
      BadgeTypeColorScheme.primary => switch (this) {
          BadgeType.neutral => context.colors.neutralOnNeutral,
          BadgeType.success => context.colors.accentOnAccent,
          BadgeType.warning => context.colors.accentOnAccent,
          BadgeType.error => context.colors.accentOnAccent,
          BadgeType.info1 => context.colors.accentOnAccent,
          BadgeType.info2 => context.colors.accentOnAccent,
          BadgeType.info3 => context.colors.accentOnAccent,
        },
      BadgeTypeColorScheme.tertiary || BadgeTypeColorScheme.secondary => switch (this) {
          BadgeType.neutral => context.colors.neutralDefault,
          BadgeType.success => context.colors.successOnContainer,
          BadgeType.warning => context.colors.warningOnContainer,
          BadgeType.error => context.colors.errorOnContainer,
          BadgeType.info1 => context.colors.accentOnContainer,
          BadgeType.info2 => context.colors.accentSecondaryOnContainer,
          BadgeType.info3 => context.colors.extra01OnContainer,
        },
    };
  }
}

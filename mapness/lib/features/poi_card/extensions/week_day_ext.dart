import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension WeekDayName on WeekDayMessage {
  String displayName(AppLocalizations locale) => switch (this) {
        WeekDayMessage.monday => locale.monday,
        WeekDayMessage.tuesday => locale.tuesday,
        WeekDayMessage.wednesday => locale.wednesday,
        WeekDayMessage.thursday => locale.thursday,
        WeekDayMessage.friday => locale.friday,
        WeekDayMessage.saturday => locale.saturday,
        WeekDayMessage.sunday => locale.sunday,
      };
}

extension WorkTimeTypeExt on WorkTimeType {
  Color? foregroundColor(BuildContext context) {
    if (this == WorkTimeType.closed) {
      return context.colorsV3.errorOnContainer;
    } else if (this == WorkTimeType.almostClosed) {
      return context.colorsV3.warningOnContainer;
    }
    return null;
  }

  Color? backgroundColor(BuildContext context) {
    if (this == WorkTimeType.closed) {
      return context.colorsV3.errorContainerDefault;
    } else if (this == WorkTimeType.almostClosed) {
      return context.colorsV3.warningContainerDefault;
    }
    return null;
  }
}

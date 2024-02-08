import 'package:flutter/cupertino.dart';
import 'package:mapness/features/path_nav/lib/enums.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

extension DistanceUnitsExt on DistanceUnits {
  String getDescription(BuildContext context) => switch (this) {
        DistanceUnits.km => context.l10n.km,
        DistanceUnits.m => context.l10n.meter,
      };
}

extension TimeunitsExt on TimeUnits {
  String getDescription(BuildContext context) => switch (this) {
        TimeUnits.min => context.l10n.min,
        TimeUnits.hours => context.l10n.hours,
      };
}

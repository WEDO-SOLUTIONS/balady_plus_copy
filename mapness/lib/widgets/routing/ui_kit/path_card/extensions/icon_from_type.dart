import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_status.dart';

extension PathBadgeIcon on PathCardStatusType {
  IconData icon(BuildContext context) {
    final isLTR = Directionality.of(context) == TextDirection.ltr;
    switch (this) {
      case PathCardStatusType.shortest:
        return General16Icons.starSolid;
      case PathCardStatusType.overlaps:
        return EventsOnTheRoute.overlap;
      case PathCardStatusType.paid:
        return EventsOnTheRoute.tollRoadEn;
      case PathCardStatusType.incline:
        return isLTR ? EventsOnTheRoute.ascentLtr : EventsOnTheRoute.ascentRtl;
    }
  }
}

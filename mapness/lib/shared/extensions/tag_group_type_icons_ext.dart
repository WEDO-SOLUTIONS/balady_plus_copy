import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper_v2.dart';

extension TagGroupIcons on TagGroupType {
  IconData? get icon {
    if (this case TagGroupType.mapAndContent) {
      return GeneralIcons.map;
    } else if (this case TagGroupType.navigationAndRoutes) {
      return TransportIcons.freeRoam;
    } else if (this case TagGroupType.overallImpression) {
      return GeneralIcons.star;
    }

    return null;
  }
}

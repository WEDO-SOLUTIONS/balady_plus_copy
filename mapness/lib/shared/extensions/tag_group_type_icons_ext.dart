import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper_v2.dart';

extension TagGroupIcons on TagGroupType {
  IconData? get icon {
    switch (this) {
      case TagGroupType.mapAndContent:
        return GeneralIcons.map;
      case TagGroupType.navigationAndRoutes:
        return TransportIcons.freeRoam;
      case TagGroupType.overallImpression:
        return GeneralIcons.star;
      case TagGroupType.errorsOnMap:
        return GeneralIcons.map;
      case TagGroupType.roadErrors:
        return TransportIcons.freeRoam;
      case TagGroupType.commonMistake:
        return SystemIcons.settings;
    }
  }
}

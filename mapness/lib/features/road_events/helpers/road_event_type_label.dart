import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

extension RoadEventTypeLabelEx on RoadEventType {
  String label(AppLocalizations l10n) => switch (this) {
    RoadEventType.accident => l10n.roadEventTypeAccident,
    RoadEventType.construction => l10n.roadEventTypeConstruction,
    RoadEventType.camera => l10n.roadEventTypeCamera,
    RoadEventType.police => l10n.roadEventTypePolice,
    RoadEventType.danger => l10n.roadEventTypeDanger,
    RoadEventType.congestion => l10n.roadEventTypeCongestion,
  };

  ToastIcon icon() => switch (this) {
    RoadEventType.accident => const ToastIconData(TransportIcons.accident),
    RoadEventType.construction => const ToastIconData(TransportIcons.repair),
    RoadEventType.camera => const ToastIconData(GeneralIcons.photoSolid),
    RoadEventType.police => const ToastIconData(PlacesIcons.police),
    RoadEventType.danger => const ToastIconData(GeneralIcons.warning),
    RoadEventType.congestion => ToastIconAsset(Assets.icons.svg.layers.icRoadEventCongestion.keyName),
  };

  Color color(AppColorsThemeV3 colors) => switch (this) {
    RoadEventType.accident => colors.errorDefault,
    RoadEventType.construction => colors.warningDefault,
    RoadEventType.camera => colors.staticBlack,
    RoadEventType.police => colors.staticBlack,
    RoadEventType.danger => colors.warningDefault,
    RoadEventType.congestion => colors.warningDefault,
  };
}

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

extension RoadEventTypeLabelEx on RoadEventType {
  String label(AppLocalizations l10n) => switch (this) {
    RoadEventType.accident => l10n.roadEventTypeAccident,
    RoadEventType.roadWorks => l10n.roadEventTypeRoadWorks,
    RoadEventType.camera => l10n.roadEventTypeCamera,
    RoadEventType.comment => l10n.roadEventTypeComment,
    RoadEventType.roadRestriction => l10n.roadBlocking,
    RoadEventType.other => l10n.roadEventTypeOther,
  };

  ToastIcon icon() => switch (this) {
    RoadEventType.accident => const ToastIconData(TransportIcons.accident),
    RoadEventType.roadWorks => const ToastIconData(TransportIcons.repair),
    RoadEventType.camera => const ToastIconData(GeneralIcons.photoSolid),
    RoadEventType.comment => const ToastIconData(PlacesIcons.police),
    RoadEventType.roadRestriction => const ToastIconData(GeneralIcons.warning),
    RoadEventType.other => ToastIconAsset(Assets.icons.svg.layers.icRoadEventCongestion.keyName),
  };

  Color color(AppColorsThemeV3 colors) => switch (this) {
    RoadEventType.accident => colors.errorDefault,
    RoadEventType.roadWorks => colors.warningDefault,
    RoadEventType.camera => colors.staticBlack,
    RoadEventType.comment => colors.staticBlack,
    RoadEventType.roadRestriction => colors.warningDefault,
    RoadEventType.other => colors.errorDefault,
  };
}

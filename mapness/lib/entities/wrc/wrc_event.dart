import 'package:dgis_map/library.dart' as sdk;
import 'package:equatable/equatable.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

class WRCEventPoint extends Equatable {
  final WRCEventType type;
  final String Function(AppLocalizations l10n) titleBuilder;
  final String Function(AppLocalizations l10n) descriptionBuilder;
  final int objectId;
  final sdk.GeoPointMessage center;

  const WRCEventPoint({
    required this.type,
    required this.titleBuilder,
    required this.descriptionBuilder,
    required this.objectId,
    required this.center,
  });

  String get globalMarkerId => 'wrc-event-$objectId';

  @override
  List<Object?> get props => [
        type,
        titleBuilder,
    descriptionBuilder,
        objectId,
        center,
      ];
}

enum WRCEventType {
  rallyStage,
  parking,
  servicePark,
  shakedownStage,
  fanZone,
  specialSuperStage,
  jeddahCornicheParade,
  awardCeremony;

  String get pinPath => switch (this) {
        WRCEventType.rallyStage => Assets.icons.svg.icWrcPinRallyStage.keyName,
        WRCEventType.parking => Assets.icons.svg.icWrcPinParking.keyName,
        WRCEventType.servicePark => Assets.icons.svg.icWrcPinServicePark.keyName,
        WRCEventType.shakedownStage => Assets.icons.svg.icWrcPinShakedownStage.keyName,
        WRCEventType.fanZone => Assets.icons.svg.icWrcPinFanZone.keyName,
        WRCEventType.specialSuperStage => Assets.icons.svg.icWrcPinSpecialSuperStage.keyName,
        WRCEventType.jeddahCornicheParade => Assets.icons.svg.icWrcPinJeddahCornicheParade.keyName,
        WRCEventType.awardCeremony => Assets.icons.svg.icWrcPinAwardCeremony.keyName,
      };

  String get mapMarkerPath => switch (this) {
        WRCEventType.rallyStage => Assets.icons.svg.icWrcMapMarkerRallyStage.keyName,
        WRCEventType.parking => Assets.icons.svg.icWrcMapMarkerParking.keyName,
        WRCEventType.servicePark => Assets.icons.svg.icWrcMapMarkerServicePark.keyName,
        WRCEventType.shakedownStage => Assets.icons.svg.icWrcMapMarkerShakedownStage.keyName,
        WRCEventType.fanZone => Assets.icons.svg.icWrcMapMarkerFanZone.keyName,
        WRCEventType.specialSuperStage => Assets.icons.svg.icWrcMapMarkerSpecialSuperStage.keyName,
        WRCEventType.jeddahCornicheParade => Assets.icons.svg.icWrcMapMarkerJeddahCornicheParade.keyName,
        WRCEventType.awardCeremony => Assets.icons.svg.icWrcMapMarkerAwardCeremony.keyName,
      };

  String get dashboardImagePath => switch (this) {
        WRCEventType.rallyStage => Assets.icons.svg.icWrcSearchMarkerRallyStage.keyName,
        WRCEventType.parking => Assets.icons.svg.icWrcSearchMarkerParking.keyName,
        WRCEventType.servicePark => Assets.icons.svg.icWrcSearchMarkerServicePark.keyName,
        WRCEventType.shakedownStage => Assets.icons.svg.icWrcSearchMarkerShakedownStage.keyName,
        WRCEventType.fanZone => Assets.icons.svg.icWrcSearchMarkerFanZone.keyName,
        WRCEventType.specialSuperStage => Assets.icons.svg.icWrcSearchMarkerSpecialSuperStage.keyName,
        WRCEventType.jeddahCornicheParade => Assets.icons.svg.icWrcSearchMarkerJeddahCornicheParade.keyName,
        WRCEventType.awardCeremony => Assets.icons.svg.icWrcSearchMarkerAwardCeremony.keyName,
      };
}

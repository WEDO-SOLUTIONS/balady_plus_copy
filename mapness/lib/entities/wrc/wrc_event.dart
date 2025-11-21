import 'package:dgis_map/library.dart' as sdk;
import 'package:dgis_map/library.dart';
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

  // remove line breaks to see all text
  String getSingleLineTitle(AppLocalizations l10n) => titleBuilder(l10n).replaceAll('\n', ' ');

  DirectoryObjectMessage toDirectoryObjectMessage(AppLocalizations l10n) {
    final title = getSingleLineTitle(l10n);

    return DirectoryObjectMessage(
      types: [],
      title: title,
      titleAddition: '',
      subtitle: l10n.wrcPOISubtitle,
      about: descriptionBuilder(l10n),
      id: DgisObjectIdMessage(
        objectId: objectId,
        entranceId: 0,
      ),
      markerPosition: GeoPointWithElevationMessage(
        latitude: center.latitude,
        longitude: center.longitude,
        elevation: 0,
      ),
      attributes: [],
      contextAttributes: [],
      contactInfos: [],
      entrances: [],
      buildingInfo: BuildingInfoMessage(
        buildingName: title,
        purposeName: title,
        purposeCode: 501,
      ),
      rubricIds: [],
      group: [],
      routeInfos: [],
      platformIds: [],
    );
  }

  DirectoryObjectMessage mergeDirectoryObjectMessage(AppLocalizations l10n, DirectoryObjectMessage? other) {
    final thisDirectoryObject = toDirectoryObjectMessage(l10n);

    return DirectoryObjectMessage(
      types: other?.types ?? thisDirectoryObject.types,
      // here
      title: thisDirectoryObject.title,
      titleAddition: other?.titleAddition ?? thisDirectoryObject.titleAddition,
      // here
      subtitle: thisDirectoryObject.subtitle,
      // here
      about: thisDirectoryObject.about,
      description: other?.description ?? thisDirectoryObject.description,
      id: other?.id ?? thisDirectoryObject.id,
      markerPosition: other?.markerPosition ?? thisDirectoryObject.markerPosition,
      address: other?.address ?? thisDirectoryObject.address,
      fullAddressName: other?.fullAddressName ?? thisDirectoryObject.fullAddressName,
      shortAddressName: other?.shortAddressName ?? thisDirectoryObject.shortAddressName,
      attributes: other?.attributes ?? thisDirectoryObject.attributes,
      contextAttributes: other?.contextAttributes ?? thisDirectoryObject.contextAttributes,
      timeZoneOffset: other?.timeZoneOffset ?? thisDirectoryObject.timeZoneOffset,
      openingHours: other?.openingHours ?? thisDirectoryObject.openingHours,
      contactInfos: other?.contactInfos ?? thisDirectoryObject.contactInfos,
      reviews: other?.reviews ?? thisDirectoryObject.reviews,
      parkingInfo: other?.parkingInfo ?? thisDirectoryObject.parkingInfo,
      workStatus: other?.workStatus ?? thisDirectoryObject.workStatus,
      levelId: other?.levelId ?? thisDirectoryObject.levelId,
      buildingLevels: other?.buildingLevels ?? thisDirectoryObject.buildingLevels,
      entrances: other?.entrances ?? thisDirectoryObject.entrances,
      tradeLicense: other?.tradeLicense ?? thisDirectoryObject.tradeLicense,
      buildingInfo: other?.buildingInfo ?? thisDirectoryObject.buildingInfo,
      rubricIds: other?.rubricIds ?? thisDirectoryObject.rubricIds,
      orgInfo: other?.orgInfo ?? thisDirectoryObject.orgInfo,
      group: other?.group ?? thisDirectoryObject.group,
      routeInfos: other?.routeInfos ?? thisDirectoryObject.routeInfos,
      platformIds: other?.platformIds ?? thisDirectoryObject.platformIds,
    );
  }
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

  String get searchMarkerImagePath => switch (this) {
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

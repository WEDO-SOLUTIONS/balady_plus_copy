part of 'wrc.dart';

// TODO(WRC):add valid objectId's when uploaded by 2gis
final _points = [
  ..._specialPoints,
  ..._rallyStagePoints,
];

/// These points are used to navigate user on map when tapped on dashboard.
/// They are chosen so as to fit the screen nicely for user
Iterable<WRCEventPoint> get _initialViewPortPoints {
  const filterEventTypes = {
    WRCEventType.parking,
    WRCEventType.servicePark,
    WRCEventType.fanZone,
    WRCEventType.specialSuperStage,
    WRCEventType.jeddahCornicheParade,
  };
  return _specialPoints.where((e) => filterEventTypes.contains(e.type));
}

final _specialPoints = [
  WRCEventPoint(
    type: WRCEventType.parking,
    objectId: 70030076563163172,
    center: sdk.GeoPointMessage(
      latitude: 21.645725,
      longitude: 39.109056,
    ),
    titleBuilder: (l10n) => l10n.wrcPointCarParkingName,
    descriptionBuilder: (l10n) => l10n.wrcPointCarParkingDescription,
  ),
  WRCEventPoint(
    type: WRCEventType.parking,
    objectId: 000000000000002,
    center: sdk.GeoPointMessage(
      latitude: 21.645450,
      longitude: 39.106956,
    ),
    titleBuilder: (l10n) => l10n.wrcPointVipCarParkingName,
    descriptionBuilder: (l10n) => l10n.wrcPointVipCarParkingDescription,
  ),
  WRCEventPoint(
    type: WRCEventType.fanZone,
    objectId: 000000000000003,
    center: sdk.GeoPointMessage(
      latitude: 21.644022,
      longitude: 39.110067,
    ),
    titleBuilder: (l10n) => l10n.wrcPointFanZoneName,
    descriptionBuilder: (l10n) => l10n.wrcPointFanZoneDescription,
  ),
  WRCEventPoint(
    type: WRCEventType.fanZone,
    objectId: 000000000000004,
    center: sdk.GeoPointMessage(
      latitude: 21.643475,
      longitude: 39.108008,
    ),
    titleBuilder: (l10n) => l10n.wrcPointFanZoneName,
    descriptionBuilder: (l10n) => l10n.wrcPointFanZoneDescription,
  ),
  WRCEventPoint(
    type: WRCEventType.servicePark,
    objectId: 000000000000005,
    center: sdk.GeoPointMessage(
      latitude: 21.643547,
      longitude: 39.109658,
    ),
    titleBuilder: (l10n) => l10n.wrcPointServiceParkName,
    descriptionBuilder: (l10n) => l10n.wrcPointServiceParkDescription,
  ),
  WRCEventPoint(
    type: WRCEventType.jeddahCornicheParade,
    objectId: 000000000000006,
    center: sdk.GeoPointMessage(
      latitude: 21.610433,
      longitude: 39.107817,
    ),
    titleBuilder: (l10n) => l10n.wrcPointCornisheParadeName,
    descriptionBuilder: (l10n) => l10n.wrcPointCornisheParadeDescription,
  ),
  WRCEventPoint(
    type: WRCEventType.shakedownStage,
    objectId: 000000000000007,
    center: sdk.GeoPointMessage(
      latitude: 21.873492,
      longitude: 39.149547,
    ),
    titleBuilder: (l10n) => l10n.wrcPointShakedownName,
    descriptionBuilder: (l10n) => l10n.wrcPointShakedownDescription,
  ),
  WRCEventPoint(
    type: WRCEventType.specialSuperStage,
    objectId: 000000000000008,
    center: sdk.GeoPointMessage(
      latitude: 21.641053,
      longitude: 39.109172,
    ),
    titleBuilder: (l10n) => l10n.wrcPointJameelMotorsportSuperSpecialName,
    descriptionBuilder: (l10n) => l10n.wrcPointJameelMotorsportSuperSpecialDescription,
  ),
  WRCEventPoint(
    type: WRCEventType.awardCeremony,
    objectId: 000000000000009,
    center: sdk.GeoPointMessage(
      latitude: 21.867500,
      longitude: 39.150000,
    ),
    titleBuilder: (l10n) => l10n.wrcPointPodiumNPrizeGivingName,
    descriptionBuilder: (l10n) => l10n.wrcPointPodiumNPrizeGivingDescription,
  ),
];

final _rallyStagePoints = [
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000010,
    center: sdk.GeoPointMessage(
      latitude: 22.178333,
      longitude: 39.289167,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName1,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription1,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000011,
    center: sdk.GeoPointMessage(
      latitude: 22.163889,
      longitude: 39.353333,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName2,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription2,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000012,
    center: sdk.GeoPointMessage(
      latitude: 22.208611,
      longitude: 39.527222,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName3,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription3,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000013,
    center: sdk.GeoPointMessage(
      latitude: 22.179167,
      longitude: 39.288889,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName4,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription4,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000014,
    center: sdk.GeoPointMessage(
      latitude: 22.163333,
      longitude: 39.351389,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName5,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription5,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000015,
    center: sdk.GeoPointMessage(
      latitude: 22.209722,
      longitude: 39.526389,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName6,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription6,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000016,
    center: sdk.GeoPointMessage(
      latitude: 21.880000,
      longitude: 39.243056,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName7,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription7,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000017,
    center: sdk.GeoPointMessage(
      latitude: 21.955833,
      longitude: 39.418333,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName8,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription8,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000018,
    center: sdk.GeoPointMessage(
      latitude: 21.906944,
      longitude: 39.341667,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName9,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription9,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000019,
    center: sdk.GeoPointMessage(
      latitude: 21.879444,
      longitude: 39.244167,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName10,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription10,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000020,
    center: sdk.GeoPointMessage(
      latitude: 21.956111,
      longitude: 39.416944,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName11,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription11,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000021,
    center: sdk.GeoPointMessage(
      latitude: 21.910833,
      longitude: 39.342500,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName12,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription12,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000022,
    center: sdk.GeoPointMessage(
      latitude: 21.849722,
      longitude: 39.178056,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName13,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription13,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000023,
    center: sdk.GeoPointMessage(
      latitude: 21.968056,
      longitude: 39.250556,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName14,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription14,
  ),
  WRCEventPoint(
    type: WRCEventType.rallyStage,
    objectId: 0000000000000024,
    center: sdk.GeoPointMessage(
      latitude: 21.853889,
      longitude: 39.175000,
    ),
    titleBuilder: (l10n) => l10n.wrcPointSpectatorsAreaName15,
    descriptionBuilder: (l10n) => l10n.wrcPointSpectatorsAreaDescription15,
  ),
];

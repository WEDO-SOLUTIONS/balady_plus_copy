enum GISMapLayers {
  cityPlaces(
    layerId: 0,
    outFieldsShort: [],
    outFieldsLong: [],
  ),
  restaurants(
    layerId: 1,
    outFieldsShort: [
      'OBJECTID',
      'XCOORDINATE',
      'YCOORDINATE',
      'STREET_NAME',
      'ACTIVITY_DETAILED_DESCRIPTION',
      'TRADENAME',
      'REGION_ID',
      'AMANA_ID',
      'DISTRICT_ID',
      'CITY_ID',
      'SUNDAY',
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'RATE',
      'OPENSTATUS',
      'REVIEW',
    ],
    outFieldsLong: [
      '*',
    ],
  ),
  opportunities(
    layerId: 2,
    outFieldsShort: [
      'OBJECTID',
    ],
    outFieldsLong: [
      '*',
    ],
  ),
  digging(
    layerId: 5,
    outFieldsShort: [
      'STREET_CLOSE_TYPE',
      'PROJECT_NAME',
      'OBJECTID',
      'SITE_NAME',
      'WORKSTARTDATE',
      'PATHLENGTH',
      'WORKENDDATE',
      'NAME_AR',
    ],
    outFieldsLong: [
      'STREET_CLOSE_TYPE',
      'PROJECT_NAME',
      'OBJECTID',
      'SITE_NAME',
      'WORKSTARTDATE',
      'PATHLENGTH',
      'WORKENDDATE',
      'NAME_AR',
    ],
  ),
  bsAimtithalBuildingsCertificateL(
    layerId: 7,
    outFieldsShort: [
      'OBJECTID',
    ],
    outFieldsLong: [
      '*',
    ],
  ),
  bsWhiteParcelS(
    layerId: 8,
    outFieldsShort: [
      'OBJECTID',
      'STATUS',
    ],
    outFieldsLong: [
      '*',
    ],
  ),
  cadastralParcels(
    layerId: 10,
    outFieldsShort: [
      'SUBTYPEDESCRIPTION',
      'OBJECTID',
    ],
    outFieldsLong: [],
    resultRecordCount: 50,
  ),
  cadastralParcelsLand(
    layerId: 9,
    resultRecordCount: 30,
    outFieldsShort: [
      'OBJECTID',
      'BLOCK_ID',
      'SUBDIVISIONPARCELNUMBER',
      'SUBDIVISIONPLAN_ID',
    ],
    outFieldsLong: [
      'OBJECTID',
      'BLOCK_ID',
      'SUBDIVISIONPARCELNUMBER',
      'SUBDIVISIONPLAN_ID',
    ],
  ),
  events(
    layerId: 13,
    outFieldsShort: ['*'],
    outFieldsLong: ['*'],
  );

  final int layerId;

  final int resultRecordCount;
  final List<String> outFieldsShort;
  final List<String> outFieldsLong;

  const GISMapLayers({
    required this.layerId,
    required this.outFieldsShort,
    required this.outFieldsLong,
    this.resultRecordCount = 100,
  });
}

import '../../constants/constants.dart';

enum GISMapLayers {
  cityPlaces(
    layerId: 0,
    cardHeight: 120,
    icon: Constants.bulidingLayerIcon,
    selectedIcon: Constants.bulidingSelectedLayerIcon,
    outFieldsShort: [],
    outFieldsLong: [],
  ),

  resturants(
    layerId: 1,
    cardHeight: 180,
    icon: Constants.restaurantLayerIcon,
    selectedIcon: Constants.restaurantLayerIcon,
    outFieldsShort: [
      "OBJECTID",
      "XCOORDINATE",
      "YCOORDINATE",
      "STREET_NAME",
      "ACTIVITY_DETAILED_DESCRIPTION",
      "TRADENAME",
      "REGION_ID",
      "AMANA_ID",
      "DISTRICT_ID",
      "CITY_ID",
      "SUNDAY",
      "MONDAY",
      "TUESDAY",
      "WEDNESDAY",
      "THURSDAY",
      "FRIDAY",
      "SATURDAY",
      "RATE",
      "OPENSTATUS",
      "REVIEW",
    ],
    outFieldsLong: ["*"],
  ),

  opportunities(
    layerId: 2,
    cardHeight: 180,
    icon: Constants.furasLayerIcon,
    selectedIcon: Constants.furasSelectedLayerIcon,
    outFieldsShort: [
      "OBJECTID",
      "STATUS",
      "OPPORTUNITYNUMBER",
      "ID",
      "SITEAREA",
      "DAILYLEASECOST",
      "DOCUMENTVALUE",
      "TYPE",
      "BIDENDDATE",
      "OPPORTUNITYDESCRIPTION",
      "SITENUMBER",
      "SITEADDRESS",
      "MAIN_ACTIVITY_NAME",
      "LOCATIONLISTSTRING",
      "RFPENDDATE",
      "REGION_ID",
    ],
    outFieldsLong: ["*"],
  ),

  digging(
    layerId: 5,
    cardHeight: 120,
    icon: Constants.diggingLayerIcon,
    selectedIcon: Constants.diggingSelectedLayerIcon,
    outFieldsShort: [
      "STREET_CLOSE_TYPE",
      "PROJECT_NAME",
      "OBJECTID",
      "SITE_NAME",
      "WORKSTARTDATE",
      "PATHLENGTH",
      "WORKENDDATE",
      "NAME_AR",
    ],
    outFieldsLong: [
      "STREET_CLOSE_TYPE",
      "PROJECT_NAME",
      "OBJECTID",
      "SITE_NAME",
      "WORKSTARTDATE",
      "PATHLENGTH"
          "WORKENDDATE",
      "NAME_AR",
    ],
  ),

  bSAimtithalBuildingsCertificateL(
    layerId: 7,
    cardHeight: 180,
    icon: Constants.imtethalLayerIcon,
    selectedIcon: Constants.imtethalSelectedLayerIcon,
    outFieldsShort: [
      "OBJECTID",
      "PRIORITYAREA",
      "STARTDATE",
      "TARGETBUILDINGTYPE",
      "STAGENO",
      "AMANANAME",
      "STREETNAME",
      "MUNICIPALITYNAME",
      "DISTRICTNAME",
      "STREETTYPE",
      "STREETWIDTH",
    ],
    outFieldsLong: [
      "OBJECTID",
      "PRIORITYAREA",
      "STARTDATE",
      "TARGETBUILDINGTYPE",
      "STAGENO",
      "AMANANAME",
      "STREETNAME",
      "MUNICIPALITYNAME",
      "DISTRICTNAME",
      "STREETTYPE",
      "STREETWIDTH",
    ],
    resultRecordCount: 100,
  ),

  /*VDPriorityAreaRouteS(layerId: 8, outFieldsShort: [
    "OBJECTID",
    "COLOR",
    "AREANAME_SPLIT",
    "DESCRIPTION",
    "AREANAME",
    "RISKDESCREPTION",
    "COLOR"
  ], outFieldsLong: [
    "OBJECTID",
    "COLOR",
    "AREANAME_SPLIT",
    "DESCRIPTION",
    "AREANAME",
    "RISKDESCREPTION",
    "COLOR"
  ]),*/

  bSWhiteParcelS(
    layerId: 8,
    cardHeight: 160,
    icon: Constants.landsLayerIcon,
    selectedIcon: Constants.landsSelectedLayerIcon,
    outFieldsShort: [
      "OBJECTID",
      "AMANANAME",
      "MUNNAME",
      "PARCELCODE",
      "STATUS",
      "STREETNAME",
      "PARCELAREA",
      "CITYNAME",
      "PARCELNO",
      "PARCELLENGTH",
      "PHASE",
    ],
    outFieldsLong: [
      "OBJECTID",
      "AMANANAME",
      "MUNNAME",
      "PARCELCODE",
      "STATUS",
      "STREETNAME",
      "PARCELAREA",
      "CITYNAME",
      "PARCELNO",
      "PARCELLENGTH",
      "PHASE",
    ],
    resultRecordCount: 100,
  ),

  cadastralParcels(
    layerId: 10,
    cardHeight: 160,
    icon: Constants.landsLayerIcon,
    selectedIcon: Constants.landsSelectedLayerIcon,
    outFieldsShort: ["SUBTYPEDESCRIPTION", "OBJECTID"],
    outFieldsLong: [],
    resultRecordCount: 50,
  ),

  cadastralParcelsLand(
    layerId: 9,
    cardHeight: 160,
    resultRecordCount: 30,
    icon: Constants.landsLayerIcon,
    selectedIcon: Constants.landsSelectedLayerIcon,
    outFieldsShort: ["OBJECTID", "BLOCK_ID", "SUBDIVISIONPARCELNUMBER", "SUBDIVISIONPLAN_ID"],
    outFieldsLong: ["OBJECTID", "BLOCK_ID", "SUBDIVISIONPARCELNUMBER", "SUBDIVISIONPLAN_ID"],
  ),

  events(
    layerId: 13,
    cardHeight: 180,
    icon: Constants.restaurantLayerIcon,
    selectedIcon: Constants.restaurantLayerIcon,
    outFieldsShort: ["*"],
    outFieldsLong: ["*"],
  );

  const GISMapLayers({
    required this.layerId,
    required this.outFieldsShort,
    required this.outFieldsLong,
    required this.icon,
    required this.selectedIcon,
    required this.cardHeight,
    this.resultRecordCount = 100,
  });
  final int layerId;

  final int resultRecordCount;
  final List<String> outFieldsShort;
  final List<String> outFieldsLong;
  final String icon;
  final String selectedIcon;
  final int cardHeight;
}

import '../../constants/constants.dart';

enum GISMapLayers {
  cityPlaces(
      layerId: 0,
      icon: Constants.bulidingLayerIcon,
      selectedIcon: Constants.bulidingSelectedLayerIcon,
      outFieldsShort: [],
      outFieldsLong: []),
  Opportunities(
      layerId: 2,
      icon: Constants.furasLayerIcon,
      selectedIcon: Constants.furasSelectedLayerIcon,
      outFieldsShort: [
        "OBJECTID",
        "DESCRIPTION",
        "OPPORTUNITY_ID",
        "OPPORTUNITYTYPE",
        "SOURCECASEKEY",
        "SUBMUNICIPALITY",
        "STREET",
        "MUNICIPALITY",
      ],
      outFieldsLong: [
        "OBJECTID",
        "DESCRIPTION",
        "OPPORTUNITY_ID",
        "OPPORTUNITYTYPE",
        "SOURCECASEKEY",
        "SUBMUNICIPALITY",
        "STREET",
        "MUNICIPALITY",
      ]),

  Digging(
      layerId: 5,
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
        "NAME_AR"
      ],
      outFieldsLong: [
        "STREET_CLOSE_TYPE",
        "PROJECT_NAME",
        "OBJECTID",
        "SITE_NAME",
        "WORKSTARTDATE",
        "PATHLENGTH"
            "WORKENDDATE",
        "NAME_AR"
      ]),

  BSAimtithalBuildingsCertificateL(
      layerId: 7,
      icon: Constants.bulidingLayerIcon,
      selectedIcon: Constants.bulidingSelectedLayerIcon,
      outFieldsShort: [
        "OBJECTID",
        "PRIORITYAREA",
        "STARTDATE",
        "TARGETBUILDINGTYPE",
        "STAGENO",
        "AMANANAME",
        "MUNICIPALITYNAME",
        "DISTRICTNAME",
        "STREETTYPE",
        "STREETWIDTH"
      ],
      outFieldsLong: [
        "OBJECTID",
        "PRIORITYAREA",
        "STARTDATE",
        "TARGETBUILDINGTYPE",
        "STAGENO",
        "AMANANAME",
        "MUNICIPALITYNAME",
        "DISTRICTNAME",
        "STREETTYPE",
        "STREETWIDTH"
      ],
      resultRecordCount: 10),

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

  BSWhiteParcelS(
      layerId: 8,
      icon: Constants.landsLayerIcon,
      selectedIcon: Constants.landsSelectedLayerIcon,
      outFieldsShort: [
        /* "PARCELAREA",
    "PARCELNO",
    "AMANANAME",
    "MUNNAME",
    "STREETNAME",
    "PLANNAME",
    "SHAPE.AREA",*/
        "OBJECTID",
        "STATUS"
      ],
      outFieldsLong: [
        /* "PARCELAREA",
    "PARCELNAME",
    "PLANNO",
    "PARCELNO",
    "AMANANAME",
    "MUNNAME",
    "STREETNAME",
    "PLANNAME",
    "PARCELCODE",
    "DESCRIPTION",
    "SHAPE.AREA",*/
        "OBJECTID",
        "STATUS"
      ]),

  CadastralParcels(
      layerId: 10,
      icon: Constants.landsLayerIcon,
      selectedIcon: Constants.landsSelectedLayerIcon,
      outFieldsShort: [
        "SUBTYPEDESCRIPTION",
        "OBJECTID",
      ],
      outFieldsLong: [],
      resultRecordCount: 10),

  CadastralParcelsLand(
      layerId: 11,
      icon: Constants.landsLayerIcon,
      selectedIcon: Constants.landsSelectedLayerIcon,
      outFieldsShort: [
        "OBJECTID",
        "SUBDIVISIONPLANLCODE",
        "PLANSTATUS",
        "PLANNOFLOOR",
        "PLANMAXHEIGHT",
        "PLANRESDUNITNO",
        "PLANCOMMUNITNO",
        "PLANINDSTUNITNO",
        "PLANMOSQUENO",
        "PLANSCHOOLNO"
      ],
      outFieldsLong: [
        "OBJECTID",
        "SUBDIVISIONPLANLCODE",
        "PLANSTATUS",
        "PLANNOFLOOR",
        "PLANMAXHEIGHT",
        "PLANRESDUNITNO",
        "PLANCOMMUNITNO",
        "PLANINDSTUNITNO",
        "PLANMOSQUENO",
        "PLANSCHOOLNO"
      ]),
  ;

  const GISMapLayers(
      {required this.layerId,
      required this.outFieldsShort,
      required this.outFieldsLong,
      required this.icon,
      required this.selectedIcon,
      this.resultRecordCount = 100});
  final int layerId;

  final int resultRecordCount;
  final List<String> outFieldsShort;
  final List<String> outFieldsLong;
  final String icon;
  final String selectedIcon;
}

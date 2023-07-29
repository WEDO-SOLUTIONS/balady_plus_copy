enum GISMapLayers {
  Opportunities(layerId: 2, outFieldsShort: [
    "OBJECTID",
    "DESCRIPTION",
    "OPPORTUNITY_ID",
    "OPPORTUNITYTYPE",
    "SOURCECASEKEY",
    "SUBMUNICIPALITY",
    "STREET",
    "MUNICIPALITY",
  ], outFieldsLong: [
    "OBJECTID",
    "DESCRIPTION",
    "OPPORTUNITY_ID",
    "OPPORTUNITYTYPE",
    "SOURCECASEKEY",
    "SUBMUNICIPALITY",
    "STREET",
    "MUNICIPALITY",
  ]),

  Digging(layerId: 5, outFieldsShort: [
    "STREET_CLOSE_TYPE",
    "PROJECT_NAME",
    "OBJECTID",
    "STREET_NAME",
    "SITE_NAME",
    "AMMANA",
    "BALADIA",
    "DISTRICT_NAME",
    "MUNICIPALITYARNAME",
    "WORKSTARTDATE",
    "WORKENDDATE",
  ], outFieldsLong: [
    "STATUS",
    "LIC_STATUS",
    "NAME_AR",
    "CONTRACTOR_NAME",
    "PROJECT_NAME",
    "OBJECTID",
    "WORKSTARTDATE",
    "WORKENDDATE",
    "STREET_CLOSE_TYPE",
    "STREET_NAME",
    "PATHLENGTH",
    "SITE_NAME",
    "WORK_NATURE",
    "LICENSE_ID",
    "AMMANA",
    "BALADIA",
    "DISTRICT_NAME",
    "MUNICIPALITYARNAME"
  ]),

  BSAimtithalBuildingsCertificateL(
      layerId: 7,
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

  VDPriorityAreaRouteS(layerId: 8, outFieldsShort: [
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
  ]),

  BSWhiteParcelS(layerId: 9, outFieldsShort: [
    "PARCELAREA",
    "PARCELNO",
    "AMANANAME",
    "MUNNAME",
    "STREETNAME",
    "PLANNAME",
    "SHAPE.AREA",
    "OBJECTID",
  ], outFieldsLong: [
    "PARCELAREA",
    "PARCELNAME",
    "PLANNO",
    "PARCELNO",
    "AMANANAME",
    "MUNNAME",
    "STREETNAME",
    "PLANNAME",
    "PARCELCODE",
    "DESCRIPTION",
    "SHAPE.AREA",
    "OBJECTID",
  ]),

  CadastralParcels(
      layerId: 10,
      outFieldsShort: [
        "SUBTYPEDESCRIPTION",
        "OBJECTID",
      ],
      outFieldsLong: [],
      resultRecordCount: 10),

  CadastralParcelsLand(layerId: 11, outFieldsShort: [
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
  ], outFieldsLong: [
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
      this.resultRecordCount = 100});
  final int layerId;

  final int resultRecordCount;
  final List<String> outFieldsShort;
  final List<String> outFieldsLong;
}

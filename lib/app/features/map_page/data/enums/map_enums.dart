enum GISMapLayers {
  Digging(layerId: 5, outFieldsShort: [
    "STREET_CLOSE_TYPE",
    "PROJECT_NAME",
    "OBJECTID",
    "STREET_NAME",
    "SITE_NAME",
    "AMMANA",
    "BALADIA",
    "DISTRICT_NAME",
    "MUNICIPALITYARNAME"
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

  BSWhiteParcelS(layerId: 9, outFieldsShort: [
    "PARCELAREA",
    "PARCELNO",
    "AMANANAME",
    "MUNNAME",
    "STREETNAME",
    "PLANNAME",
    "PARCELCODE",
    "DESCRIPTION",
    "SHAPE.AREA",
    "OBJECTID",
  ], outFieldsLong: [
    "PARCELAREA",
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

  CadastralParcels(layerId: 10, outFieldsShort: [
    "SUBTYPEDESCRIPTION",
    "OBJECTID",
  ], outFieldsLong: []),

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
      required this.outFieldsLong});
  final int layerId;
  final List<String> outFieldsShort;
  final List<String> outFieldsLong;
}

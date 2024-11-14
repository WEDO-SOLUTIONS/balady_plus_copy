enum GISMapLayers {
  BSAimtithalBuildingsCertificateL(
      layerId: 7,
      cardHeight: 180,
      icon: "",
      selectedIcon: "",
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
        "STREETWIDTH"
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
        "STREETWIDTH"
      ],
      resultRecordCount: 100),
  ;

  const GISMapLayers(
      {required this.layerId,
      required this.outFieldsShort,
      required this.outFieldsLong,
      required this.icon,
      required this.selectedIcon,
      required this.cardHeight,
      this.resultRecordCount = 100});
  final int layerId;

  final int resultRecordCount;
  final List<String> outFieldsShort;
  final List<String> outFieldsLong;
  final String icon;
  final String selectedIcon;
  final int cardHeight;
}

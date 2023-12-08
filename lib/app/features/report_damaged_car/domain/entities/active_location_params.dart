class ActiveLocationParams {
  String mnicipalityID;
  String subMunicipalityID;

  ActiveLocationParams(
      {required this.mnicipalityID, required this.subMunicipalityID});

  Map<String, dynamic> toMap() => {
        "MunicipalityID": mnicipalityID,
        "SubMunicipalityID": subMunicipalityID,
      };
}

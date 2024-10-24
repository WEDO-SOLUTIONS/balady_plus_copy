class ViolationDetailsVdRequestParams {
  int activityId;
  double latitude;
  double longitude;
  String municipalityId;
  String submunicipalityId;
  bool isVillage;

  ViolationDetailsVdRequestParams({
    required this.activityId,
    required this.latitude,
    required this.longitude,
    required this.municipalityId,
    required this.submunicipalityId,
    required this.isVillage,
  });

  toMap() => {
        // "activityId": activityId,
        "latitude": latitude,
        "longitude": longitude,
        "MunicipalityID": municipalityId,
        "SubMunicipalityID": submunicipalityId,
        "isVillage": isVillage,
      };
}

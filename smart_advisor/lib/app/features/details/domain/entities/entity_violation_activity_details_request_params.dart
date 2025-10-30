class EntityViolationActivityDetailsRequestParams {
  int activityID;
  double latitude;
  double longitude;
  String municipalityId;
  String submunicipalityId;
  String violationID;
  int noOfOccurences;

  bool isVillage;

  EntityViolationActivityDetailsRequestParams(
      {required this.activityID,
      required this.latitude,
      required this.longitude,
      required this.municipalityId,
      required this.submunicipalityId,
      required this.violationID,
      required this.noOfOccurences,
      required this.isVillage});

  toMap() => {
        "activityId": activityID,
        "violationID": violationID,
        "latitude": latitude,
        "longitude": longitude,
        "municipalityId": municipalityId,
        "submunicipalityId": submunicipalityId,
        "noOfOccurences": noOfOccurences,
        "isVillage": isVillage,
      };
}

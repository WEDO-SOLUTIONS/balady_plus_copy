class PermitRequestParams {
  List<int> activityIds;
  double latitude;
  double longitude;

  PermitRequestParams(
      {required this.activityIds,
      required this.latitude,
      required this.longitude});

  toMap() => {
        "activityIds": activityIds.join(","),
        "latitude": latitude,
        "longitude": longitude,
        // "municipalityId": "1"
      };
}

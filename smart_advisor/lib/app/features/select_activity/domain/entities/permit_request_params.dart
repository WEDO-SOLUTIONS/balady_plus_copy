class PermitRequestParams {
  List<int> activityIds;
  double latitude;
  double longitude;

  PermitRequestParams(
      {required this.activityIds,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "latitude": latitude,
      "longitude": longitude,
    };
    for (var e in activityIds) {
      map["activityIds"] = e;
    }

    return map;
  }
}

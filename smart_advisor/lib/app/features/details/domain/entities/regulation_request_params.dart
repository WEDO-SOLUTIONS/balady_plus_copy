class RegulationRequestParams {
  int serviceType;
  double lat;
  double lng;
  double area;
  int activityId;

  RegulationRequestParams(
      {required this.activityId,
      required this.serviceType,
      required this.lat,
      required this.lng,
      required this.area});

  toMap() => {"serviceType": serviceType, "lat": lat, "lng": lng, "area": area};
}

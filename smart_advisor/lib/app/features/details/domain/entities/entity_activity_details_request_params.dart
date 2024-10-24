class EntityActivityDetailRequestParams {
  int serviceType;
  double latitude;
  double longitude;
  double shopArea;
  int mainActivityId;

  EntityActivityDetailRequestParams(
      {required this.mainActivityId,
      required this.serviceType,
      required this.latitude,
      required this.longitude,
      required this.shopArea});

  toMap() => {
        "serviceType": serviceType,
        "latitude": latitude,
        "longitude": longitude,
        "shopArea": shopArea,
        'mainActivityId': mainActivityId
      };
}

class ValidateAdditionalActivitiesParams {
  final List<(int, double?)>? addetionalActivites;

  final int mainActivityId;
  final double shopArea;
  ValidateAdditionalActivitiesParams({
    this.addetionalActivites,
    required this.mainActivityId,
    required this.shopArea,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'additionalActivities': addetionalActivites
          ?.map((x) => {"activityId": x.$1, "area": x.$2})
          .toList(),
      'mainActivityId': mainActivityId,
      'shopArea': shopArea,
    };
  }
}

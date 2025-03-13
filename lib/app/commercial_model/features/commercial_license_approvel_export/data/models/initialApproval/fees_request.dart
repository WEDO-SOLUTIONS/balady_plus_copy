class FeesRequest {
  FeesRequest({
      this.latitude, 
      this.longitude, 
      this.mainDetailedActivityId,
      this.requestId,
  });


  String? latitude;
  String? longitude;
  int? mainDetailedActivityId;
  int? requestId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['mainDetailedActivityId'] = mainDetailedActivityId;
    return map;
  }

}
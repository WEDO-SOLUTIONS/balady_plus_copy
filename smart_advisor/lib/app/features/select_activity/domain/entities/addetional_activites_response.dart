/*class AddetionalActivitesResponse {
  List<AddetionalActivityItem> result;

  AddetionalActivitesResponse({
    required this.result,
  });

  AddetionalActivitesResponse copyWith({
    List<AddetionalActivityItem>? result,
  }) =>
      AddetionalActivitesResponse(
        result: result ?? this.result,
      );
}*/

class AddetionalActivityItem {
  int activityId;
  String activityName;
  int isicNumber;
  String isicName;
  int masterActivityId;
  String masterActivityName;
  double? maxArea;
  double? minArea;
  bool homogeneous;
  bool? isSelected;
  double? area;

  AddetionalActivityItem(
      {required this.activityId,
      required this.activityName,
      required this.isicNumber,
      required this.isicName,
      required this.masterActivityId,
      required this.masterActivityName,
       this.maxArea,
       this.minArea,
      required this.homogeneous,
      this.isSelected,
      this.area});

  AddetionalActivityItem copyWith(
          {int? activityId,
          String? activityName,
          int? isicNumber,
          String? isicName,
          int? masterActivityId,
          String? masterActivityName,
          double? maxArea,
          double? minArea,
          bool? homogeneous,
          bool? isSelected,
          double? area}) =>
      AddetionalActivityItem(
          isSelected: isSelected ?? this.isSelected,
          activityId: activityId ?? this.activityId,
          activityName: activityName ?? this.activityName,
          isicNumber: isicNumber ?? this.isicNumber,
          isicName: isicName ?? this.isicName,
          masterActivityId: masterActivityId ?? this.masterActivityId,
          masterActivityName: masterActivityName ?? this.masterActivityName,
          maxArea: maxArea ?? this.maxArea,
          minArea: minArea ?? this.minArea,
          homogeneous: homogeneous ?? this.homogeneous,
          area: area ?? this.area);

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "activityName": activityName,
        "isicNumber": isicNumber,
        "isicName": isicName,
        "masterActivityId": masterActivityId,
        "masterActivityName": masterActivityName,
        "maxArea": maxArea,
        "minArea": minArea,
        "homogeneous": homogeneous,
      };
}

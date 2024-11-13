import '../../domain/entities/addetional_activites_response.dart';

/*class AddetionalActivitesResponseModel extends AddetionalActivitesResponse {
  AddetionalActivitesResponseModel({
    required super.result,
  });

  factory AddetionalActivitesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      AddetionalActivitesResponseModel(
        result: List<AddetionalActivityItem>.from(
            json["result"].map((x) => AddetionalActivityItemModel.fromJson(x))),
      );
}*/

class AddetionalActivityItemModel extends AddetionalActivityItem {
  AddetionalActivityItemModel({
    required super.activityId,
    required super.activityName,
    required super.isicNumber,
    required super.isicName,
    required super.masterActivityId,
    required super.masterActivityName,
    super.maxArea,
    super.minArea,
    required super.homogeneous,
  });

  factory AddetionalActivityItemModel.fromJson(Map<String, dynamic> json) =>
      AddetionalActivityItemModel(
        activityId: json["activityId"] ?? 0,
        activityName: json["activityName"] ?? "",
        isicNumber: json["isicNumber"] ?? 0,
        isicName: json["isicName"] ?? "",
        masterActivityId: json["masterActivityId"] ?? 0,
        masterActivityName: json["masterActivityName"] ?? "",
        maxArea: json["maxArea"]?.toDouble() ?? 0,
        minArea: json["minArea"]?.toDouble() ?? 0,
        homogeneous: json["homogeneous"] ?? false,
      );

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

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
    required super.maxArea,
    required super.minArea,
    required super.homogeneous,
  });

  factory AddetionalActivityItemModel.fromJson(Map<String, dynamic> json) =>
      AddetionalActivityItemModel(
        activityId: json["activityId"],
        activityName: json["activityName"],
        isicNumber: json["isicNumber"],
        isicName: json["isicName"],
        masterActivityId: json["masterActivityId"],
        masterActivityName: json["masterActivityName"],
        maxArea: json["maxArea"]?.toDouble(),
        minArea: json["minArea"]?.toDouble(),
        homogeneous: json["homogeneous"],
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

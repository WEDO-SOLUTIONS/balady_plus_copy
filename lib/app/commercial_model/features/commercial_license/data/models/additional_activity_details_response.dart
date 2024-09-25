import '../../../../../features/_shared_feature_/data/entities/drop_down_item.dart';

class AddetionalActivityDetailsResponse {
  final List<AddetionalActivityItemDetails>? result;

  AddetionalActivityDetailsResponse({
    this.result,
  });

  factory AddetionalActivityDetailsResponse.fromJson(
          Map<String, dynamic> json) =>
      AddetionalActivityDetailsResponse(
        result: json["result"] == null
            ? []
            : List<AddetionalActivityItemDetails>.from(json["result"]!
                .map((x) => AddetionalActivityItemDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class AddetionalActivityItemDetails extends DropDownItem {
  final int? activityId;
  final String? activityName;
  final int? isicNumber;
  final String? isicName;
  final int? masterActivityId;
  final String? masterActivityName;
  final double? maxArea;
  final double? minArea;
  final bool? homogeneous;

  AddetionalActivityItemDetails({
    this.activityId,
    this.activityName,
    this.isicNumber,
    this.isicName,
    this.masterActivityId,
    this.masterActivityName,
    this.maxArea,
    this.minArea,
    this.homogeneous,
  }) : super(
          id: activityId ?? '',
          name: isicName ?? '',
        );

  factory AddetionalActivityItemDetails.fromJson(Map<String, dynamic> json) =>
      AddetionalActivityItemDetails(
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

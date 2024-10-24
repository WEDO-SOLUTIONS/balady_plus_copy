import '/app/features/map/domain/entities/validate_point_response.dart';

class ValidatePointResponseModel extends ValidatePointResponse {
  ValidatePointResponseModel({
    super.zoneId,
    super.activityId,
    super.allowed,
  });

  factory ValidatePointResponseModel.fromJson(Map<String, dynamic> json) =>
      ValidatePointResponseModel(
        zoneId: json["zoneId"],
        activityId: json["activityId"],
        allowed: json["allowed"],
      );

  Map<String, dynamic> toJson() => {
        "zoneId": zoneId,
        "activityId": activityId,
        "allowed": allowed,
      };
}

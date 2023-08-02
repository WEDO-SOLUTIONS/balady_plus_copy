import '../../commercial_license_exports.dart';

class SubActivityModel extends SubActivityEntity {
  const SubActivityModel({
    int? id,
    String? name,
    String? eName,
    int? entityType,
    bool? foodActivity,
  }) : super(
          activityName: name ?? '',
          activityId: id ?? 0,
          entityType: entityType ?? 0,
        );

  factory SubActivityModel.fromJson(Map<String, dynamic> json) =>
      SubActivityModel(
        id: json["id"],
        name: json["name"],
        eName: json["ename"],
        entityType: json["entityType"],
        foodActivity: json["foodActivity"],
      );
}

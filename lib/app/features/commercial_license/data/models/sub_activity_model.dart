import '../../commercial_license_exports.dart';

class SubActivityModel extends SubActivityEntity {
  const SubActivityModel(
      {final int? id,
      final String? activityName,
      final int? facilityId,
      final String? facilityName})
      : super(
            activityName: activityName ?? '',
            id: id ?? 0,
            facilityId: facilityId ?? 0,
            facilityName: facilityName ?? '');

  factory SubActivityModel.fromJson(Map<String, dynamic> json) =>
      SubActivityModel(
        id: json["id"],
        activityName: json["name"],
        facilityId: json["facilityId"],
        facilityName: json["facilityName"],
      );
}

import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/data/models/profile_model.dart';

class UpdateDeviceResponseModel extends UpdateDeviceResponse {
  UpdateDeviceResponseModel(
      {super.id, super.name, super.notificationToken, super.os, super.type});

  factory UpdateDeviceResponseModel.fromMap(Map<String, dynamic> json) =>
      UpdateDeviceResponseModel(
        id: json["id"],
        name: json["name"],
        notificationToken: json["notificationToken"],
        os: json["os"],
        type: json["type"] != null ? TypeModel.fromMap(json["type"]) : null,
      );
}

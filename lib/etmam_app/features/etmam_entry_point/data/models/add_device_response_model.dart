import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/data/models/profile_model.dart';

class AddDeviceResponseModel extends AddDeviceResponse {
  AddDeviceResponseModel(
      {super.id, super.name, super.notificationToken, super.os, super.type});

  factory AddDeviceResponseModel.fromMap(Map<String, dynamic> json) =>
      AddDeviceResponseModel(
        id: json["id"],
        name: json["name"],
        notificationToken: json["notificationToken"],
        os: json["os"],
        type: json["type"] != null ? TypeModel.fromMap(json["type"]) : null,
      );
}

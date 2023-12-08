import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/profile.dart';

class UpdateDeviceResponse {
  String? id;
  Type? type;
  String? name;
  String? os;
  String? notificationToken;

  UpdateDeviceResponse(
      {this.id, this.name, this.notificationToken, this.os, this.type});
}

import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/profile.dart';

class AddDeviceResponse {
  String? id;
  Type? type;
  String? name;
  String? os;
  String? notificationToken;

  AddDeviceResponse(
      {this.id, this.name, this.notificationToken, this.os, this.type});
}

import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart'
    show ForceUpdateResponse;

class ForceUpdateResponseModel extends ForceUpdateResponse {
  ForceUpdateResponseModel(
      {super.forceUpdate, super.type, super.versionNumber});

  factory ForceUpdateResponseModel.fromMap(Map<String, dynamic> json) =>
      ForceUpdateResponseModel(
        forceUpdate: json["ForceUpdate"],
        type: json["Type"],
        versionNumber: json["VersionNumber"],
      );
}

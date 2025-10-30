import 'package:balady_plus/app/features/vd/vd_exports.dart' show OTPResponse;
import 'package:equatable/equatable.dart';

class OTPResponseModel extends OTPResponse {
  OTPResponseModel({super.referenceId});

  factory OTPResponseModel.fromMap(Map<String, dynamic> json) =>
      OTPResponseModel(
        referenceId: json["referenceId"],
      );
}

import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart'
    show SendOTPResponse;

class SendOTPResponseModel extends SendOTPResponse {
  SendOTPResponseModel({super.expireSeconds, super.otpId});

  factory SendOTPResponseModel.fromMap(Map<String, dynamic> json) =>
      SendOTPResponseModel(
        expireSeconds: json["expireSeconds"],
        otpId: json["otpId"],
      );
}

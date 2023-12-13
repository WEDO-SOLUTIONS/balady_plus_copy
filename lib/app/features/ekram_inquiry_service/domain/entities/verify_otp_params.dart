class VerifyOTPParams {
  String guid;
  String otp;

  VerifyOTPParams({
    required this.guid,
    required this.otp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{};
  }
}

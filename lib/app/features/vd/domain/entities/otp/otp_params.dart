class OTPParams {
  String mobileNumber;
  bool? showOTPPage;
  OTPParams({required this.mobileNumber, this.showOTPPage = true});

  Map<String, dynamic> toMap() {
    return {
      "MobileNumber": mobileNumber,
    };
  }
}

class RenewApplyRequest {
  int licenseId;
  String mobileNumber;
  String submitterBirthDate;
  RenewApplyRequest({
    required this.licenseId,
    required this.mobileNumber,
    required this.submitterBirthDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "mobileNumber": mobileNumber,
      "submitterBirthDate": submitterBirthDate
    };
  }
}

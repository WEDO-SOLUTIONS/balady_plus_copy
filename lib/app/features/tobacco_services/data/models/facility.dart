class Facility {
  String? registrationNumber;
  String? authenticationNumber;
  String? facilityName;
  String? baladyLicenseNo;
  String? municipalityArabicName;
  String? townshipArabicName;
  double accountBalance;
  bool isApproved;
  DateTime? createdDate;

  Facility({
    this.registrationNumber,
    this.authenticationNumber,
    this.facilityName,
    this.baladyLicenseNo,
    this.municipalityArabicName,
    this.townshipArabicName,
    this.accountBalance = 0.0,
    this.isApproved = false,
    this.createdDate,
  });

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        registrationNumber: json["registrationNumber"],
        authenticationNumber: json["authenticationNumber"],
        facilityName: json["facilityName"],
        baladyLicenseNo: json["baladyLicenseNo"],
        municipalityArabicName: json["municipalityArabicName"],
        townshipArabicName: json["townshipArabicName"],
        accountBalance: (json["accountBalance"] ?? 0) + 0.0,
        isApproved: json["isApproved"],
        createdDate: DateTime.parse(json["createdDate"]),
      );
}

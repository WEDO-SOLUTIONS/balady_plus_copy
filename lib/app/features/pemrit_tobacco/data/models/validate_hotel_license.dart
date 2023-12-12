class PermitTobaccoValidateHotelLicense {
  final int? licenseNumber;
  final int? hotelClass;
  final String? hotelName;

  PermitTobaccoValidateHotelLicense({
    this.licenseNumber,
    this.hotelClass,
    this.hotelName,
  });

  factory PermitTobaccoValidateHotelLicense.fromJson(
          Map<String, dynamic> json) =>
      PermitTobaccoValidateHotelLicense(
        licenseNumber: json["licenseNumber"],
        hotelClass: json["hotelClass"],
        hotelName: json["hotelName"],
      );

  Map<String, dynamic> toJson() => {
        "licenseNumber": licenseNumber,
        "hotelClass": hotelClass,
        "hotelName": hotelName,
      };
}

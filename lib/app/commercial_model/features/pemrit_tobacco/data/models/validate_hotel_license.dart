// ignore_for_file: public_member_api_docs, sort_constructors_first
class PermitTobaccoValidateHotelLicense {
  final int? licenseNumber;
  final HotelClass? hotelClass;
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
        hotelClass: json["hotelClass"] != null
            ? HotelClass.fromJson(json["hotelClass"])
            : null,
        hotelName: json["hotelName"],
      );

  Map<String, dynamic> toJson() => {
        "licenseNumber": licenseNumber,
        "hotelClass": hotelClass,
        "hotelName": hotelName,
      };
}

class HotelClass {
  int? id;

  String? name;
  HotelClass({
    this.id,
    this.name,
  });

  factory HotelClass.fromJson(Map<String, dynamic> json) => HotelClass(
        id: json["id"],
        name: json["name"],
      );
}

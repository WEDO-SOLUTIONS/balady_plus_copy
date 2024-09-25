class CommercialLicensePermits {
  bool accepted;
  String expirationDate;
  int id;
  int permitNumber;
  String permitType;
  bool selected;

  CommercialLicensePermits({
    required this.accepted,
    required this.expirationDate,
    required this.id,
    required this.permitNumber,
    required this.permitType,
    required this.selected,
  });

  factory CommercialLicensePermits.fromJson(Map<String, dynamic> json) =>
      CommercialLicensePermits(
        accepted: json["accepted"] ?? false,
        expirationDate: json["expirationDate"],
        id: json["id"],
        permitNumber: json["permitNumber"],
        permitType: json["permitType"],
        selected: json["selected"],
      );

  Map<String, dynamic> toJson() => {
        "accepted": accepted,
        "expirationDate": expirationDate,
        "id": id,
        "permitNumber": permitNumber,
        "permitType": permitType,
        "selected": selected,
      };
}

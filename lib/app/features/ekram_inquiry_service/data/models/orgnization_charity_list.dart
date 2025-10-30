class EkramCharityOrgnizationResponse {
  final List<EkramCharityOrgnizationItem>? result;

  EkramCharityOrgnizationResponse({
    this.result,
  });

  factory EkramCharityOrgnizationResponse.fromJson(Map<String, dynamic> json) =>
      EkramCharityOrgnizationResponse(
        result: json["result"] == null
            ? []
            : List<EkramCharityOrgnizationItem>.from(json["result"]!
                .map((x) => EkramCharityOrgnizationItem.fromJson(x))),
      );
}

class EkramCharityOrgnizationItem {
  final String? orgName;
  final int? districtId;
  final String? districtName;
  final String? municipalityId;
  final String? municipalityName;
  final String? submunicipalityId;
  final String? submunicipalityName;
  final int? streetId;
  final String? streetName;
  final String? x;
  final String? y;
  final String? krokiAttachUrl;
  final String? locationViewerUrl;
  final int? cityId;
  final String? cityName;
  final dynamic email;
  final String? mobileNo1;
  final String? mobileNo2;
  final List<OrgRepresentative>? orgRepresentatives;

  EkramCharityOrgnizationItem({
    this.orgName,
    this.districtId,
    this.districtName,
    this.municipalityId,
    this.municipalityName,
    this.submunicipalityId,
    this.submunicipalityName,
    this.streetId,
    this.streetName,
    this.x,
    this.y,
    this.krokiAttachUrl,
    this.locationViewerUrl,
    this.cityId,
    this.cityName,
    this.email,
    this.mobileNo1,
    this.mobileNo2,
    this.orgRepresentatives,
  });

  factory EkramCharityOrgnizationItem.fromJson(Map<String, dynamic> json) =>
      EkramCharityOrgnizationItem(
        orgName: json["orgName"],
        districtId: json["districtId"],
        districtName: json["districtName"],
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        submunicipalityId: json["submunicipalityId"],
        submunicipalityName: json["submunicipalityName"],
        streetId: json["streetId"],
        streetName: json["streetName"],
        x: json["x"],
        y: json["y"],
        krokiAttachUrl: json["krokiAttachUrl"],
        locationViewerUrl: json["locationViewerUrl"],
        cityId: json["cityId"],
        cityName: json["cityName"],
        email: json["email"],
        mobileNo1: json["mobileNo1"],
        mobileNo2: json["mobileNo2"],
        orgRepresentatives: json["orgRepresentatives"] == null
            ? []
            : List<OrgRepresentative>.from(json["orgRepresentatives"]!
                .map((x) => OrgRepresentative.fromJson(x))),
      );
}

class OrgRepresentative {
  final String? name;
  final String? mobileNo;
  final String? email;

  OrgRepresentative({
    this.name,
    this.mobileNo,
    this.email,
  });

  factory OrgRepresentative.fromJson(Map<String, dynamic> json) =>
      OrgRepresentative(
        name: json["name"],
        mobileNo: json["mobileNo"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobileNo": mobileNo,
        "email": email,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

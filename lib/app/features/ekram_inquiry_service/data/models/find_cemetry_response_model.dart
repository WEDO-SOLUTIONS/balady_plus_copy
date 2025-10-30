class FindCemetryResponse {
  final List<FindCemetryItem>? result;

  FindCemetryResponse({
    this.result,
  });

  factory FindCemetryResponse.fromJson(Map<String, dynamic> json) =>
      FindCemetryResponse(
        result: json["result"] == null
            ? []
            : List<FindCemetryItem>.from(
                json["result"]!.map((x) => FindCemetryItem.fromJson(x))),
      );
}

class FindCemetryItem {
  final int? cemeteryId;
  final String? cemeteryName;
  final int? districtId;
  final String? districtName;
  final dynamic krokiAttachUrl;
  final String? locationViewerUrl;
  final String? municipalityId;
  final String? municipalityName;
  final String? submunicipalityId;
  final String? submunicipalityName;
  final int? streetId;
  final String? streetName;
  final String? x;
  final String? y;
  final int? cityId;
  final String? cityName;
  final bool? laundryExist;
  final bool? needApproval;

  FindCemetryItem({
    this.cemeteryId,
    this.cemeteryName,
    this.districtId,
    this.districtName,
    this.krokiAttachUrl,
    this.locationViewerUrl,
    this.municipalityId,
    this.municipalityName,
    this.submunicipalityId,
    this.submunicipalityName,
    this.streetId,
    this.streetName,
    this.x,
    this.y,
    this.cityId,
    this.cityName,
    this.laundryExist,
    this.needApproval,
  });

  factory FindCemetryItem.fromJson(Map<String, dynamic> json) =>
      FindCemetryItem(
        cemeteryId: json["cemeteryId"],
        cemeteryName: json["cemeteryName"],
        districtId: json["districtId"],
        districtName: json["districtName"],
        krokiAttachUrl: json["krokiAttachUrl"],
        locationViewerUrl: json["locationViewerUrl"],
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        submunicipalityId: json["submunicipalityId"],
        submunicipalityName: json["submunicipalityName"],
        streetId: json["streetId"],
        streetName: json["streetName"],
        x: json["x"],
        y: json["y"],
        cityId: json["cityId"],
        cityName: json["cityName"],
        laundryExist: json["laundryExist"],
        needApproval: json["needApproval"],
      );
}

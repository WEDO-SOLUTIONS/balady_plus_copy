class PermitsLicensesResponse {
  final List<PermitsLicensesItem>? result;

  PermitsLicensesResponse({
    this.result,
  });

  factory PermitsLicensesResponse.fromJson(Map<String, dynamic> json) =>
      PermitsLicensesResponse(
        result: json["result"] == null
            ? []
            : List<PermitsLicensesItem>.from(
                json["result"]!.map((x) => PermitsLicensesItem.fromJson(x))),
      );
}

class PermitsLicensesItem {
  final int? licenseId;
  final int? requestId;
  final int? requestTypeId;
  final String? requestTypeName;
  final int? statusId;
  final String? statusName;
  final String? licenseExpirationDate;
  final int? municipalityId;
  final String? municipalityName;
  final int? subMunicipalityId;
  final String? subMunicipalityName;

  PermitsLicensesItem({
    this.licenseId,
    this.requestId,
    this.requestTypeId,
    this.requestTypeName,
    this.statusId,
    this.statusName,
    this.licenseExpirationDate,
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.subMunicipalityName,
  });

  factory PermitsLicensesItem.fromJson(Map<String, dynamic> json) =>
      PermitsLicensesItem(
        licenseId: json["licenseId"],
        requestId: json["requestId"],
        requestTypeId: json["requestTypeId"],
        requestTypeName: json["requestTypeName"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        licenseExpirationDate: json["licenseExpirationDate"],
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        subMunicipalityId: json["subMunicipalityId"],
        subMunicipalityName: json["subMunicipalityName"],
      );
}

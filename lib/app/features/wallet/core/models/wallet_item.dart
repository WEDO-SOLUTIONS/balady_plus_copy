import '../../../../core/services/local/helpers.dart';

class WalletItem {
  WalletItem(
      {this.owner,
      this.ownerId,
      this.activityName,
      this.marketName,
      //    this.municipalityName,
      this.locationNumber,
      this.startDateHijri,
      this.endDateHijri,
      this.startDate,
      this.endDate,
      this.licenseId,
      this.qrUrl,
      this.type,
      this.uuid,
      this.imageUrl,
      this.municipilityName,
      this.municipilityId,
      this.subMunicipilityId,
      this.subMunicipilityName,
      this.typeName,
      this.qrData});

  String? owner;
  dynamic ownerId;
  String? activityName;
  String? marketName;
  //String? municipalityName;
  dynamic locationNumber;
  String? startDateHijri;
  String? endDateHijri;
  dynamic startDate;
  dynamic endDate;
  dynamic licenseId;
  String? qrUrl;
  int? type;
  String? uuid;
  String? imageUrl;
  String? municipilityName;
  String? subMunicipilityName;
  dynamic municipilityId;
  dynamic subMunicipilityId;
  String? typeName;
  String? qrData;

  factory WalletItem.fromJson(Map<String, dynamic> json) => WalletItem(
      owner: json["owner"],
      ownerId: json["ownerId"],
      activityName: json["activityName"],
      marketName: json["marketName"],
      //  municipalityName: json["municipalityName"],
      locationNumber: json["locationNumber"],
      startDateHijri: json["startDateHijri"],
      endDateHijri: json["endDateHijri"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      licenseId: json["licenseId"],
      qrUrl: json["qrUrl"],
      type: json["typeId"],
      uuid: json["uuid"],
      imageUrl: json["imageUrl"],
      municipilityName: json["municipilityName"],
      municipilityId: json["municipilityId"],
      subMunicipilityId: json["subMunicipilityId"],
      subMunicipilityName: json["subMunicipilityName"],
      typeName: json["typeName"],
      qrData: json["qrData"]);

  Map<String, dynamic> toJson() => {
        "owner": owner,
        "ownerId": ownerId,
        "activityName": activityName,
        "marketName": marketName,
        //   "municipalityName": municipalityName,
        "locationNumber": locationNumber,
        "startDateHijri": startDateHijri,
        "endDateHijri": endDateHijri,
        "startDate": startDate,
        "endDate": endDate,
        "licenseId": licenseId,
        "qrUrl": qrUrl,
        "typeId": type,
        "uuid": uuid,
        "imageUrl": imageUrl,
        "municipilityName": municipilityName,
        "municipilityId": municipilityId,
        "subMunicipilityId": subMunicipilityId,
        "subMunicipilityName": subMunicipilityName,
        "typeName": typeName,
        "qrData": qrData
      };

  String getName() {
    // return owner ?? userInfo?.arName ?? "";
    return owner ?? "";
  }

  String getOwnerId() {
    // return ownerId ?? userInfo?.idNo ?? "";
    return ownerId ?? "";
  }

  LicenseTypes getLicenseType() {
    switch (type) {
      case 1300:
        return LicenseTypes.health;
      case 1400:
        return LicenseTypes.peddler;
      default:
        return LicenseTypes.none;
    }
  }

  String getLicenseHeaderText() {
    if (getLicenseType() == LicenseTypes.health)
      return Helpers.translatingWord("health_certificate");
    else if (getLicenseType() == LicenseTypes.peddler)
      return Helpers.translatingWord("peddler_license");
    else
      return "";
  }
}

enum LicenseTypes { health, peddler, none }

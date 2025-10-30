import 'dart:ui';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/paths/image_paths.dart';

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
      this.type,
      this.uuid,
      this.imageUrl,
      this.municipilityName,
      this.municipilityId,
      this.subMunicipilityId,
      this.subMunicipilityName,
      this.typeName,
      this.qrData,
      this.requestId});

  String? owner;
  dynamic ownerId;
  String? activityName;
  String? marketName;
  //String? municipalityName;
  int? requestId;
  dynamic locationNumber;
  String? startDateHijri;
  String? endDateHijri;
  dynamic startDate;
  dynamic endDate;
  dynamic licenseId;
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
      type: json["typeId"],
      uuid: json["uuid"],
      imageUrl: json["imageUrl"],
      municipilityName: json["municipilityName"],
      municipilityId: json["municipilityId"],
      subMunicipilityId: json["subMunicipilityId"],
      subMunicipilityName: json["subMunicipilityName"],
      typeName: json["typeName"],
      qrData: json["qrData"],
      requestId: json["requestId"]);

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
      return Helpers.translatingWord("digital_health_cert");
    else if (getLicenseType() == LicenseTypes.peddler)
      return Helpers.translatingWord("peddler_license");
    else
      return "";
  }

  String getLicenseImage() {
    if (getLicenseType() == LicenseTypes.health)
      return "${ImagePath.visaBg}1.png";
    else if (getLicenseType() == LicenseTypes.peddler)
      return "${ImagePath.visaBg}2.png";
    else
      return "";
  }

  Color getLicenseDetailsColor() {
    return Color(0xFFE1F6F6);
    if (getLicenseType() == LicenseTypes.health)
      return Color(0x264CD080);
    else if (getLicenseType() == LicenseTypes.peddler)
      return Color(0xFFE1F6F6);
    else
      return Color(0xFFE1F6F6);
  }
}

enum LicenseTypes { health, peddler, none }

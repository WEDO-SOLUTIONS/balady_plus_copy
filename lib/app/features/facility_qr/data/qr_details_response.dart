// To parse this JSON data, do
//
//     final QrDetailsResponse = QrDetailsResponseFromJson(jsonString);

import 'dart:convert';

QrDetailsResponse QrDetailsResponseFromJson(String str) =>
    QrDetailsResponse.fromJson(json.decode(str));

String QrDetailsResponseToJson(QrDetailsResponse data) =>
    json.encode(data.toJson());

class QrDetailsResponse {
  QrDetailsResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory QrDetailsResponse.fromJson(Map<String, dynamic> json) =>
      QrDetailsResponse(
        statusDetails: json["statusDetails"] == null
            ? null
            : List<StatusDetail>.from(
                json["statusDetails"].map((x) => StatusDetail.fromJson(x))),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails == null
            ? null
            : List<dynamic>.from(statusDetails!.map((x) => x.toJson())),
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  int? responseCode;
  String? responseMessage;
  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result == null ? null : result!.toJson(),
      };
}

class Result {
  Result({
    this.requestId,
    this.requestDate,
    this.currentTabId,
    this.statusId,
    this.statusName,
    this.typeId,
    this.typeName,
    this.submitterInfo,
    this.comLicenseInfo,
    this.enterpriseInfo,
    this.workTimes,
    this.qrCodeAdditionalInfo,
    this.attachments,
    this.ratingInfo,
  });

  int? requestId;
  String? requestDate;
  int? currentTabId;
  int? statusId;
  String? statusName;
  int? typeId;
  String? typeName;
  SubmitterInfo? submitterInfo;
  ComLicenseInfo? comLicenseInfo;
  EnterpriseInfo? enterpriseInfo;
  WorkTimes? workTimes;
  QrCodeAdditionalInfo? qrCodeAdditionalInfo;
  List<Attachment>? attachments;
  RatingInfo? ratingInfo;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        requestId: json["requestId"],
        requestDate: json["requestDate"],
        currentTabId: json["currentTabId"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        typeId: json["typeId"],
        typeName: json["typeName"],
        submitterInfo: json["submitterInfo"] == null
            ? null
            : SubmitterInfo.fromJson(json["submitterInfo"]),
        comLicenseInfo: json["comLicenseInfo"] == null
            ? null
            : ComLicenseInfo.fromJson(json["comLicenseInfo"]),
        enterpriseInfo: json["enterpriseInfo"] == null
            ? null
            : EnterpriseInfo.fromJson(json["enterpriseInfo"]),
        workTimes: json["workTimes"] == null
            ? null
            : WorkTimes.fromJson(json["workTimes"]),
        qrCodeAdditionalInfo: json["qrCodeAdditionalInfo"] == null
            ? null
            : QrCodeAdditionalInfo.fromJson(json["qrCodeAdditionalInfo"]),
        attachments: json["attachments"] == null
            ? null
            : List<Attachment>.from(
                json["attachments"].map((x) => Attachment.fromJson(x))),
        ratingInfo: json["ratingInfo"] == null
            ? null
            : RatingInfo.fromJson(json["ratingInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "requestDate": requestDate,
        "currentTabId": currentTabId,
        "statusId": statusId,
        "statusName": statusName,
        "typeId": typeId,
        "typeName": typeName,
        "submitterInfo": submitterInfo == null ? null : submitterInfo!.toJson(),
        "comLicenseInfo":
            comLicenseInfo == null ? null : comLicenseInfo!.toJson(),
        "enterpriseInfo":
            enterpriseInfo == null ? null : enterpriseInfo!.toJson(),
        "workTimes": workTimes == null ? null : workTimes!.toJson(),
        "qrCodeAdditionalInfo": qrCodeAdditionalInfo == null
            ? null
            : qrCodeAdditionalInfo!.toJson(),
        "attachments": attachments == null
            ? null
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
        "ratingInfo": ratingInfo == null ? null : ratingInfo!.toJson(),
      };
}

class Attachment {
  Attachment({
    this.code,
    this.typeId,
    this.typeName,
    this.notes,
  });

  String? code;
  int? typeId;
  String? typeName;
  dynamic notes;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        code: json["code"],
        typeId: json["typeId"],
        typeName: json["typeName"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "typeId": typeId,
        "typeName": typeName,
        "notes": notes,
      };
}

class ComLicenseInfo {
  ComLicenseInfo({
    this.licenseUuid,
    this.licenseId,
    this.licenseIssDate,
    this.licenseExpirationDate,
    this.licenseStatusId,
    this.licenseStatusName,
    this.boardsInfo,
    this.activityInfo,
    this.entityType,
    this.shopArea,
    this.shopInfo,
    this.vehicleInfo,
    this.locationInfo,
    this.has24HourPermit,
    this.facilityClassificationId,
    this.facilityClassification,
  });

  String? licenseUuid;
  int? licenseId;
  String? licenseIssDate;
  String? licenseExpirationDate;
  int? licenseStatusId;
  String? licenseStatusName;
  List<BoardsInfo>? boardsInfo;
  ActivityInfo? activityInfo;
  String? entityType;
  dynamic shopArea;
  ShopInfo? shopInfo;
  dynamic vehicleInfo;
  LocationInfo? locationInfo;
  bool? has24HourPermit;
  dynamic facilityClassificationId;
  dynamic facilityClassification;

  factory ComLicenseInfo.fromJson(Map<String, dynamic> json) => ComLicenseInfo(
        licenseUuid: json["licenseUuid"],
        licenseId: json["licenseId"],
        licenseIssDate: json["licenseIssDate"],
        licenseExpirationDate: json["licenseExpirationDate"],
        licenseStatusId: json["licenseStatusId"],
        licenseStatusName: json["licenseStatusName"],
        boardsInfo: json["boardsInfo"] == null
            ? null
            : List<BoardsInfo>.from(
                json["boardsInfo"].map((x) => BoardsInfo.fromJson(x))),
        activityInfo: json["activityInfo"] == null
            ? null
            : ActivityInfo.fromJson(json["activityInfo"]),
        entityType: json["entityType"],
        shopArea: json["shopArea"],
        shopInfo: json["shopInfo"] == null
            ? null
            : ShopInfo.fromJson(json["shopInfo"]),
        vehicleInfo: json["vehicleInfo"],
        locationInfo: json["locationInfo"] == null
            ? null
            : LocationInfo.fromJson(json["locationInfo"]),
        has24HourPermit: json["has24HourPermit"],
        facilityClassificationId: json["facilityClassificationId"],
        facilityClassification: json["facilityClassification"],
      );

  Map<String, dynamic> toJson() => {
        "licenseUuid": licenseUuid,
        "licenseId": licenseId,
        "licenseIssDate": licenseIssDate,
        "licenseExpirationDate": licenseExpirationDate,
        "licenseStatusId": licenseStatusId,
        "licenseStatusName": licenseStatusName,
        "boardsInfo": boardsInfo == null
            ? null
            : List<dynamic>.from(boardsInfo!.map((x) => x.toJson())),
        "activityInfo": activityInfo == null ? null : activityInfo!.toJson(),
        "entityType": entityType,
        "shopArea": shopArea,
        "shopInfo": shopInfo == null ? null : shopInfo!.toJson(),
        "vehicleInfo": vehicleInfo,
        "locationInfo": locationInfo == null ? null : locationInfo!.toJson(),
        "has24HourPermit": has24HourPermit,
        "facilityClassificationId": facilityClassificationId,
        "facilityClassification": facilityClassification,
      };
}

class ActivityInfo {
  ActivityInfo({
    this.mainActivity,
    this.additionalActivities,
  });

  MainActivity? mainActivity;
  dynamic additionalActivities;

  factory ActivityInfo.fromJson(Map<String, dynamic> json) => ActivityInfo(
        mainActivity: json["mainActivity"] == null
            ? null
            : MainActivity.fromJson(json["mainActivity"]),
        additionalActivities: json["additionalActivities"],
      );

  Map<String, dynamic> toJson() => {
        "mainActivity": mainActivity == null ? null : mainActivity!.toJson(),
        "additionalActivities": additionalActivities,
      };
}

class MainActivity {
  MainActivity({
    this.sectorId,
    this.sectorName,
    this.sectionId,
    this.sectionName,
    this.isicNumber,
    this.isicName,
    this.activityDetailId,
    this.activityDetailName,
    this.area,
  });

  dynamic sectorId;
  dynamic sectorName;
  dynamic sectionId;
  dynamic sectionName;
  String? isicNumber;
  String? isicName;
  int? activityDetailId;
  String? activityDetailName;
  dynamic area;

  factory MainActivity.fromJson(Map<String, dynamic> json) => MainActivity(
        sectorId: json["sectorId"],
        sectorName: json["sectorName"],
        sectionId: json["sectionId"],
        sectionName: json["sectionName"],
        isicNumber: json["isicNumber"],
        isicName: json["isicName"],
        activityDetailId: json["activityDetailId"],
        activityDetailName: json["activityDetailName"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "sectorId": sectorId,
        "sectorName": sectorName,
        "sectionId": sectionId,
        "sectionName": sectionName,
        "isicNumber": isicNumber,
        "isicName": isicName,
        "activityDetailId": activityDetailId,
        "activityDetailName": activityDetailName,
        "area": area,
      };
}

class BoardsInfo {
  BoardsInfo({
    this.typeId,
    this.typeName,
    this.area,
  });

  int? typeId;
  String? typeName;
  dynamic area;

  factory BoardsInfo.fromJson(Map<String, dynamic> json) => BoardsInfo(
        typeId: json["typeId"],
        typeName: json["typeName"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "typeId": typeId,
        "typeName": typeName,
        "area": area,
      };
}

class LocationInfo {
  LocationInfo({
    this.subMunicipalityGisCode,
    this.streetCode,
    this.districtId,
    this.latitude,
    this.longitude,
    this.siteLocationType,
    this.nationalAddress,
    this.accessDirections,
    this.buildingNatureId,
    this.buildingName,
    this.siteNatureId,
    this.siteName,
    this.siteDescription,
    this.nearestLandmark,
    this.mapNumber,
    this.landNumber,
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.subMunicipalityName,
    this.streetName,
    this.districtName,
    this.regionId,
    this.regionName,
    this.buildingNatureName,
    this.siteNatureName,
    this.pathId,
    this.pathName,
    this.cityId,
    this.cityName,
    this.krokiUrl,
  });

  String? subMunicipalityGisCode;
  int? streetCode;
  int? districtId;
  double? latitude;
  double? longitude;
  String? siteLocationType;
  NationalAddress? nationalAddress;
  String? accessDirections;
  int? buildingNatureId;
  String? buildingName;
  dynamic siteNatureId;
  String? siteName;
  String? siteDescription;
  String? nearestLandmark;
  dynamic mapNumber;
  dynamic landNumber;
  String? municipalityId;
  String? municipalityName;
  String? subMunicipalityId;
  String? subMunicipalityName;
  String? streetName;
  String? districtName;
  int? regionId;
  String? regionName;
  String? buildingNatureName;
  dynamic siteNatureName;
  dynamic pathId;
  dynamic pathName;
  int? cityId;
  String? cityName;
  String? krokiUrl;

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        subMunicipalityGisCode: json["subMunicipalityGisCode"],
        streetCode: json["streetCode"],
        districtId: json["districtId"],
        latitude: json["latitude"] != null
            ? double.tryParse(json["latitude"]) != null
                ? double.parse(json["latitude"])
                : null
            : null,
        longitude: json["longitude"] != null
            ? double.tryParse(json["longitude"]) != null
                ? double.parse(json["longitude"])
                : null
            : null,
        siteLocationType: json["siteLocationType"],
        nationalAddress: json["nationalAddress"] == null
            ? null
            : NationalAddress.fromJson(json["nationalAddress"]),
        accessDirections: json["accessDirections"],
        buildingNatureId: json["buildingNatureId"],
        buildingName: json["buildingName"],
        siteNatureId: json["siteNatureId"],
        siteName: json["siteName"],
        siteDescription: json["siteDescription"],
        nearestLandmark: json["nearestLandmark"],
        mapNumber: json["mapNumber"],
        landNumber: json["landNumber"],
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        subMunicipalityId: json["subMunicipalityId"],
        subMunicipalityName: json["subMunicipalityName"],
        streetName: json["streetName"],
        districtName: json["districtName"],
        regionId: json["regionId"],
        regionName: json["regionName"],
        buildingNatureName: json["buildingNatureName"],
        siteNatureName: json["siteNatureName"],
        pathId: json["pathId"],
        pathName: json["pathName"],
        cityId: json["cityId"],
        cityName: json["cityName"],
        krokiUrl: json["krokiUrl"],
      );

  Map<String, dynamic> toJson() => {
        "subMunicipalityGisCode": subMunicipalityGisCode,
        "streetCode": streetCode,
        "districtId": districtId,
        "latitude": latitude,
        "longitude": longitude,
        "siteLocationType": siteLocationType,
        "nationalAddress":
            nationalAddress == null ? null : nationalAddress!.toJson(),
        "accessDirections": accessDirections,
        "buildingNatureId": buildingNatureId,
        "buildingName": buildingName,
        "siteNatureId": siteNatureId,
        "siteName": siteName,
        "siteDescription": siteDescription,
        "nearestLandmark": nearestLandmark,
        "mapNumber": mapNumber,
        "landNumber": landNumber,
        "municipalityId": municipalityId,
        "municipalityName": municipalityName,
        "subMunicipalityId": subMunicipalityId,
        "subMunicipalityName": subMunicipalityName,
        "streetName": streetName,
        "districtName": districtName,
        "regionId": regionId,
        "regionName": regionName,
        "buildingNatureName": buildingNatureName,
        "siteNatureName": siteNatureName,
        "pathId": pathId,
        "pathName": pathName,
        "cityId": cityId,
        "cityName": cityName,
        "krokiUrl": krokiUrl,
      };
}

class NationalAddress {
  NationalAddress({
    this.buildingNumber,
    this.additionalNumber,
    this.zipCode,
    this.unitTypeId,
    this.unitNumber,
    this.regionCode,
    this.cityCode,
    this.floorNumber,
    this.streetName,
    this.streetEname,
  });

  dynamic buildingNumber;
  dynamic additionalNumber;
  dynamic zipCode;
  dynamic unitTypeId;
  String? unitNumber;
  dynamic regionCode;
  dynamic cityCode;
  int? floorNumber;
  dynamic streetName;
  dynamic streetEname;

  factory NationalAddress.fromJson(Map<String, dynamic> json) =>
      NationalAddress(
        buildingNumber: json["buildingNumber"],
        additionalNumber: json["additionalNumber"],
        zipCode: json["zipCode"],
        unitTypeId: json["unitTypeId"],
        unitNumber: json["unitNumber"],
        regionCode: json["regionCode"],
        cityCode: json["cityCode"],
        floorNumber: json["floorNumber"],
        streetName: json["streetName"],
        streetEname: json["streetEname"],
      );

  Map<String, dynamic> toJson() => {
        "buildingNumber": buildingNumber,
        "additionalNumber": additionalNumber,
        "zipCode": zipCode,
        "unitTypeId": unitTypeId,
        "unitNumber": unitNumber,
        "regionCode": regionCode,
        "cityCode": cityCode,
        "floorNumber": floorNumber,
        "streetName": streetName,
        "streetEname": streetEname,
      };
}

class ShopInfo {
  ShopInfo({
    this.shopName,
    this.holesCount,
    this.workerTypeId,
    this.numberOfCameras,
    this.hasElevator,
    this.floorCount,
    this.unitCount,
    this.accommodationTypeId,
    this.accommodationTypeName,
    this.workerTypeName,
    this.contractType,
    this.contractNumber,
    this.contractIssueDate,
    this.contractExpirationDate,
    this.blockNumber,
  });

  String? shopName;
  int? holesCount;
  int? workerTypeId;
  int? numberOfCameras;
  bool? hasElevator;
  int? floorCount;
  dynamic unitCount;
  dynamic accommodationTypeId;
  dynamic accommodationTypeName;
  String? workerTypeName;
  String? contractType;
  dynamic contractNumber;
  dynamic contractIssueDate;
  dynamic contractExpirationDate;
  dynamic blockNumber;

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        shopName: json["shopName"],
        holesCount: json["holesCount"],
        workerTypeId: json["workerTypeId"],
        numberOfCameras: json["numberOfCameras"],
        hasElevator: json["hasElevator"],
        floorCount: json["floorCount"],
        unitCount: json["unitCount"],
        accommodationTypeId: json["accommodationTypeId"],
        accommodationTypeName: json["accommodationTypeName"],
        workerTypeName: json["workerTypeName"],
        contractType: json["contractType"],
        contractNumber: json["contractNumber"],
        contractIssueDate: json["contractIssueDate"],
        contractExpirationDate: json["contractExpirationDate"],
        blockNumber: json["blockNumber"],
      );

  Map<String, dynamic> toJson() => {
        "shopName": shopName,
        "holesCount": holesCount,
        "workerTypeId": workerTypeId,
        "numberOfCameras": numberOfCameras,
        "hasElevator": hasElevator,
        "floorCount": floorCount,
        "unitCount": unitCount,
        "accommodationTypeId": accommodationTypeId,
        "accommodationTypeName": accommodationTypeName,
        "workerTypeName": workerTypeName,
        "contractType": contractType,
        "contractNumber": contractNumber,
        "contractIssueDate": contractIssueDate,
        "contractExpirationDate": contractExpirationDate,
        "blockNumber": blockNumber,
      };
}

class EnterpriseInfo {
  EnterpriseInfo({
    this.crOwners,
    this.ownerMobileNumber,
    this.ownerEmail,
    this.managerIdentityNumber,
    this.managerBirthDate,
    this.contactInfo,
    this.hasPaymentMethods,
    this.paymentMethods,
    this.ownerIdentityNumber,
    this.ownerIdentityTypeId,
    this.ownerIdentityTypeName,
    this.ownerName,
    this.managerName,
    this.managerSexId,
    this.managerSexName,
    this.managerNationalityId,
    this.managerNationalityName,
    this.managerProfessionalId,
    this.managerProfessionalName,
    this.employeesInfo,
  });

  dynamic crOwners;
  dynamic ownerMobileNumber;
  dynamic ownerEmail;
  dynamic managerIdentityNumber;
  dynamic managerBirthDate;
  ContactInfo? contactInfo;
  dynamic hasPaymentMethods;
  List<PaymentMethod>? paymentMethods;
  dynamic ownerIdentityNumber;
  dynamic ownerIdentityTypeId;
  dynamic ownerIdentityTypeName;
  dynamic ownerName;
  dynamic managerName;
  int? managerSexId;
  String? managerSexName;
  int? managerNationalityId;
  String? managerNationalityName;
  int? managerProfessionalId;
  String? managerProfessionalName;
  List<dynamic>? employeesInfo;

  factory EnterpriseInfo.fromJson(Map<String, dynamic> json) => EnterpriseInfo(
        crOwners: json["crOwners"],
        ownerMobileNumber: json["ownerMobileNumber"],
        ownerEmail: json["ownerEmail"],
        managerIdentityNumber: json["managerIdentityNumber"],
        managerBirthDate: json["managerBirthDate"],
        contactInfo: json["contactInfo"] == null
            ? null
            : ContactInfo.fromJson(json["contactInfo"]),
        hasPaymentMethods: json["hasPaymentMethods"],
        paymentMethods: json["paymentMethods"] == null
            ? null
            : List<PaymentMethod>.from(
                json["paymentMethods"].map((x) => PaymentMethod.fromJson(x))),
        ownerIdentityNumber: json["ownerIdentityNumber"],
        ownerIdentityTypeId: json["ownerIdentityTypeId"],
        ownerIdentityTypeName: json["ownerIdentityTypeName"],
        ownerName: json["ownerName"],
        managerName: json["managerName"],
        managerSexId: json["managerSexId"],
        managerSexName: json["managerSexName"],
        managerNationalityId: json["managerNationalityId"],
        managerNationalityName: json["managerNationalityName"],
        managerProfessionalId: json["managerProfessionalId"],
        managerProfessionalName: json["managerProfessionalName"],
        employeesInfo: json["employeesInfo"] == null
            ? null
            : List<dynamic>.from(json["employeesInfo"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "crOwners": crOwners,
        "ownerMobileNumber": ownerMobileNumber,
        "ownerEmail": ownerEmail,
        "managerIdentityNumber": managerIdentityNumber,
        "managerBirthDate": managerBirthDate,
        "contactInfo": contactInfo == null ? null : contactInfo!.toJson(),
        "hasPaymentMethods": hasPaymentMethods,
        "paymentMethods": paymentMethods == null
            ? null
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "ownerIdentityNumber": ownerIdentityNumber,
        "ownerIdentityTypeId": ownerIdentityTypeId,
        "ownerIdentityTypeName": ownerIdentityTypeName,
        "ownerName": ownerName,
        "managerName": managerName,
        "managerSexId": managerSexId,
        "managerSexName": managerSexName,
        "managerNationalityId": managerNationalityId,
        "managerNationalityName": managerNationalityName,
        "managerProfessionalId": managerProfessionalId,
        "managerProfessionalName": managerProfessionalName,
        "employeesInfo": employeesInfo == null
            ? null
            : List<dynamic>.from(employeesInfo!.map((x) => x)),
      };
}

class ContactInfo {
  ContactInfo({
    this.mobile,
    this.phone,
    this.mail,
    this.website,
    this.twitter,
    this.instegram,
    this.snapchat,
    this.facebook,
    this.whatsApp,
    this.enterpriseUniqueCode,
  });

  String? mobile;
  String? phone;
  dynamic mail;
  String? website;
  String? twitter;
  String? instegram;
  String? snapchat;
  String? facebook;
  String? whatsApp;
  dynamic enterpriseUniqueCode;

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
        mobile: json["mobile"],
        phone: json["phone"],
        mail: json["mail"],
        website: json["website"],
        twitter: json["twitter"],
        instegram: json["instegram"],
        snapchat: json["snapchat"],
        facebook: json["facebook"],
        whatsApp: json["whatsApp"],
        enterpriseUniqueCode: json["enterpriseUniqueCode"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "phone": phone,
        "mail": mail,
        "website": website,
        "twitter": twitter,
        "instegram": instegram,
        "snapchat": snapchat,
        "facebook": facebook,
        "whatsApp": whatsApp,
        "enterpriseUniqueCode": enterpriseUniqueCode,
      };
}

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.name,
    this.ename,
  });

  int? id;
  String? name;
  dynamic ename;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        name: json["name"],
        ename: json["ename"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ename": ename,
      };
}

class QrCodeAdditionalInfo {
  QrCodeAdditionalInfo({
    this.thereIsOuterInvestablePlace,
    this.serveDisabledPersons,
    this.hasParking,
    this.parkingCount,
    this.hasElectronicSale,
    this.hasDelivery,
    this.siteDeliveryType,
    this.siteDeliveryName,
    this.hasVehicleParking,
    this.electAccountNumber,
    this.waterAccountNumber,
  });

  bool? thereIsOuterInvestablePlace;
  bool? serveDisabledPersons;
  bool? hasParking;
  int? parkingCount;
  String? hasElectronicSale;
  String? hasDelivery;
  String? siteDeliveryType;
  dynamic siteDeliveryName;
  String? hasVehicleParking;
  dynamic electAccountNumber;
  dynamic waterAccountNumber;

  factory QrCodeAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      QrCodeAdditionalInfo(
        thereIsOuterInvestablePlace: json["thereIsOuterInvestablePlace"],
        serveDisabledPersons: json["serveDisabledPersons"],
        hasParking: json["hasParking"],
        parkingCount: json["parkingCount"],
        hasElectronicSale: json["hasElectronicSale"],
        hasDelivery: json["hasDelivery"],
        siteDeliveryType: json["siteDeliveryType"],
        siteDeliveryName: json["siteDeliveryName"],
        hasVehicleParking: json["hasVehicleParking"],
        electAccountNumber: json["electAccountNumber"],
        waterAccountNumber: json["waterAccountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "thereIsOuterInvestablePlace": thereIsOuterInvestablePlace,
        "serveDisabledPersons": serveDisabledPersons,
        "hasParking": hasParking,
        "parkingCount": parkingCount,
        "hasElectronicSale": hasElectronicSale,
        "hasDelivery": hasDelivery,
        "siteDeliveryType": siteDeliveryType,
        "siteDeliveryName": siteDeliveryName,
        "hasVehicleParking": hasVehicleParking,
        "electAccountNumber": electAccountNumber,
        "waterAccountNumber": waterAccountNumber,
      };
}

class RatingInfo {
  RatingInfo({
    this.average,
    this.totalRatingCount,
    this.ratingItemAverages,
  });

  dynamic average;
  dynamic totalRatingCount;
  List<RatingItemAverage>? ratingItemAverages;

  factory RatingInfo.fromJson(Map<String, dynamic> json) => RatingInfo(
        average: json["average"],
        totalRatingCount: json["totalRatingCount"],
        ratingItemAverages: json["ratingItemAverages"] == null
            ? null
            : List<RatingItemAverage>.from(json["ratingItemAverages"]
                .map((x) => RatingItemAverage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "totalRatingCount": totalRatingCount,
        "ratingItemAverages": ratingItemAverages == null
            ? null
            : List<dynamic>.from(ratingItemAverages!.map((x) => x.toJson())),
      };
}

class RatingItemAverage {
  RatingItemAverage({
    this.key,
    this.value,
    this.name,
    this.ename,
    this.average,
  });

  int? key;
  dynamic value;
  String? name;
  String? ename;
  dynamic average;

  factory RatingItemAverage.fromJson(Map<String, dynamic> json) =>
      RatingItemAverage(
        key: json["key"],
        value: json["value"],
        name: json["name"],
        ename: json["ename"],
        average: json["average"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "name": name,
        "ename": ename,
        "average": average,
      };

  double getAverage() {
    String avrage = average.toString();
    return double.tryParse(avrage) ?? 0;
  }
}

class SubmitterInfo {
  SubmitterInfo({
    this.submitterType,
    this.identityTypeId,
    this.identityNumber,
    this.birthDate,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.fourthName,
    this.mobile,
    this.email,
    this.genderTypeId,
    this.nationalityId,
    this.identitySource,
    this.identityIssueDate,
    this.identityExpiryDate,
  });

  String? submitterType;
  dynamic identityTypeId;
  dynamic identityNumber;
  dynamic birthDate;
  String? firstName;
  String? secondName;
  String? thirdName;
  String? fourthName;
  String? mobile;
  String? email;
  int? genderTypeId;
  dynamic nationalityId;
  dynamic identitySource;
  dynamic identityIssueDate;
  dynamic identityExpiryDate;

  factory SubmitterInfo.fromJson(Map<String, dynamic> json) => SubmitterInfo(
        submitterType: json["submitterType"],
        identityTypeId: json["identityTypeId"],
        identityNumber: json["identityNumber"],
        birthDate: json["birthDate"],
        firstName: json["firstName"],
        secondName: json["secondName"],
        thirdName: json["thirdName"],
        fourthName: json["fourthName"],
        mobile: json["mobile"],
        email: json["email"],
        genderTypeId: json["genderTypeId"],
        nationalityId: json["nationalityId"],
        identitySource: json["identitySource"],
        identityIssueDate: json["identityIssueDate"],
        identityExpiryDate: json["identityExpiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "submitterType": submitterType,
        "identityTypeId": identityTypeId,
        "identityNumber": identityNumber,
        "birthDate": birthDate,
        "firstName": firstName,
        "secondName": secondName,
        "thirdName": thirdName,
        "fourthName": fourthName,
        "mobile": mobile,
        "email": email,
        "genderTypeId": genderTypeId,
        "nationalityId": nationalityId,
        "identitySource": identitySource,
        "identityIssueDate": identityIssueDate,
        "identityExpiryDate": identityExpiryDate,
      };
}

class WorkTimes {
  WorkTimes({
    this.workingTimes,
  });

  List<WorkingTime>? workingTimes;

  factory WorkTimes.fromJson(Map<String, dynamic> json) => WorkTimes(
        workingTimes: json["workingTimes"] == null
            ? null
            : List<WorkingTime>.from(
                json["workingTimes"].map((x) => WorkingTime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "workingTimes": workingTimes == null
            ? null
            : List<dynamic>.from(workingTimes!.map((x) => x.toJson())),
      };

  WorkingTime? getToday() {
    WorkingTime? today;
    if (workingTimes != null) {
      today = workingTimes!.firstWhere((element) => element.isToday ?? false);
    }
    return today;
  }
}

class WorkingTime {
  WorkingTime(
      {this.dayId,
      this.dayName,
      this.openShiftOption,
      this.firstFromTime,
      this.firstToTime,
      this.secondFromTime,
      this.secondToTime,
      this.weekDay,
      this.isToday});

  int? dayId;
  String? dayName;
  String? openShiftOption;
  String? firstFromTime;
  String? firstToTime;
  dynamic secondFromTime;
  dynamic secondToTime;
  int? weekDay;
  bool? isToday;

  factory WorkingTime.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.now();

    return WorkingTime(
        dayId: json["dayId"],
        dayName: json["dayName"],
        openShiftOption: json["openShiftOption"],
        firstFromTime: json["firstFromTime"],
        firstToTime: json["firstToTime"],
        secondFromTime: json["secondFromTime"],
        secondToTime: json["secondToTime"],
        weekDay: getWeekday(json["dayId"]),
        isToday: getWeekday(json["dayId"]) == date.weekday);
  }

  Map<String, dynamic> toJson() => {
        "dayId": dayId,
        "dayName": dayName,
        "openShiftOption": openShiftOption,
        "firstFromTime": firstFromTime,
        "firstToTime": firstToTime,
        "secondFromTime": secondFromTime,
        "secondToTime": secondToTime,
      };

  bool dayHasTwoShifts() {
    if (openShiftOption == "SHIFTED") {
      if (firstFromTime != null &&
          firstToTime != null &&
          secondFromTime != null &&
          secondToTime != null) {
        return true;
      }
      return false;
    }
    return false;
  }

  static int getWeekday(int dayId) {
    if (dayId != null) {
      switch (dayId) {
        case 1:
          return DateTime.sunday;
          break;
        case 2:
          return DateTime.monday;
          break;
        case 3:
          return DateTime.tuesday;
          break;
        case 4:
          return DateTime.wednesday;
          break;
        case 5:
          return DateTime.thursday;
          break;
        case 6:
          return DateTime.friday;
          break;
        case 7:
          return DateTime.saturday;
        default:
          return dayId;
      }
    }
    return 0;
  }
}

class StatusDetail {
  StatusDetail({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory StatusDetail.fromJson(Map<String, dynamic> json) => StatusDetail(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

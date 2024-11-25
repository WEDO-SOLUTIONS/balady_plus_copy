// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:balady_plus/app/core/utils/common_functions.dart';

class SubmitCommercialResponseModel extends Equatable {
  final int? requestId;
  final String? requestDate;
  final int? currentTabId;
  final int? statusId;
  final String? statusName;
  final int? typeId;
  final String? typeName;
  final SubmitterInfo? submitterInfo;
  final ComLicenseInfo? comLicenseInfo;
  final EnterpriseInfo? enterpriseInfo;
  final WorkTimes? workTimes;
  final QrCodeAdditionalInfo? qrCodeAdditionalInfo;
  final dynamic attachments;
  final RatingInfo? ratingInfo;
  final dynamic selfSurveyRating;
  final dynamic siteReservationRequestId;
  final String? qrFlow;
  final bool? redirectToCommercialFlow;

  SubmitCommercialResponseModel({
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
    this.selfSurveyRating,
    this.siteReservationRequestId,
    this.qrFlow,
    this.redirectToCommercialFlow,
  });

  factory SubmitCommercialResponseModel.fromJson(Map<String, dynamic> json) =>
      SubmitCommercialResponseModel(
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
        qrCodeAdditionalInfo: json["qrCodeAdditionalInfo"] != null
            ? QrCodeAdditionalInfo.fromMap(json["qrCodeAdditionalInfo"])
            : null,
        attachments: json["attachments"],
        ratingInfo: json["ratingInfo"] == null
            ? null
            : RatingInfo.fromJson(json["ratingInfo"]),
        selfSurveyRating: json["selfSurveyRating"],
        siteReservationRequestId: json["siteReservationRequestId"],
        qrFlow: json["qrFlow"],
        redirectToCommercialFlow: json["redirectToCommercialFlow"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "requestDate": requestDate,
        "currentTabId": currentTabId,
        "statusId": statusId,
        "statusName": statusName,
        "typeId": typeId,
        "typeName": typeName,
        "submitterInfo": submitterInfo?.toJson(),
        "comLicenseInfo": comLicenseInfo?.toJson(),
        "enterpriseInfo": enterpriseInfo?.toJson(),
        "workTimes": workTimes?.toJson(),
        "attachments": attachments,
        "ratingInfo": ratingInfo?.toJson(),
        "selfSurveyRating": selfSurveyRating,
        "siteReservationRequestId": siteReservationRequestId,
        "qrFlow": qrFlow,
        "redirectToCommercialFlow": redirectToCommercialFlow,
      };

  @override
  List<Object?> get props => [requestId, requestDate];
}

class ComLicenseInfo {
  final dynamic licenseUuid;
  final int? licenseId;
  final dynamic licenseIssDate;
  final dynamic licenseExpirationDate;
  final int? licenseStatusId;
  final String? licenseStatusName;
  final dynamic boardsInfo;
  final ActivityInfo? activityInfo;
  final String? entityType;
  final double? shopArea;
  final ShopInfo? shopInfo;
  final dynamic vehicleInfo;
  final LocationInfo? locationInfo;
  final bool? has24HourPermit;
  final dynamic facilityClassificationId;
  final dynamic facilityClassification;

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

  factory ComLicenseInfo.fromJson(Map<String, dynamic> json) => ComLicenseInfo(
        licenseUuid: json["licenseUuid"],
        licenseId: json["licenseId"],
        licenseIssDate: json["licenseIssDate"],
        licenseExpirationDate: json["licenseExpirationDate"],
        licenseStatusId: json["licenseStatusId"],
        licenseStatusName: json["licenseStatusName"],
        boardsInfo: json["boardsInfo"],
        activityInfo: json["activityInfo"] == null
            ? null
            : ActivityInfo.fromJson(json["activityInfo"]),
        entityType: json["entityType"],
        shopArea: json["shopArea"]?.toDouble(),
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
        "boardsInfo": boardsInfo,
        "activityInfo": activityInfo?.toJson(),
        "entityType": entityType,
        "shopArea": shopArea,
        "shopInfo": shopInfo?.toJson(),
        "vehicleInfo": vehicleInfo,
        "locationInfo": locationInfo?.toJson(),
        "has24HourPermit": has24HourPermit,
        "facilityClassificationId": facilityClassificationId,
        "facilityClassification": facilityClassification,
      };
}

class ActivityInfo {
  final MainActivity? mainActivity;
  final dynamic additionalActivities;

  ActivityInfo({
    this.mainActivity,
    this.additionalActivities,
  });

  factory ActivityInfo.fromJson(Map<String, dynamic> json) => ActivityInfo(
        mainActivity: json["mainActivity"] == null
            ? null
            : MainActivity.fromJson(json["mainActivity"]),
        additionalActivities: json["additionalActivities"],
      );

  Map<String, dynamic> toJson() => {
        "mainActivity": mainActivity?.toJson(),
        "additionalActivities": additionalActivities,
      };
}

class MainActivity {
  final dynamic sectorId;
  final dynamic sectorName;
  final dynamic sectionId;
  final dynamic sectionName;
  final String? isicNumber;
  final String? isicName;
  final int? activityDetailId;
  final String? activityDetailName;
  final double? area;

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

  factory MainActivity.fromJson(Map<String, dynamic> json) => MainActivity(
        sectorId: json["sectorId"],
        sectorName: json["sectorName"],
        sectionId: json["sectionId"],
        sectionName: json["sectionName"],
        isicNumber: json["isicNumber"],
        isicName: json["isicName"],
        activityDetailId: json["activityDetailId"],
        activityDetailName: json["activityDetailName"],
        area: json["area"]?.toDouble(),
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

class LocationInfo {
  final String? subMunicipalityGisCode;
  final int? streetCode;
  final int? districtId;
  final String? latitude;
  final String? longitude;
  final dynamic siteLocationType;
  final dynamic nationalAddress;
  final dynamic accessDirections;
  final dynamic buildingNatureId;
  final dynamic buildingName;
  final dynamic siteNatureId;
  final dynamic siteName;
  final dynamic siteDescription;
  final dynamic nearestLandmark;
  final String? mapNumber;
  final String? landNumber;
  final String? municipalityId;
  final String? municipalityName;
  final String? subMunicipalityId;
  final String? subMunicipalityName;
  final String? streetName;
  final String? districtName;
  final int? regionId;
  final String? regionName;
  final dynamic buildingNatureName;
  final dynamic siteNatureName;
  final dynamic pathId;
  final dynamic pathName;
  final int? cityId;
  final String? cityName;
  final dynamic krokiUrl;

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

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        subMunicipalityGisCode: json["subMunicipalityGisCode"],
        streetCode: json["streetCode"],
        districtId: json["districtId"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        siteLocationType: json["siteLocationType"],
        nationalAddress: json["nationalAddress"],
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
        "nationalAddress": nationalAddress,
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

class ShopInfo {
  final String? shopName;
  final int? holesCount;
  final int? workerTypeId;
  final int? numberOfCameras;
  final bool? hasElevator;
  final int? floorCount;
  final dynamic unitCount;
  final dynamic accommodationTypeId;
  final dynamic accommodationTypeName;
  final String? workerTypeName;
  final String? contractType;
  final String? contractNumber;
  final String? contractIssueDate;
  final dynamic contractExpirationDate;
  final int? blockNumber;

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
  final List<CrOwner>? crOwners;
  final String? ownerMobileNumber;
  final String? ownerEmail;
  final dynamic managerIdentityNumber;
  final dynamic managerBirthDate;
  final ContactInfo? contactInfo;
  final dynamic hasPaymentMethods;
  final dynamic paymentMethods;
  final dynamic qrEnterpriseLocationDto;
  final String? ownerIdentityNumber;
  final int? ownerIdentityTypeId;
  final String? ownerIdentityTypeName;
  final String? ownerName;
  final dynamic managerName;
  final dynamic managerSexId;
  final dynamic managerSexName;
  final dynamic managerNationalityId;
  final dynamic managerNationalityName;
  final dynamic managerProfessionalId;
  final dynamic managerProfessionalName;
  final List<dynamic>? employeesInfo;

  EnterpriseInfo({
    this.crOwners,
    this.ownerMobileNumber,
    this.ownerEmail,
    this.managerIdentityNumber,
    this.managerBirthDate,
    this.contactInfo,
    this.hasPaymentMethods,
    this.paymentMethods,
    this.qrEnterpriseLocationDto,
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

  factory EnterpriseInfo.fromJson(Map<String, dynamic> json) => EnterpriseInfo(
        crOwners: json["crOwners"] == null
            ? []
            : List<CrOwner>.from(
                json["crOwners"]!.map((x) => CrOwner.fromJson(x))),
        ownerMobileNumber: json["ownerMobileNumber"],
        ownerEmail: json["ownerEmail"],
        managerIdentityNumber: json["managerIdentityNumber"],
        managerBirthDate: json["managerBirthDate"],
        contactInfo: json["contactInfo"] == null
            ? null
            : ContactInfo.fromJson(json["contactInfo"]),
        hasPaymentMethods: json["hasPaymentMethods"],
        paymentMethods: json["paymentMethods"],
        qrEnterpriseLocationDto: json["qrEnterpriseLocationDto"],
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
            ? []
            : List<dynamic>.from(json["employeesInfo"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "crOwners": crOwners == null
            ? []
            : List<dynamic>.from(crOwners!.map((x) => x.toJson())),
        "ownerMobileNumber": ownerMobileNumber,
        "ownerEmail": ownerEmail,
        "managerIdentityNumber": managerIdentityNumber,
        "managerBirthDate": managerBirthDate,
        "contactInfo": contactInfo?.toJson(),
        "hasPaymentMethods": hasPaymentMethods,
        "paymentMethods": paymentMethods,
        "qrEnterpriseLocationDto": qrEnterpriseLocationDto,
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
            ? []
            : List<dynamic>.from(employeesInfo!.map((x) => x)),
      };
}

class ContactInfo extends Equatable {
  final String? mobile;
  final String? phone;
  final String? mail;
  final String? website;
  final String? twitter;
  final String? instegram;
  final String? snapchat;
  final String? facebook;
  final String? whatsApp;
  final String? enterpriseUniqueCode;

  const ContactInfo({
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

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
        mobile: json["mobile"] ?? CommonProperties.userInfo?.getPhone(),
        phone: json["phone"],
        mail: json["mail"],
        website: json["website"],
        twitter: json["twitter"],
        instegram: json["instegram"],
        snapchat: json["snapchat"],
        facebook: json["facebook"],
        whatsApp: json["whatsApp"],
        enterpriseUniqueCode: json["enterpriseUniqueCode"]?.toString(),
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

  ContactInfo copyWith({
    String? mobile,
    String? phone,
    String? mail,
    String? website,
    String? twitter,
    String? instegram,
    String? snapchat,
    String? facebook,
    String? whatsApp,
    String? enterpriseUniqueCode,
  }) {
    return ContactInfo(
      mobile: mobile ?? this.mobile,
      phone: phone ?? this.phone,
      mail: mail ?? this.mail,
      website: website ?? this.website,
      twitter: twitter ?? this.twitter,
      instegram: instegram ?? this.instegram,
      snapchat: snapchat ?? this.snapchat,
      facebook: facebook ?? this.facebook,
      whatsApp: whatsApp ?? this.whatsApp,
      enterpriseUniqueCode: enterpriseUniqueCode ?? this.enterpriseUniqueCode,
    );
  }

  @override
  List<Object?> get props => [
        mobile,
        phone,
        mail,
        website,
        twitter,
        instegram,
        snapchat,
        facebook,
        whatsApp,
        enterpriseUniqueCode
      ];
}

class QrCodeAdditionalInfo extends Equatable {
  final bool? thereIsOuterInvestablePlace;
  final bool? serveDisabledPersons;
  final bool? hasParking;
  final int? parkingCount;
  final String? hasElectronicSale;
  final String? hasDelivery;
  final String? siteDeliveryType;
  final String? siteDeliveryName;
  final String? hasVehicleParking;
  final String? electAccountNumber;
  final String? waterAccountNumber;
  const QrCodeAdditionalInfo({
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

  @override
  List<Object?> get props {
    return [
      thereIsOuterInvestablePlace,
      serveDisabledPersons,
      hasParking,
      parkingCount,
      hasElectronicSale,
      hasDelivery,
      siteDeliveryType,
      siteDeliveryName,
      hasVehicleParking,
      electAccountNumber,
      waterAccountNumber,
    ];
  }

  QrCodeAdditionalInfo copyWith({
    bool? thereIsOuterInvestablePlace,
    bool? serveDisabledPersons,
    bool? hasParking,
    int? parkingCount,
    String? hasElectronicSale,
    String? hasDelivery,
    String? siteDeliveryType,
    String? siteDeliveryName,
    String? hasVehicleParking,
    String? electAccountNumber,
    String? waterAccountNumber,
  }) {
    return QrCodeAdditionalInfo(
      thereIsOuterInvestablePlace:
          thereIsOuterInvestablePlace ?? this.thereIsOuterInvestablePlace,
      serveDisabledPersons: serveDisabledPersons ?? this.serveDisabledPersons,
      hasParking: hasParking ?? this.hasParking,
      parkingCount: parkingCount ?? this.parkingCount,
      hasElectronicSale: hasElectronicSale ?? this.hasElectronicSale,
      hasDelivery: hasDelivery ?? this.hasDelivery,
      siteDeliveryType: siteDeliveryType ?? this.siteDeliveryType,
      siteDeliveryName: siteDeliveryName ?? this.siteDeliveryName,
      hasVehicleParking: hasVehicleParking ?? this.hasVehicleParking,
      electAccountNumber: electAccountNumber ?? this.electAccountNumber,
      waterAccountNumber: waterAccountNumber ?? this.waterAccountNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'thereIsOuterInvestablePlace': thereIsOuterInvestablePlace,
      'serveDisabledPersons': serveDisabledPersons,
      'hasParking': hasParking,
      'parkingCount': parkingCount,
      'hasElectronicSale': hasElectronicSale,
      'hasDelivery': hasDelivery,
      'siteDeliveryType': siteDeliveryType,
      'siteDeliveryName': siteDeliveryName,
      'hasVehicleParking': hasVehicleParking,
      'electAccountNumber': electAccountNumber,
      'waterAccountNumber': waterAccountNumber,
    };
  }

  factory QrCodeAdditionalInfo.fromMap(Map<String, dynamic> map) {
    return QrCodeAdditionalInfo(
      thereIsOuterInvestablePlace: map['thereIsOuterInvestablePlace'] != null
          ? map['thereIsOuterInvestablePlace'] as bool
          : null,
      serveDisabledPersons: map['serveDisabledPersons'] != null
          ? map['serveDisabledPersons'] as bool
          : null,
      hasParking: map['hasParking'] != null ? map['hasParking'] as bool : null,
      parkingCount:
          map['parkingCount'] != null ? map['parkingCount'] as int : null,
      hasElectronicSale: map['hasElectronicSale'] != null
          ? map['hasElectronicSale'] as String?
          : null,
      hasDelivery:
          map['hasDelivery'] != null ? map['hasDelivery'] as String? : null,
      siteDeliveryType: map['siteDeliveryType'] != null
          ? map['siteDeliveryType'] as String
          : null,
      siteDeliveryName: map['siteDeliveryName'] != null
          ? map['siteDeliveryName'] as String
          : null,
      hasVehicleParking: map['hasVehicleParking'] != null
          ? map['hasVehicleParking'] as String?
          : null,
      electAccountNumber: map['electAccountNumber'] != null
          ? map['electAccountNumber'].toString()
          : null,
      waterAccountNumber: map['waterAccountNumber'] != null
          ? map['waterAccountNumber'].toString()
          : null,
    );
  }

  @override
  bool get stringify => true;
}

class CrOwner extends Equatable {
  final String? identityNumber;
  final int? identityTypeId;
  final dynamic identityTypeName;
  final String? ownerName;
  final String? ownerMobileNumber;
  final String? ownerEmail;

  CrOwner({
    this.identityNumber,
    this.identityTypeId,
    this.identityTypeName,
    this.ownerName,
    this.ownerMobileNumber,
    this.ownerEmail,
  });

  factory CrOwner.fromJson(Map<String, dynamic> json) => CrOwner(
        identityNumber: json["identityNumber"],
        identityTypeId: json["identityTypeId"],
        identityTypeName: json["identityTypeName"],
        ownerName: json["ownerName"],
        ownerMobileNumber: json["ownerMobileNumber"],
        ownerEmail: json["ownerEmail"],
      );

  Map<String, dynamic> toJson() => {
        "identityNumber": identityNumber,
        "identityTypeId": identityTypeId,
        "identityTypeName": identityTypeName,
        "ownerName": ownerName,
        "ownerMobileNumber": ownerMobileNumber,
        "ownerEmail": ownerEmail,
      };

  CrOwner copyWith({
    String? identityNumber,
    int? identityTypeId,
    dynamic? identityTypeName,
    String? ownerName,
    String? ownerMobileNumber,
    String? ownerEmail,
  }) {
    return CrOwner(
      identityNumber: identityNumber ?? this.identityNumber,
      identityTypeId: identityTypeId ?? this.identityTypeId,
      identityTypeName: identityTypeName ?? this.identityTypeName,
      ownerName: ownerName ?? this.ownerName,
      ownerMobileNumber: ownerMobileNumber ?? this.ownerMobileNumber,
      ownerEmail: ownerEmail ?? this.ownerEmail,
    );
  }

  @override
  List<Object?> get props => [
        identityNumber,
        identityTypeId,
        identityTypeName,
        ownerName,
        ownerMobileNumber,
        ownerEmail
      ];

  bool get isCompleteData =>
      (ownerMobileNumber?.isNotEmpty ?? false) &&
      (ownerEmail?.isNotEmpty ?? false);
}

class RatingInfo {
  final double? average;
  final int? totalRatingCount;
  final List<RatingItemAverage>? ratingItemAverages;

  RatingInfo({
    this.average,
    this.totalRatingCount,
    this.ratingItemAverages,
  });

  factory RatingInfo.fromJson(Map<String, dynamic> json) => RatingInfo(
        average: json["average"]?.toDouble(),
        totalRatingCount: json["totalRatingCount"],
        ratingItemAverages: json["ratingItemAverages"] == null
            ? []
            : List<RatingItemAverage>.from(json["ratingItemAverages"]!
                .map((x) => RatingItemAverage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "totalRatingCount": totalRatingCount,
        "ratingItemAverages": ratingItemAverages == null
            ? []
            : List<dynamic>.from(ratingItemAverages!.map((x) => x.toJson())),
      };
}

class RatingItemAverage {
  final int? key;
  final dynamic value;
  final String? name;
  final String? ename;
  final double? average;

  RatingItemAverage({
    this.key,
    this.value,
    this.name,
    this.ename,
    this.average,
  });

  factory RatingItemAverage.fromJson(Map<String, dynamic> json) =>
      RatingItemAverage(
        key: json["key"],
        value: json["value"],
        name: json["name"],
        ename: json["ename"],
        average: json["average"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "name": name,
        "ename": ename,
        "average": average,
      };
}

class SubmitterInfo {
  final String? submitterType;
  final dynamic identityTypeId;
  final dynamic identityNumber;
  final dynamic birthDate;
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? fourthName;
  final String? mobile;
  final String? email;
  final int? genderTypeId;
  final dynamic nationalityId;
  final dynamic identitySource;
  final dynamic identityIssueDate;
  final dynamic identityExpiryDate;

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
  final List<WorkingTime>? workingTimes;

  WorkTimes({
    this.workingTimes,
  });

  factory WorkTimes.fromJson(Map<String, dynamic> json) => WorkTimes(
        workingTimes: json["workingTimes"] == null
            ? []
            : List<WorkingTime>.from(
                json["workingTimes"]!.map((x) => WorkingTime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "workingTimes": workingTimes == null
            ? []
            : List<dynamic>.from(workingTimes!.map((x) => x.toJson())),
      };
}

class WorkingTime {
  final int? dayId;
  final String? dayName;
  String? openShiftOption;
  String? firstFromTime;
  String? firstToTime;
  String? secondFromTime;
  String? secondToTime;
  bool? isSelected;

  WorkingTime(
      {this.dayId,
      this.dayName,
      this.openShiftOption,
      this.firstFromTime,
      this.firstToTime,
      this.secondFromTime,
      this.secondToTime,
      this.isSelected});

  factory WorkingTime.fromJson(Map<String, dynamic> json) => WorkingTime(
        dayId: json["dayId"],
        dayName: json["dayName"],
        openShiftOption: json["openShiftOption"],
        firstFromTime: json["firstFromTime"],
        firstToTime: json["firstToTime"],
        secondFromTime: json["secondFromTime"],
        secondToTime: json["secondToTime"],
      );

  Map<String, dynamic> toJson() => {
        "dayId": dayId,
        "dayName": dayName,
        "openShiftOption": openShiftOption,
        "firstFromTime": firstFromTime,
        "firstToTime": firstToTime,
        "secondFromTime": secondFromTime,
        "secondToTime": secondToTime,
      };

  WorkingTime copyWith(
      {int? dayId,
      String? dayName,
      String? openShiftOption,
      String? firstFromTime,
      String? firstToTime,
      String? secondFromTime,
      String? secondToTime,
      bool? isSelected}) {
    return WorkingTime(
        dayId: dayId ?? this.dayId,
        dayName: dayName ?? this.dayName,
        openShiftOption: openShiftOption ?? this.openShiftOption,
        firstFromTime: firstFromTime ?? this.firstFromTime,
        firstToTime: firstToTime ?? this.firstToTime,
        secondFromTime: secondFromTime ?? this.secondFromTime,
        secondToTime: secondToTime ?? this.secondToTime,
        isSelected: isSelected ?? this.isSelected);
  }
}

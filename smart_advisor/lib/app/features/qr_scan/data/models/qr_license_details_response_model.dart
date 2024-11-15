class QrDetailsResponse {
  final int? requestId;
  final String? requestDate;
  final ComLicenseInfo? comLicenseInfo;

  QrDetailsResponse({
    this.requestId,
    this.requestDate,
    this.comLicenseInfo,
  });

  QrDetailsResponse copyWith({
    int? requestId,
    String? requestDate,
    ComLicenseInfo? comLicenseInfo,
  }) =>
      QrDetailsResponse(
        requestId: requestId ?? this.requestId,
        requestDate: requestDate ?? this.requestDate,
        comLicenseInfo: comLicenseInfo ?? this.comLicenseInfo,
      );

  factory QrDetailsResponse.fromJson(Map<String, dynamic> json) =>
      QrDetailsResponse(
        requestId: json["requestId"],
        requestDate: json["requestDate"],
        comLicenseInfo: json["comLicenseInfo"] == null
            ? null
            : ComLicenseInfo.fromJson(json["comLicenseInfo"]),
      );
}

class Attachment {
  final String? code;
  final int? typeId;
  final String? typeName;
  final dynamic notes;

  Attachment({
    this.code,
    this.typeId,
    this.typeName,
    this.notes,
  });

  Attachment copyWith({
    String? code,
    int? typeId,
    String? typeName,
    dynamic notes,
  }) =>
      Attachment(
        code: code ?? this.code,
        typeId: typeId ?? this.typeId,
        typeName: typeName ?? this.typeName,
        notes: notes ?? this.notes,
      );

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
  final String? licenseUuid;
  final int? licenseId;
  final String? licenseIssDate;
  final String? licenseExpirationDate;
  final int? licenseStatusId;
  final String? licenseStatusName;
  final List<BoardsInfo>? boardsInfo;
  final ActivityInfo? activityInfo;
  final String? entityType;
  final double? shopArea;
  final ShopInfo? shopInfo;
  final dynamic vehicleInfo;
  final LocationInfo? locationInfo;
  final bool? has24HourPermit;
  final int? facilityClassificationId;
  final String? facilityClassification;

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

  ComLicenseInfo copyWith({
    String? licenseUuid,
    int? licenseId,
    String? licenseIssDate,
    String? licenseExpirationDate,
    int? licenseStatusId,
    String? licenseStatusName,
    List<BoardsInfo>? boardsInfo,
    ActivityInfo? activityInfo,
    String? entityType,
    double? shopArea,
    ShopInfo? shopInfo,
    dynamic vehicleInfo,
    LocationInfo? locationInfo,
    bool? has24HourPermit,
    int? facilityClassificationId,
    String? facilityClassification,
  }) =>
      ComLicenseInfo(
        licenseUuid: licenseUuid ?? this.licenseUuid,
        licenseId: licenseId ?? this.licenseId,
        licenseIssDate: licenseIssDate ?? this.licenseIssDate,
        licenseExpirationDate:
            licenseExpirationDate ?? this.licenseExpirationDate,
        licenseStatusId: licenseStatusId ?? this.licenseStatusId,
        licenseStatusName: licenseStatusName ?? this.licenseStatusName,
        boardsInfo: boardsInfo ?? this.boardsInfo,
        activityInfo: activityInfo ?? this.activityInfo,
        entityType: entityType ?? this.entityType,
        shopArea: shopArea ?? this.shopArea,
        shopInfo: shopInfo ?? this.shopInfo,
        vehicleInfo: vehicleInfo ?? this.vehicleInfo,
        locationInfo: locationInfo ?? this.locationInfo,
        has24HourPermit: has24HourPermit ?? this.has24HourPermit,
        facilityClassificationId:
            facilityClassificationId ?? this.facilityClassificationId,
        facilityClassification:
            facilityClassification ?? this.facilityClassification,
      );

  factory ComLicenseInfo.fromJson(Map<String, dynamic> json) => ComLicenseInfo(
        licenseUuid: json["licenseUuid"],
        licenseId: json["licenseId"],
        licenseIssDate: json["licenseIssDate"],
        licenseExpirationDate: json["licenseExpirationDate"],
        licenseStatusId: json["licenseStatusId"],
        licenseStatusName: json["licenseStatusName"],
        boardsInfo: json["boardsInfo"] == null
            ? []
            : List<BoardsInfo>.from(
                json["boardsInfo"]!.map((x) => BoardsInfo.fromJson(x))),
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
        "boardsInfo": boardsInfo == null
            ? []
            : List<dynamic>.from(boardsInfo!.map((x) => x.toJson())),
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

  ActivityInfo copyWith({
    MainActivity? mainActivity,
    dynamic additionalActivities,
  }) =>
      ActivityInfo(
        mainActivity: mainActivity ?? this.mainActivity,
        additionalActivities: additionalActivities ?? this.additionalActivities,
      );

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

  MainActivity copyWith({
    dynamic sectorId,
    dynamic sectorName,
    dynamic sectionId,
    dynamic sectionName,
    String? isicNumber,
    String? isicName,
    int? activityDetailId,
    String? activityDetailName,
    double? area,
  }) =>
      MainActivity(
        sectorId: sectorId ?? this.sectorId,
        sectorName: sectorName ?? this.sectorName,
        sectionId: sectionId ?? this.sectionId,
        sectionName: sectionName ?? this.sectionName,
        isicNumber: isicNumber ?? this.isicNumber,
        isicName: isicName ?? this.isicName,
        activityDetailId: activityDetailId ?? this.activityDetailId,
        activityDetailName: activityDetailName ?? this.activityDetailName,
        area: area ?? this.area,
      );

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

class BoardsInfo {
  final int? typeId;
  final String? typeName;
  final double? area;

  BoardsInfo({
    this.typeId,
    this.typeName,
    this.area,
  });

  BoardsInfo copyWith({
    int? typeId,
    String? typeName,
    double? area,
  }) =>
      BoardsInfo(
        typeId: typeId ?? this.typeId,
        typeName: typeName ?? this.typeName,
        area: area ?? this.area,
      );

  factory BoardsInfo.fromJson(Map<String, dynamic> json) => BoardsInfo(
        typeId: json["typeId"],
        typeName: json["typeName"],
        area: json["area"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "typeId": typeId,
        "typeName": typeName,
        "area": area,
      };
}

class LocationInfo {
  final String? subMunicipalityGisCode;
  final int? streetCode;
  final int? districtId;
  final String? latitude;
  final String? longitude;
  final String? siteLocationType;
  final NationalAddress? nationalAddress;
  final dynamic accessDirections;
  final dynamic buildingNatureId;
  final dynamic buildingName;
  final int? siteNatureId;
  final String? siteName;
  final String? siteDescription;
  final String? nearestLandmark;
  final dynamic mapNumber;
  final dynamic landNumber;
  final String? municipalityId;
  final String? municipalityName;
  final String? subMunicipalityId;
  final String? subMunicipalityName;
  final String? streetName;
  final String? districtName;
  final int? regionId;
  final String? regionName;
  final dynamic buildingNatureName;
  final String? siteNatureName;
  final dynamic pathId;
  final dynamic pathName;
  final int? cityId;
  final String? cityName;
  final String? krokiUrl;

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

  LocationInfo copyWith({
    String? subMunicipalityGisCode,
    int? streetCode,
    int? districtId,
    String? latitude,
    String? longitude,
    String? siteLocationType,
    NationalAddress? nationalAddress,
    dynamic accessDirections,
    dynamic buildingNatureId,
    dynamic buildingName,
    int? siteNatureId,
    String? siteName,
    String? siteDescription,
    String? nearestLandmark,
    dynamic mapNumber,
    dynamic landNumber,
    String? municipalityId,
    String? municipalityName,
    String? subMunicipalityId,
    String? subMunicipalityName,
    String? streetName,
    String? districtName,
    int? regionId,
    String? regionName,
    dynamic buildingNatureName,
    String? siteNatureName,
    dynamic pathId,
    dynamic pathName,
    int? cityId,
    String? cityName,
    String? krokiUrl,
  }) =>
      LocationInfo(
        subMunicipalityGisCode:
            subMunicipalityGisCode ?? this.subMunicipalityGisCode,
        streetCode: streetCode ?? this.streetCode,
        districtId: districtId ?? this.districtId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        siteLocationType: siteLocationType ?? this.siteLocationType,
        nationalAddress: nationalAddress ?? this.nationalAddress,
        accessDirections: accessDirections ?? this.accessDirections,
        buildingNatureId: buildingNatureId ?? this.buildingNatureId,
        buildingName: buildingName ?? this.buildingName,
        siteNatureId: siteNatureId ?? this.siteNatureId,
        siteName: siteName ?? this.siteName,
        siteDescription: siteDescription ?? this.siteDescription,
        nearestLandmark: nearestLandmark ?? this.nearestLandmark,
        mapNumber: mapNumber ?? this.mapNumber,
        landNumber: landNumber ?? this.landNumber,
        municipalityId: municipalityId ?? this.municipalityId,
        municipalityName: municipalityName ?? this.municipalityName,
        subMunicipalityId: subMunicipalityId ?? this.subMunicipalityId,
        subMunicipalityName: subMunicipalityName ?? this.subMunicipalityName,
        streetName: streetName ?? this.streetName,
        districtName: districtName ?? this.districtName,
        regionId: regionId ?? this.regionId,
        regionName: regionName ?? this.regionName,
        buildingNatureName: buildingNatureName ?? this.buildingNatureName,
        siteNatureName: siteNatureName ?? this.siteNatureName,
        pathId: pathId ?? this.pathId,
        pathName: pathName ?? this.pathName,
        cityId: cityId ?? this.cityId,
        cityName: cityName ?? this.cityName,
        krokiUrl: krokiUrl ?? this.krokiUrl,
      );

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        subMunicipalityGisCode: json["subMunicipalityGisCode"],
        streetCode: json["streetCode"],
        districtId: json["districtId"],
        latitude: json["latitude"],
        longitude: json["longitude"],
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
        "nationalAddress": nationalAddress?.toJson(),
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
  final dynamic buildingNumber;
  final dynamic additionalNumber;
  final dynamic zipCode;
  final dynamic unitTypeId;
  final dynamic unitNumber;
  final dynamic regionCode;
  final dynamic cityCode;
  final dynamic floorNumber;
  final dynamic streetName;
  final dynamic streetEname;

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

  NationalAddress copyWith({
    dynamic buildingNumber,
    dynamic additionalNumber,
    dynamic zipCode,
    dynamic unitTypeId,
    dynamic unitNumber,
    dynamic regionCode,
    dynamic cityCode,
    dynamic floorNumber,
    dynamic streetName,
    dynamic streetEname,
  }) =>
      NationalAddress(
        buildingNumber: buildingNumber ?? this.buildingNumber,
        additionalNumber: additionalNumber ?? this.additionalNumber,
        zipCode: zipCode ?? this.zipCode,
        unitTypeId: unitTypeId ?? this.unitTypeId,
        unitNumber: unitNumber ?? this.unitNumber,
        regionCode: regionCode ?? this.regionCode,
        cityCode: cityCode ?? this.cityCode,
        floorNumber: floorNumber ?? this.floorNumber,
        streetName: streetName ?? this.streetName,
        streetEname: streetEname ?? this.streetEname,
      );

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
  final String? shopName;
  final int? holesCount;
  final int? workerTypeId;
  final int? numberOfCameras;
  final bool? hasElevator;
  final int? floorCount;
  final int? unitCount;
  final int? accommodationTypeId;
  final String? accommodationTypeName;
  final String? workerTypeName;
  final String? contractType;
  final dynamic contractNumber;
  final dynamic contractIssueDate;
  final dynamic contractExpirationDate;
  final dynamic blockNumber;

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

  ShopInfo copyWith({
    String? shopName,
    int? holesCount,
    int? workerTypeId,
    int? numberOfCameras,
    bool? hasElevator,
    int? floorCount,
    int? unitCount,
    int? accommodationTypeId,
    String? accommodationTypeName,
    String? workerTypeName,
    String? contractType,
    dynamic contractNumber,
    dynamic contractIssueDate,
    dynamic contractExpirationDate,
    dynamic blockNumber,
  }) =>
      ShopInfo(
        shopName: shopName ?? this.shopName,
        holesCount: holesCount ?? this.holesCount,
        workerTypeId: workerTypeId ?? this.workerTypeId,
        numberOfCameras: numberOfCameras ?? this.numberOfCameras,
        hasElevator: hasElevator ?? this.hasElevator,
        floorCount: floorCount ?? this.floorCount,
        unitCount: unitCount ?? this.unitCount,
        accommodationTypeId: accommodationTypeId ?? this.accommodationTypeId,
        accommodationTypeName:
            accommodationTypeName ?? this.accommodationTypeName,
        workerTypeName: workerTypeName ?? this.workerTypeName,
        contractType: contractType ?? this.contractType,
        contractNumber: contractNumber ?? this.contractNumber,
        contractIssueDate: contractIssueDate ?? this.contractIssueDate,
        contractExpirationDate:
            contractExpirationDate ?? this.contractExpirationDate,
        blockNumber: blockNumber ?? this.blockNumber,
      );

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
  final dynamic crOwners;
  final dynamic ownerMobileNumber;
  final dynamic ownerEmail;
  final dynamic managerIdentityNumber;
  final dynamic managerBirthDate;
  final ContactInfo? contactInfo;
  final dynamic hasPaymentMethods;
  final dynamic paymentMethods;
  final dynamic ownerIdentityNumber;
  final dynamic ownerIdentityTypeId;
  final dynamic ownerIdentityTypeName;
  final dynamic ownerName;
  final dynamic managerName;
  final int? managerSexId;
  final String? managerSexName;
  final int? managerNationalityId;
  final String? managerNationalityName;
  final int? managerProfessionalId;
  final String? managerProfessionalName;
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

  EnterpriseInfo copyWith({
    dynamic crOwners,
    dynamic ownerMobileNumber,
    dynamic ownerEmail,
    dynamic managerIdentityNumber,
    dynamic managerBirthDate,
    ContactInfo? contactInfo,
    dynamic hasPaymentMethods,
    dynamic paymentMethods,
    dynamic ownerIdentityNumber,
    dynamic ownerIdentityTypeId,
    dynamic ownerIdentityTypeName,
    dynamic ownerName,
    dynamic managerName,
    int? managerSexId,
    String? managerSexName,
    int? managerNationalityId,
    String? managerNationalityName,
    int? managerProfessionalId,
    String? managerProfessionalName,
    List<dynamic>? employeesInfo,
  }) =>
      EnterpriseInfo(
        crOwners: crOwners ?? this.crOwners,
        ownerMobileNumber: ownerMobileNumber ?? this.ownerMobileNumber,
        ownerEmail: ownerEmail ?? this.ownerEmail,
        managerIdentityNumber:
            managerIdentityNumber ?? this.managerIdentityNumber,
        managerBirthDate: managerBirthDate ?? this.managerBirthDate,
        contactInfo: contactInfo ?? this.contactInfo,
        hasPaymentMethods: hasPaymentMethods ?? this.hasPaymentMethods,
        paymentMethods: paymentMethods ?? this.paymentMethods,
        ownerIdentityNumber: ownerIdentityNumber ?? this.ownerIdentityNumber,
        ownerIdentityTypeId: ownerIdentityTypeId ?? this.ownerIdentityTypeId,
        ownerIdentityTypeName:
            ownerIdentityTypeName ?? this.ownerIdentityTypeName,
        ownerName: ownerName ?? this.ownerName,
        managerName: managerName ?? this.managerName,
        managerSexId: managerSexId ?? this.managerSexId,
        managerSexName: managerSexName ?? this.managerSexName,
        managerNationalityId: managerNationalityId ?? this.managerNationalityId,
        managerNationalityName:
            managerNationalityName ?? this.managerNationalityName,
        managerProfessionalId:
            managerProfessionalId ?? this.managerProfessionalId,
        managerProfessionalName:
            managerProfessionalName ?? this.managerProfessionalName,
        employeesInfo: employeesInfo ?? this.employeesInfo,
      );

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
        paymentMethods: json["paymentMethods"],
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
        "crOwners": crOwners,
        "ownerMobileNumber": ownerMobileNumber,
        "ownerEmail": ownerEmail,
        "managerIdentityNumber": managerIdentityNumber,
        "managerBirthDate": managerBirthDate,
        "contactInfo": contactInfo?.toJson(),
        "hasPaymentMethods": hasPaymentMethods,
        "paymentMethods": paymentMethods,
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

class ContactInfo {
  final String? mobile;
  final dynamic phone;
  final dynamic mail;
  final dynamic website;
  final dynamic twitter;
  final dynamic instegram;
  final dynamic snapchat;
  final dynamic facebook;
  final dynamic whatsApp;
  final dynamic enterpriseUniqueCode;

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

  ContactInfo copyWith({
    String? mobile,
    dynamic phone,
    dynamic mail,
    dynamic website,
    dynamic twitter,
    dynamic instegram,
    dynamic snapchat,
    dynamic facebook,
    dynamic whatsApp,
    dynamic enterpriseUniqueCode,
  }) =>
      ContactInfo(
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

class QrCodeAdditionalInfo {
  final bool? thereIsOuterInvestablePlace;
  final bool? serveDisabledPersons;
  final bool? hasParking;
  final int? parkingCount;
  final String? hasElectronicSale;
  final String? hasDelivery;
  final dynamic siteDeliveryType;
  final dynamic siteDeliveryName;
  final String? hasVehicleParking;
  final dynamic electAccountNumber;
  final dynamic waterAccountNumber;

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

  QrCodeAdditionalInfo copyWith({
    bool? thereIsOuterInvestablePlace,
    bool? serveDisabledPersons,
    bool? hasParking,
    int? parkingCount,
    String? hasElectronicSale,
    String? hasDelivery,
    dynamic siteDeliveryType,
    dynamic siteDeliveryName,
    String? hasVehicleParking,
    dynamic electAccountNumber,
    dynamic waterAccountNumber,
  }) =>
      QrCodeAdditionalInfo(
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
  final int? average;
  final int? totalRatingCount;
  final List<RatingItemAverage>? ratingItemAverages;

  RatingInfo({
    this.average,
    this.totalRatingCount,
    this.ratingItemAverages,
  });

  RatingInfo copyWith({
    int? average,
    int? totalRatingCount,
    List<RatingItemAverage>? ratingItemAverages,
  }) =>
      RatingInfo(
        average: average ?? this.average,
        totalRatingCount: totalRatingCount ?? this.totalRatingCount,
        ratingItemAverages: ratingItemAverages ?? this.ratingItemAverages,
      );

  factory RatingInfo.fromJson(Map<String, dynamic> json) => RatingInfo(
        average: json["average"],
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
  final int? average;

  RatingItemAverage({
    this.key,
    this.value,
    this.name,
    this.ename,
    this.average,
  });

  RatingItemAverage copyWith({
    int? key,
    dynamic value,
    String? name,
    String? ename,
    int? average,
  }) =>
      RatingItemAverage(
        key: key ?? this.key,
        value: value ?? this.value,
        name: name ?? this.name,
        ename: ename ?? this.ename,
        average: average ?? this.average,
      );

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

  SubmitterInfo copyWith({
    String? submitterType,
    dynamic identityTypeId,
    dynamic identityNumber,
    dynamic birthDate,
    String? firstName,
    String? secondName,
    String? thirdName,
    String? fourthName,
    String? mobile,
    String? email,
    int? genderTypeId,
    dynamic nationalityId,
    dynamic identitySource,
    dynamic identityIssueDate,
    dynamic identityExpiryDate,
  }) =>
      SubmitterInfo(
        submitterType: submitterType ?? this.submitterType,
        identityTypeId: identityTypeId ?? this.identityTypeId,
        identityNumber: identityNumber ?? this.identityNumber,
        birthDate: birthDate ?? this.birthDate,
        firstName: firstName ?? this.firstName,
        secondName: secondName ?? this.secondName,
        thirdName: thirdName ?? this.thirdName,
        fourthName: fourthName ?? this.fourthName,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        genderTypeId: genderTypeId ?? this.genderTypeId,
        nationalityId: nationalityId ?? this.nationalityId,
        identitySource: identitySource ?? this.identitySource,
        identityIssueDate: identityIssueDate ?? this.identityIssueDate,
        identityExpiryDate: identityExpiryDate ?? this.identityExpiryDate,
      );

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

  WorkTimes copyWith({
    List<WorkingTime>? workingTimes,
  }) =>
      WorkTimes(
        workingTimes: workingTimes ?? this.workingTimes,
      );

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
  final String? openShiftOption;
  final String? firstFromTime;
  final String? firstToTime;
  final dynamic secondFromTime;
  final dynamic secondToTime;

  WorkingTime({
    this.dayId,
    this.dayName,
    this.openShiftOption,
    this.firstFromTime,
    this.firstToTime,
    this.secondFromTime,
    this.secondToTime,
  });

  WorkingTime copyWith({
    int? dayId,
    String? dayName,
    String? openShiftOption,
    String? firstFromTime,
    String? firstToTime,
    dynamic secondFromTime,
    dynamic secondToTime,
  }) =>
      WorkingTime(
        dayId: dayId ?? this.dayId,
        dayName: dayName ?? this.dayName,
        openShiftOption: openShiftOption ?? this.openShiftOption,
        firstFromTime: firstFromTime ?? this.firstFromTime,
        firstToTime: firstToTime ?? this.firstToTime,
        secondFromTime: secondFromTime ?? this.secondFromTime,
        secondToTime: secondToTime ?? this.secondToTime,
      );

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
}

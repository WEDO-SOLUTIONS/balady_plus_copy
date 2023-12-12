class StatusDetails {
  final int code;
  final String message;

  StatusDetails({required this.code, required this.message});

  factory StatusDetails.fromJson(Map<String, dynamic> json) {
    return StatusDetails(
      code: json['code'] as int,
      message: json['message'] as String,
    );
  }
}

class QrLicenseMessage {
  final int requestId;
  final String shopName;
  final String mobile;
  final int parkingCount;
  final bool hasParking;
  final bool serveDisabledPersons;
  final bool hasVehicleParking;
  final bool hasDelivery;
  final LicenseInfo licenseInfo;

  // final NationalAddressInfo nationalAddressInfo;
  // final SiteDetailsInfo siteDetailsInfo;
  // final List<WorkingTimesInfo> workingTimesInfo;
  // final dynamic attachmentsInfo; // You might want to change the type to match the actual data

  QrLicenseMessage({
    required this.requestId,
    required this.shopName,
    required this.mobile,
    required this.parkingCount,
    required this.hasParking,
    required this.serveDisabledPersons,
    required this.hasVehicleParking,
    required this.hasDelivery,
    required this.licenseInfo,
    // required this.nationalAddressInfo,
    // required this.siteDetailsInfo,
    // required this.workingTimesInfo,
    // required this.attachmentsInfo,
  });

  factory QrLicenseMessage.fromJson(Map<String, dynamic> json) {
    return QrLicenseMessage(
      requestId: json['requestId'] as int,
      shopName: json['shopName'] as String,
      mobile: json['mobile'] as String,
      parkingCount: json['parkingCount'] as int,
      hasParking: json['hasParking'] as bool,
      serveDisabledPersons: json['serveDisabledPersons'] as bool,
      hasVehicleParking: json['hasVehicleParking'] as bool,
      hasDelivery: json['hasDelivery'] as bool,
      licenseInfo: LicenseInfo.fromJson(json['licenseInfo']),
      // nationalAddressInfo: NationalAddressInfo.fromJson(json['nationalAddressInfo']),
      // siteDetailsInfo: SiteDetailsInfo.fromJson(json['siteDetailsInfo']),
      // workingTimesInfo: (json['workingTimesInfo'] as List<dynamic>)
      //     .map((e) => WorkingTimesInfo.fromJson(e))
      //     .toList(),
      // attachmentsInfo: json[
      //     'attachmentsInfo'], // Adjust this based on the actual data structure
    );
  }
}

class LicenseInfo {
  final int licenseId;
  final int issueDate;
  final int expiryDate;
  final Status status;
  final CurrentRequestType currentRequestType;

  LicenseInfo({
    required this.licenseId,
    required this.issueDate,
    required this.expiryDate,
    required this.status,
    required this.currentRequestType,
  });

  factory LicenseInfo.fromJson(Map<String, dynamic> json) {
    return LicenseInfo(
      licenseId: json['licenseId'] as int,
      issueDate: json['issueDate'] as int,
      expiryDate: json['expiryDate'] as int,
      status: Status.fromJson(json['status']),
      currentRequestType:
          CurrentRequestType.fromJson(json['currentRequestType']),
    );
  }
}

class Status {
  final String id;
  final String name;

  Status({required this.id, required this.name});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class CurrentRequestType {
  final String id;
  final String name;

  CurrentRequestType({required this.id, required this.name});

  factory CurrentRequestType.fromJson(Map<String, dynamic> json) {
    return CurrentRequestType(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class NationalAddressInfo {
  final dynamic
      buildingNumber; // You might want to change the type to match the actual data
  final dynamic
      additionalNumber; // You might want to change the type to match the actual data
  final dynamic
      zipCode; // You might want to change the type to match the actual data
  final dynamic
      unitTypeId; // You might want to change the type to match the actual data
  final dynamic
      unitNumber; // You might want to change the type to match the actual data
  final dynamic
      regionCode; // You might want to change the type to match the actual data
  final dynamic
      cityCode; // You might want to change the type to match the actual data
  final dynamic
      floorNumber; // You might want to change the type to match the actual data
  final dynamic
      streetName; // You might want to change the type to match the actual data
  final dynamic
      streetEname; // You might want to change the type to match the actual data

  NationalAddressInfo({
    required this.buildingNumber,
    required this.additionalNumber,
    required this.zipCode,
    required this.unitTypeId,
    required this.unitNumber,
    required this.regionCode,
    required this.cityCode,
    required this.floorNumber,
    required this.streetName,
    required this.streetEname,
  });

  factory NationalAddressInfo.fromJson(Map<String, dynamic> json) {
    return NationalAddressInfo(
      buildingNumber: json['buildingNumber'],
      // Adjust this based on the actual data
      additionalNumber: json['additionalNumber'],
      // Adjust this based on the actual data
      zipCode: json['zipCode'],
      // Adjust this based on the actual data
      unitTypeId: json['unitTypeId'],
      // Adjust this based on the actual data
      unitNumber: json['unitNumber'],
      // Adjust this based on the actual data
      regionCode: json['regionCode'],
      // Adjust this based on the actual data
      cityCode: json['cityCode'],
      // Adjust this based on the actual data
      floorNumber: json['floorNumber'],
      // Adjust this based on the actual data
      streetName: json['streetName'],
      // Adjust this based on the actual data
      streetEname: json['streetEname'], // Adjust this based on the actual data
    );
  }
}

class SiteDetailsInfo {
  final String subMunicipalityGisCode;
  final dynamic
      streetCode; // You might want to change the type to match the actual data
  final dynamic
      streetName; // You might want to change the type to match the actual data
  final dynamic
      districtCode; // You might want to change the type to match the actual data
  final dynamic
      districtName; // You might want to change the type to match the actual data
  final String subMunicipalityName;
  final String municipalityId;
  final String municipalityName;
  final String subMunicipalityId;
  final int regionId;
  final String regionName;
  final dynamic
      latitude; // You might want to change the type to match the actual data
  final dynamic
      longitude; // You might want to change the type to match the actual data

  SiteDetailsInfo({
    required this.subMunicipalityGisCode,
    required this.streetCode,
    required this.streetName,
    required this.districtCode,
    required this.districtName,
    required this.subMunicipalityName,
    required this.municipalityId,
    required this.municipalityName,
    required this.subMunicipalityId,
    required this.regionId,
    required this.regionName,
    required this.latitude,
    required this.longitude,
  });

  factory SiteDetailsInfo.fromJson(Map<String, dynamic> json) {
    return SiteDetailsInfo(
      subMunicipalityGisCode: json['subMunicipalityGisCode'] as String,
      streetCode: json['streetCode'],
      // Adjust this based on the actual data
      streetName: json['streetName'],
      // Adjust this based on the actual data
      districtCode: json['districtCode'],
      // Adjust this based on the actual data
      districtName: json['districtName'],
      // Adjust this based on the actual data
      subMunicipalityName: json['subMunicipalityName'] as String,
      municipalityId: json['municipalityId'] as String,
      municipalityName: json['municipalityName'] as String,
      subMunicipalityId: json['subMunicipalityId'] as String,
      regionId: json['regionId'] as int,
      regionName: json['regionName'] as String,
      latitude: json['latitude'],
      // Adjust this based on the actual data
      longitude: json['longitude'], // Adjust this based on the actual data
    );
  }
}

class WorkingTimesInfo {
  final int dayId;
  final String dayName;
  final String openShiftOption;
  final dynamic
      firstFromTime; // You might want to change the type to match the actual data
  final dynamic
      firstToTime; // You might want to change the type to match the actual data
  final dynamic
      secondFromTime; // You might want to change the type to match the actual data
  final dynamic
      secondToTime; // You might want to change the type to match the actual data

  WorkingTimesInfo({
    required this.dayId,
    required this.dayName,
    required this.openShiftOption,
    required this.firstFromTime,
    required this.firstToTime,
    required this.secondFromTime,
    required this.secondToTime,
  });

  factory WorkingTimesInfo.fromJson(Map<String, dynamic> json) {
    return WorkingTimesInfo(
      dayId: json['dayId'] as int,
      dayName: json['dayName'] as String,
      openShiftOption: json['openShiftOption'] as String,
      firstFromTime: json['firstFromTime'],
      // Adjust this based on the actual data
      firstToTime: json['firstToTime'],
      // Adjust this based on the actual data
      secondFromTime: json['secondFromTime'],
      // Adjust this based on the actual data
      secondToTime:
          json['secondToTime'], // Adjust this based on the actual data
    );
  }
}

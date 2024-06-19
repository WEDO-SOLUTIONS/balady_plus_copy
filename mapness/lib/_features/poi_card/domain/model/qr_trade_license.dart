// ignore_for_file: argument_type_not_assignable
// ignore_for_file: avoid_dynamic_calls
// ignore_for_file: not_assigned_potentially_non_nullable_local_variable
class StatusDetails {
  StatusDetails({required this.code, required this.message});

  factory StatusDetails.fromJson(Map<String, dynamic> json) => StatusDetails(
        code: json['code'] as int,
        message: json['message'] as String,
      );
  final int code;
  final String message;
}

class QrLicenseMessage {
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
    required this.nationalAddressInfo,
    // required this.siteDetailsInfo,
    required this.workingTimesInfo,
    // required this.attachmentsInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'shopName': shopName,
      'mobile': mobile,
      'parkingCount': parkingCount,
      'hasParking': hasParking,
      'serveDisabledPersons': serveDisabledPersons,
      'hasVehicleParking': hasVehicleParking,
      'hasDelivery': hasDelivery,
      'licenseInfo': licenseInfo.toJson(),
      'nationalAddressInfo': nationalAddressInfo.toJson(),
      'workingTimesInfo': workingTimesInfo.map((e) => e.toJson()).toList(),
    };
  }

  factory QrLicenseMessage.fromJson(Map<String, dynamic> json) => QrLicenseMessage(
        requestId: json['requestId'] as int,
        shopName: json['shopName'] as String,
        mobile: json['mobile'] as String?,
        parkingCount: json['parkingCount'] as int,
        hasParking: json['hasParking'] as bool,
        serveDisabledPersons: json['serveDisabledPersons'] as bool,
        hasVehicleParking: json['hasVehicleParking'] as bool,
        hasDelivery: json['hasDelivery'] as bool,
        licenseInfo: LicenseInfo.fromJson(json['licenseInfo']),
        nationalAddressInfo: NationalAddressInfo.fromJson(json['nationalAddressInfo']),
        // siteDetailsInfo: SiteDetailsInfo.fromJson(json['siteDetailsInfo']),
        workingTimesInfo: (json['workingTimesInfo'] as List<dynamic>)
            .map((e) => WorkingTimesInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
        // attachmentsInfo: json[
        //     'attachmentsInfo'], // Adjust this based on the actual data structure
      );
  final int requestId;
  final String shopName;
  final String? mobile;
  final int parkingCount;
  final bool hasParking;
  final bool serveDisabledPersons;
  final bool hasVehicleParking;
  final bool hasDelivery;
  final LicenseInfo licenseInfo;
  final NationalAddressInfo nationalAddressInfo;

  // final SiteDetailsInfo siteDetailsInfo;
  final List<WorkingTimesInfo> workingTimesInfo;
}

class LicenseInfo {
  LicenseInfo({
    required this.licenseId,
    required this.issueDate,
    required this.expiryDate,
    required this.status,
    required this.currentRequestType,
  });

  Map<String, dynamic> toJson() {
    return {
      'licenseId': licenseId,
      'issueDate': issueDate,
      'expiryDate': expiryDate,
      'status': status.toJson(),
      'currentRequestType': currentRequestType.toJson(),
    };
  }

  factory LicenseInfo.fromJson(Map<String, dynamic> json) => LicenseInfo(
        licenseId: json['licenseId'] as int,
        issueDate: json['issueDate'] as int,
        expiryDate: json['expiryDate'] as int,
        status: Status.fromJson(json['status']),
        currentRequestType: CurrentRequestType.fromJson(json['currentRequestType']),
      );
  final int licenseId;
  final int issueDate;
  final int expiryDate;
  final Status status;
  final CurrentRequestType currentRequestType;
}

class Status {
  Status({required this.id, required this.name});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json['id'] as String,
        name: json['name'] as String,
      );
  final String id;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

}

class CurrentRequestType {
  CurrentRequestType({required this.id, required this.name});

  factory CurrentRequestType.fromJson(Map<String, dynamic> json) => CurrentRequestType(
        id: json['id'] as String,
        name: json['name'] as String,
      );
  final String id;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class NationalAddressInfo {
  // You might want to change the type to match the actual data

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

  factory NationalAddressInfo.fromJson(Map<String, dynamic> json) => NationalAddressInfo(
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
  final dynamic buildingNumber; // You might want to change the type to match the actual data
  final dynamic additionalNumber; // You might want to change the type to match the actual data
  final dynamic zipCode; // You might want to change the type to match the actual data
  final dynamic unitTypeId; // You might want to change the type to match the actual data
  final dynamic unitNumber; // You might want to change the type to match the actual data
  final dynamic regionCode; // You might want to change the type to match the actual data
  final dynamic cityCode; // You might want to change the type to match the actual data
  final dynamic floorNumber; // You might want to change the type to match the actual data
  final dynamic streetName; // You might want to change the type to match the actual data
  final dynamic streetEname;

  Map<String, dynamic> toJson() {
    return {
      'buildingNumber': buildingNumber,
      'additionalNumber': additionalNumber,
      'zipCode': zipCode,
      'unitTypeId': unitTypeId,
      'unitNumber': unitNumber,
      'regionCode': regionCode,
      'cityCode': cityCode,
      'floorNumber': floorNumber,
      'streetName': streetName,
      'streetEname': streetEname,
    };
  }
}

class SiteDetailsInfo {
  // You might want to change the type to match the actual data

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

  factory SiteDetailsInfo.fromJson(Map<String, dynamic> json) => SiteDetailsInfo(
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
  final String subMunicipalityGisCode;
  final dynamic streetCode; // You might want to change the type to match the actual data
  final dynamic streetName; // You might want to change the type to match the actual data
  final dynamic districtCode; // You might want to change the type to match the actual data
  final dynamic districtName; // You might want to change the type to match the actual data
  final String subMunicipalityName;
  final String municipalityId;
  final String municipalityName;
  final String subMunicipalityId;
  final int regionId;
  final String regionName;
  final dynamic latitude; // You might want to change the type to match the actual data
  final dynamic longitude;
}

class WorkingTimesInfo {
  // You might want to change the type to match the actual data

  WorkingTimesInfo({
    required this.dayId,
    required this.dayName,
    required this.openShiftOption,
    required this.firstFromTime,
    required this.firstToTime,
    required this.secondFromTime,
    required this.secondToTime,
  });

  factory WorkingTimesInfo.fromJson(Map<String, dynamic> json) => WorkingTimesInfo(
        dayId: json['dayId'] as int,
        dayName: json['dayName'] as String,
        openShiftOption: json['openShiftOption'] as String,
        firstFromTime: json['firstFromTime'],
        // Adjust this based on the actual data
        firstToTime: json['firstToTime'],
        // Adjust this based on the actual data
        secondFromTime: json['secondFromTime'],
        // Adjust this based on the actual data
        secondToTime: json['secondToTime'], // Adjust this based on the actual data
      );
  final int dayId;
  final String dayName;
  final String openShiftOption;
  final dynamic firstFromTime; // You might want to change the type to match the actual data
  final dynamic firstToTime; // You might want to change the type to match the actual data
  final dynamic secondFromTime; // You might want to change the type to match the actual data
  final dynamic secondToTime;


  Map<String, dynamic> toJson() {
    return {
      'dayId': dayId,
      'dayName': dayName,
      'openShiftOption': openShiftOption,
      'firstFromTime': firstFromTime,
      'firstToTime': firstToTime,
      'secondFromTime': secondFromTime,
      'secondToTime': secondToTime,
    };
  }
}

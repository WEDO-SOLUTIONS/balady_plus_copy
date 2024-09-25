// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'apply_commercial_response_model.dart';

class SaveEnterprisDataRequest {
  final int? requestId;
  final ContactInfo? contactInfo;
  final List<CrOwner>? crOwners;
  final List<EmployeesInfo>? employeesInfo;
  final bool? hasPaymentMethods;
  final String? managerBirthDate;
  final String? managerIdentityNumber;
  final String? managerName;
  final int? managerNationalityId;
  final String? managerNationalityName;
  final int? managerProfessionalId;
  final String? managerProfessionalName;
  final int? managerSexId;
  final String? managerSexName;
  final String? ownerEmail;
  final String? ownerIdentityNumber;
  final int? ownerIdentityTypeId;
  final String? ownerIdentityTypeName;
  final String? ownerMobileNumber;
  final String? ownerName;
  final List<PaymentMethod>? paymentMethods;
  final QrEnterpriseLocationDto? qrEnterpriseLocationDto;

  SaveEnterprisDataRequest({
    this.requestId,
    this.contactInfo,
    this.crOwners,
    this.employeesInfo,
    this.hasPaymentMethods,
    this.managerBirthDate,
    this.managerIdentityNumber,
    this.managerName,
    this.managerNationalityId,
    this.managerNationalityName,
    this.managerProfessionalId,
    this.managerProfessionalName,
    this.managerSexId,
    this.managerSexName,
    this.ownerEmail,
    this.ownerIdentityNumber,
    this.ownerIdentityTypeId,
    this.ownerIdentityTypeName,
    this.ownerMobileNumber,
    this.ownerName,
    this.paymentMethods,
    this.qrEnterpriseLocationDto,
  });

  factory SaveEnterprisDataRequest.fromJson(Map<String, dynamic> json) =>
      SaveEnterprisDataRequest(
        contactInfo: json["contactInfo"] == null
            ? null
            : ContactInfo.fromJson(json["contactInfo"]),
        crOwners: json["crOwners"] == null
            ? []
            : List<CrOwner>.from(
                json["crOwners"]!.map((x) => CrOwner.fromJson(x))),
        employeesInfo: json["employeesInfo"] == null
            ? []
            : List<EmployeesInfo>.from(
                json["employeesInfo"]!.map((x) => EmployeesInfo.fromJson(x))),
        hasPaymentMethods: json["hasPaymentMethods"],
        managerBirthDate: json["managerBirthDate"],
        managerIdentityNumber: json["managerIdentityNumber"],
        managerName: json["managerName"],
        managerNationalityId: json["managerNationalityId"],
        managerNationalityName: json["managerNationalityName"],
        managerProfessionalId: json["managerProfessionalId"],
        managerProfessionalName: json["managerProfessionalName"],
        managerSexId: json["managerSexId"],
        managerSexName: json["managerSexName"],
        ownerEmail: json["ownerEmail"],
        ownerIdentityNumber: json["ownerIdentityNumber"],
        ownerIdentityTypeId: json["ownerIdentityTypeId"],
        ownerIdentityTypeName: json["ownerIdentityTypeName"],
        ownerMobileNumber: json["ownerMobileNumber"],
        ownerName: json["ownerName"],
        paymentMethods: json["paymentMethods"] == null
            ? []
            : List<PaymentMethod>.from(
                json["paymentMethods"]!.map((x) => PaymentMethod.fromJson(x))),
        qrEnterpriseLocationDto: json["qrEnterpriseLocationDto"] == null
            ? null
            : QrEnterpriseLocationDto.fromJson(json["qrEnterpriseLocationDto"]),
      );

  Map<String, dynamic> toJson() => {
        "contactInfo": contactInfo?.toJson(),
        "crOwners": crOwners == null
            ? []
            : List<dynamic>.from(crOwners!.map((x) => x.toJson())),
        "employeesInfo": employeesInfo == null
            ? []
            : List<dynamic>.from(employeesInfo!.map((x) => x.toJson())),
        "hasPaymentMethods": hasPaymentMethods,
        "managerBirthDate": managerBirthDate,
        "managerIdentityNumber": managerIdentityNumber,
        "managerName": managerName,
        "managerNationalityId": managerNationalityId,
        "managerNationalityName": managerNationalityName,
        "managerProfessionalId": managerProfessionalId,
        "managerProfessionalName": managerProfessionalName,
        "managerSexId": managerSexId,
        "managerSexName": managerSexName,
        "ownerEmail": ownerEmail,
        "ownerIdentityNumber": ownerIdentityNumber,
        "ownerIdentityTypeId": ownerIdentityTypeId,
        "ownerIdentityTypeName": ownerIdentityTypeName,
        "ownerMobileNumber": ownerMobileNumber,
        "ownerName": ownerName,
        "paymentMethods": paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "qrEnterpriseLocationDto": qrEnterpriseLocationDto?.toJson(),
      };
}

class EmployeesInfo {
  final String? birthDate;
  final String? identityNumber;
  final String? name;
  final int? nationalityId;
  final String? nationalityName;
  final int? professionalId;
  final String? professionalName;
  final int? sexId;
  final String? sexName;

  EmployeesInfo({
    this.birthDate,
    this.identityNumber,
    this.name,
    this.nationalityId,
    this.nationalityName,
    this.professionalId,
    this.professionalName,
    this.sexId,
    this.sexName,
  });

  factory EmployeesInfo.fromJson(Map<String, dynamic> json) => EmployeesInfo(
        birthDate: json["birthDate"],
        identityNumber: json["identityNumber"],
        name: json["name"],
        nationalityId: json["nationalityId"],
        nationalityName: json["nationalityName"],
        professionalId: json["professionalId"],
        professionalName: json["professionalName"],
        sexId: json["sexId"],
        sexName: json["sexName"],
      );

  Map<String, dynamic> toJson() => {
        "birthDate": birthDate,
        "identityNumber": identityNumber,
        "name": name,
        "nationalityId": nationalityId,
        "nationalityName": nationalityName,
        "professionalId": professionalId,
        "professionalName": professionalName,
        "sexId": sexId,
        "sexName": sexName,
      };
}

class PaymentMethod {
  final String? ename;
  final int? id;
  final String? name;

  PaymentMethod({
    this.ename,
    this.id,
    this.name,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        ename: json["ename"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "ename": ename,
        "id": id,
        "name": name,
      };
}

class QrEnterpriseLocationDto {
  final LocationInsideBuildingDto? locationInsideBuildingDto;
  final LocationOnStreetDto? locationOnStreetDto;
  final NationalAddress? nationalAddress;
  final String? siteLocationType;

  QrEnterpriseLocationDto({
    this.locationInsideBuildingDto,
    this.locationOnStreetDto,
    this.nationalAddress,
    this.siteLocationType,
  });

  factory QrEnterpriseLocationDto.fromJson(Map<String, dynamic> json) =>
      QrEnterpriseLocationDto(
        locationInsideBuildingDto: json["locationInsideBuildingDto"] == null
            ? null
            : LocationInsideBuildingDto.fromJson(
                json["locationInsideBuildingDto"]),
        locationOnStreetDto: json["locationOnStreetDto"] == null
            ? null
            : LocationOnStreetDto.fromJson(json["locationOnStreetDto"]),
        nationalAddress: json["nationalAddress"] == null
            ? null
            : NationalAddress.fromJson(json["nationalAddress"]),
        siteLocationType: json["siteLocationType"],
      );

  Map<String, dynamic> toJson() => {
        "locationInsideBuildingDto": locationInsideBuildingDto?.toJson(),
        "locationOnStreetDto": locationOnStreetDto?.toJson(),
        "nationalAddress": nationalAddress?.toJson(),
        "siteLocationType": siteLocationType,
      };

  QrEnterpriseLocationDto copyWith({
    LocationInsideBuildingDto? locationInsideBuildingDto,
    LocationOnStreetDto? locationOnStreetDto,
    NationalAddress? nationalAddress,
    String? siteLocationType,
  }) {
    return QrEnterpriseLocationDto(
      locationInsideBuildingDto:
          locationInsideBuildingDto ?? this.locationInsideBuildingDto,
      locationOnStreetDto: locationOnStreetDto ?? this.locationOnStreetDto,
      nationalAddress: nationalAddress ?? this.nationalAddress,
      siteLocationType: siteLocationType ?? this.siteLocationType,
    );
  }
}

class LocationInsideBuildingDto {
  final String? accessDirections;
  final String? buildingName;
  final int? buildingNatureId;

  LocationInsideBuildingDto({
    this.accessDirections,
    this.buildingName,
    this.buildingNatureId,
  });

  factory LocationInsideBuildingDto.fromJson(Map<String, dynamic> json) =>
      LocationInsideBuildingDto(
        accessDirections: json["accessDirections"],
        buildingName: json["buildingName"],
        buildingNatureId: json["buildingNatureId"],
      );

  Map<String, dynamic> toJson() => {
        "accessDirections": accessDirections,
        "buildingName": buildingName,
        "buildingNatureId": buildingNatureId,
      };

  LocationInsideBuildingDto copyWith({
    String? accessDirections,
    String? buildingName,
    int? buildingNatureId,
  }) {
    return LocationInsideBuildingDto(
      accessDirections: accessDirections ?? this.accessDirections,
      buildingName: buildingName ?? this.buildingName,
      buildingNatureId: buildingNatureId ?? this.buildingNatureId,
    );
  }
}

class LocationOnStreetDto {
  final String? nearestLandmark;
  final String? siteDescription;
  final String? siteName;
  final int? siteNatureId;

  LocationOnStreetDto({
    this.nearestLandmark,
    this.siteDescription,
    this.siteName,
    this.siteNatureId,
  });

  factory LocationOnStreetDto.fromJson(Map<String, dynamic> json) =>
      LocationOnStreetDto(
        nearestLandmark: json["nearestLandmark"],
        siteDescription: json["siteDescription"],
        siteName: json["siteName"],
        siteNatureId: json["siteNatureId"],
      );

  Map<String, dynamic> toJson() => {
        "nearestLandmark": nearestLandmark,
        "siteDescription": siteDescription,
        "siteName": siteName,
        "siteNatureId": siteNatureId,
      };

  LocationOnStreetDto copyWith({
    String? nearestLandmark,
    String? siteDescription,
    String? siteName,
    int? siteNatureId,
  }) {
    return LocationOnStreetDto(
      nearestLandmark: nearestLandmark ?? this.nearestLandmark,
      siteDescription: siteDescription ?? this.siteDescription,
      siteName: siteName ?? this.siteName,
      siteNatureId: siteNatureId ?? this.siteNatureId,
    );
  }
}

class NationalAddress {
  final String? additionalNumber;
  final String? buildingNumber;
  final String? cityCode;
  final int? floorNumber;
  final String? regionCode;
  final String? streetEname;
  final String? streetName;
  final String? unitNumber;
  final String? unitTypeId;
  final String? zipCode;

  NationalAddress({
    this.additionalNumber,
    this.buildingNumber,
    this.cityCode,
    this.floorNumber,
    this.regionCode,
    this.streetEname,
    this.streetName,
    this.unitNumber,
    this.unitTypeId,
    this.zipCode,
  });

  factory NationalAddress.fromJson(Map<String, dynamic> json) =>
      NationalAddress(
        additionalNumber: json["additionalNumber"],
        buildingNumber: json["buildingNumber"],
        cityCode: json["cityCode"],
        floorNumber: json["floorNumber"],
        regionCode: json["regionCode"],
        streetEname: json["streetEname"],
        streetName: json["streetName"],
        unitNumber: json["unitNumber"],
        unitTypeId: json["unitTypeId"],
        zipCode: json["zipCode"],
      );

  Map<String, dynamic> toJson() => {
        "additionalNumber": additionalNumber,
        "buildingNumber": buildingNumber,
        "cityCode": cityCode,
        "floorNumber": floorNumber,
        "regionCode": regionCode,
        "streetEname": streetEname,
        "streetName": streetName,
        "unitNumber": unitNumber,
        "unitTypeId": unitTypeId,
        "zipCode": zipCode,
      };

  NationalAddress copyWith({
    String? additionalNumber,
    String? buildingNumber,
    String? cityCode,
    int? floorNumber,
    String? regionCode,
    String? streetEname,
    String? streetName,
    String? unitNumber,
    String? unitTypeId,
    String? zipCode,
  }) {
    return NationalAddress(
      additionalNumber: additionalNumber ?? this.additionalNumber,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      cityCode: cityCode ?? this.cityCode,
      floorNumber: floorNumber ?? this.floorNumber,
      regionCode: regionCode ?? this.regionCode,
      streetEname: streetEname ?? this.streetEname,
      streetName: streetName ?? this.streetName,
      unitNumber: unitNumber ?? this.unitNumber,
      unitTypeId: unitTypeId ?? this.unitTypeId,
      zipCode: zipCode ?? this.zipCode,
    );
  }
}

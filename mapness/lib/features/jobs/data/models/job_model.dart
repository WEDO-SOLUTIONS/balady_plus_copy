import 'package:flutter/foundation.dart';

//TODO(Scroollocker): change to equatable
@immutable
class JobModel {
  const JobModel({
    this.id,
    this.number,
    this.name,
    this.provider,
    this.description,
    this.workHours,
    this.contractType,
    this.expiryDate,
    this.skills,
    this.email,
    this.mobile,
    this.location,
    this.publishDate,
    this.commercialLicenseNumber,
    this.saudi,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        id: json['id'] as String?,
        number: json['number'] as String?,
        name: json['name'] as String?,
        provider: json['provider'] == null ? null : ProviderModel.fromJson(json['provider'] as Map<String, dynamic>),
        description: json['description'] as String?,
        workHours: json['workHours'] as double?,
        contractType: json['contractType'] == null
            ? null
            : ContractTypeModel.fromJson(
                json['contractType'] as Map<String, dynamic>,
              ),
        expiryDate: json['expiryDate'] as String?,
        skills: json['skills'] as String?,
        email: json['email'] as String?,
        mobile: json['mobile'] as String?,
        location: json['location'] == null ? null : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
        publishDate: json['publishDate'] as String?,
        commercialLicenseNumber: json['commercialLicenseNumber'] as String?,
        saudi: json['saudi'] as bool?,
      );
  final String? id;
  final String? number;
  final String? name;
  final ProviderModel? provider;
  final String? description;
  final double? workHours;
  final ContractTypeModel? contractType;
  final String? expiryDate;
  final String? skills;
  final String? email;
  final String? mobile;
  final LocationModel? location;
  final String? publishDate;
  final String? commercialLicenseNumber;
  final bool? saudi;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is JobModel &&
        other.id == id &&
        other.number == number &&
        other.name == name &&
        other.provider == provider &&
        other.description == description &&
        other.workHours == workHours &&
        other.contractType == contractType &&
        other.expiryDate == expiryDate &&
        other.skills == skills &&
        other.email == email &&
        other.mobile == mobile &&
        other.location == location &&
        other.publishDate == publishDate &&
        other.commercialLicenseNumber == commercialLicenseNumber &&
        other.saudi == saudi;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      number.hashCode ^
      name.hashCode ^
      provider.hashCode ^
      description.hashCode ^
      workHours.hashCode ^
      contractType.hashCode ^
      expiryDate.hashCode ^
      skills.hashCode ^
      email.hashCode ^
      mobile.hashCode ^
      location.hashCode ^
      publishDate.hashCode ^
      commercialLicenseNumber.hashCode ^
      saudi.hashCode;
}

@immutable
class LocationModel {
  const LocationModel({
    this.latitude,
    this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as String?,
      );
  final String? latitude;
  final String? longitude;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is LocationModel && other.latitude == latitude && other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

@immutable
class ProviderModel {
  const ProviderModel({
    this.id,
    this.name,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
      );
  final String? id;
  final String? name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ProviderModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

@immutable
class ContractTypeModel {
  const ContractTypeModel({
    this.id,
    this.name,
  });

  factory ContractTypeModel.fromJson(Map<String, dynamic> json) => ContractTypeModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
      );
  final String? id;
  final String? name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ContractTypeModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ComplinaecLicensesReponse extends Equatable {
  final List<ComplianceLisenseItem>? items;

  const ComplinaecLicensesReponse({this.items});

  @override
  List<Object?> get props => [items];
}

class ComplianceLisenseItem extends Equatable {
  final double? licenseId;
  final String? oldLicenseNo;
  final int? requestId;
  final String? licenseType;
  final String? issuingDate;
  final String? expirationDate;
  final String? ownerIdentityNumber;
  final int? ownerIdentityType;
  final String? ownerName;
  final String? municipalityId;
  final String? municipalityName;
  final String? subMunicipalityId;
  final String? subMunicipalityName;
  final String? districtName;
  final String? mapNo;
  final String? landNo;
  final String? ownershipDocumentType;
  final String? ownershipDocumentNumber;
  final String? ownershipDocumentDate;
  final String? notes;
  final int? statusId;
  final String? statusName;
  final String? holdReason;
  final bool? validToApply;
  final String? insuranceNumber;
  final dynamic? insuranceDate;
  ComplianceLisenseItem({
    this.licenseId,
    this.oldLicenseNo,
    this.requestId,
    this.licenseType,
    this.issuingDate,
    this.expirationDate,
    this.ownerIdentityNumber,
    this.ownerIdentityType,
    this.ownerName,
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.subMunicipalityName,
    this.districtName,
    this.mapNo,
    this.landNo,
    this.ownershipDocumentType,
    this.ownershipDocumentNumber,
    this.ownershipDocumentDate,
    this.notes,
    this.statusId,
    this.statusName,
    this.holdReason,
    this.validToApply,
    this.insuranceNumber,
    this.insuranceDate,
  });

  @override
  List<Object?> get props => [licenseId, requestId];
}

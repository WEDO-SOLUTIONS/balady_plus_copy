// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/complinace_licenses_response.dart';

class ComplinaecLicensesReponseModel extends ComplinaecLicensesReponse {
  const ComplinaecLicensesReponseModel({super.items});

  factory ComplinaecLicensesReponseModel.fromJson(dynamic json) =>
      ComplinaecLicensesReponseModel(
        items: json == null
            ? []
            : List<ComplianceLisenseItemModel>.from(
                json!.map((x) => ComplianceLisenseItemModel.fromJson(x))),
      );
  @override
  List<Object?> get props => [items];
}

class ComplianceLisenseItemModel extends ComplianceLisenseItem {
  ComplianceLisenseItemModel({
    super.licenseId,
    super.oldLicenseNo,
    super.requestId,
    super.licenseType,
    super.issuingDate,
    super.expirationDate,
    super.ownerIdentityNumber,
    super.ownerIdentityType,
    super.ownerName,
    super.municipalityId,
    super.municipalityName,
    super.subMunicipalityId,
    super.subMunicipalityName,
    super.districtName,
    super.mapNo,
    super.landNo,
    super.ownershipDocumentType,
    super.ownershipDocumentNumber,
    super.ownershipDocumentDate,
    super.notes,
    super.statusId,
    super.statusName,
    super.holdReason,
    super.validToApply,
    super.insuranceNumber,
    super.insuranceDate,
  });

  factory ComplianceLisenseItemModel.fromJson(Map<String, dynamic> json) =>
      ComplianceLisenseItemModel(
        licenseId: json["licenseId"]?.toDouble(),
        oldLicenseNo: json["oldLicenseNo"],
        requestId: json["requestId"],
        licenseType: json["licenseType"],
        issuingDate: json["issuingDate"],
        expirationDate: json["expirationDate"],
        ownerIdentityNumber: json["ownerIdentityNumber"],
        ownerIdentityType: json["ownerIdentityType"],
        ownerName: json["ownerName"],
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        subMunicipalityId: json["subMunicipalityId"],
        subMunicipalityName: json["subMunicipalityName"],
        districtName: json["districtName"],
        mapNo: json["mapNo"],
        landNo: json["landNo"],
        ownershipDocumentType: json["ownershipDocumentType"],
        ownershipDocumentNumber: json["ownershipDocumentNumber"],
        ownershipDocumentDate: json["ownershipDocumentDate"],
        notes: json["notes"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        holdReason: json["holdReason"],
        validToApply: json["validToApply"],
        insuranceNumber: json["insuranceNumber"],
        insuranceDate: json["insuranceDate"],
      );

  @override
  List<Object?> get props => [licenseId, requestId];
}

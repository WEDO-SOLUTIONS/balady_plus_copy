import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/create_compliance/create_compliance_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_response.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:collection/collection.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/nullable.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/models/attachment_model.dart';
import '../../../_shared_feature_/data/entities/validators/phone_number_validation.dart';
import '../../data/models/apply_create_compliance_request_model.dart';
import '../../domain/entities/compliance_gis_resopnse.dart';
import '../../domain/entities/complinace_licenses_response.dart';
import '../../domain/entities/ownership_doc_type_response.dart';

class ComplianceState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final BlocRequestStatus mainUsagesStatus;
  final BlocRequestStatus subUsagesStatus;
  final BlocRequestStatus licenseStatus;
  final BlocRequestStatus detailsStatus;

  final BlocRequestStatus ownerShipsStatus;
  final BlocRequestStatus enginnerOfficesStatus;

  final int currentStep;
  final int? benificiaryTypeSelection;
  final int? documentTypeSelection;
  final int? requestId;
  final ComplianceRequestDetails? requestDetails;
  final ComplinaceLookUpResponse? mainUsages;
  final ComplinaceLookUpResponse? subUsages;
  final ComplinaceLookUpResponse? ownerShipsTypes;

  final ComplinaceLookUpItem? selectedMainUsage;
  final ComplinaceLookUpItem? selectedSubUsage;
  final ComplinaceLookUpItem? selectedOwnerShip;
  final String? ownershipText;
  final String? ownershipDate;

  final ComplinaecLicensesReponse? licenes;
  final ComplianceLisenseItem? selectedLicense;
  final ComplainceGISResponse? gisResponse;
  final GISParams? gisParams;
  final List<AttachmentData>? attachments;
  final ApplyCreateComplianceRequest? applyRequest;
  final String? contactMobileNumber;

  PhoneNumberValidation get phoneValidator => contactMobileNumber == null
      ? PhoneNumberValidation.pure()
      : PhoneNumberValidation.dirty(value: contactMobileNumber);
  String? get phoneErrorText => phoneValidator.error?.message != null
      ? (phoneValidator.error?.message ?? "").tr()
      : null;

  ComplianceState({
    required this.currentStep,
    this.status = BlocStatus.initial,
    this.mainUsagesStatus = BlocRequestStatus.initial,
    this.enginnerOfficesStatus = BlocRequestStatus.initial,
    this.subUsagesStatus = BlocRequestStatus.initial,
    this.ownerShipsStatus = BlocRequestStatus.initial,
    this.licenseStatus = BlocRequestStatus.initial,
    this.licenes,
    this.contactMobileNumber,
    this.applyRequest,
    this.benificiaryTypeSelection,
    this.documentTypeSelection,
    this.requestId,
    this.requestDetails,
    this.mainUsages,
    this.subUsages,
    this.ownerShipsTypes,
    this.errorMessage,
    this.selectedMainUsage,
    this.selectedOwnerShip,
    this.selectedSubUsage,
    this.ownershipText,
    this.ownershipDate,
    this.selectedLicense,
    this.detailsStatus = BlocRequestStatus.initial,
    this.gisResponse,
    this.gisParams,
    this.attachments,
  });
  ComplianceState copyWith(
      {final BlocStatus? status,
      final int? currentStep,
      final int? benificiaryTypeSelection,
      final int? documentTypeSelection,
      final int? requestId,
      final ComplianceRequestDetails? requestDetails,
      final ComplinaceLookUpResponse? mainUsages,
      final ComplinaceLookUpResponse? subUsages,
      final ComplinaceLookUpResponse? ownerShipsTypes,
      final BlocRequestStatus? mainUsagesStatus,
      final BlocRequestStatus? ownerShipsStatus,
      final BlocRequestStatus? enginnerOfficesStatus,
      final BlocRequestStatus? subUsagesStatus,
      final BlocRequestStatus? licenseStatus,
      final String? errorMessage,
      final ComplinaceLookUpItem? selectedMainUsage,
      final ComplinaceLookUpItem? selectedSubUsage,
      final Nullable<ComplinaceLookUpItem?>? selectedOwnerShip,
      final Nullable<String?>? ownershipText,
      final Nullable<String?>? ownershipDate,
      final ComplinaecLicensesReponse? licenes,
      final Nullable<ComplianceLisenseItem?>? selectedLicense,
      final BlocRequestStatus? detailsStatus,
      final ComplainceGISResponse? gisResponse,
      final GISParams? gisParams,
      final List<AttachmentData>? attachments,
      final ApplyCreateComplianceRequest? applyRequest,
      final String? contactMobileNumber}) {
    return ComplianceState(
        status: status ?? this.status,
        contactMobileNumber: contactMobileNumber ?? this.contactMobileNumber,
        currentStep: currentStep ?? this.currentStep,
        benificiaryTypeSelection:
            benificiaryTypeSelection ?? this.benificiaryTypeSelection,
        documentTypeSelection:
            documentTypeSelection ?? this.documentTypeSelection,
        requestId: requestId ?? this.requestId,
        requestDetails: requestDetails ?? this.requestDetails,
        mainUsages: mainUsages ?? this.mainUsages,
        subUsages: subUsages ?? this.subUsages,
        ownerShipsTypes: ownerShipsTypes ?? this.ownerShipsTypes,
        enginnerOfficesStatus:
            enginnerOfficesStatus ?? this.enginnerOfficesStatus,
        ownerShipsStatus: ownerShipsStatus ?? this.ownerShipsStatus,
        mainUsagesStatus: mainUsagesStatus ?? this.mainUsagesStatus,
        licenseStatus: licenseStatus ?? this.licenseStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        selectedMainUsage: selectedMainUsage ?? this.selectedMainUsage,
        selectedOwnerShip: selectedOwnerShip == null
            ? this.selectedOwnerShip
            : selectedOwnerShip.value,
        selectedSubUsage: selectedSubUsage ?? this.selectedSubUsage,
        ownershipText:
            ownershipText == null ? this.ownershipText : ownershipText.value,
        ownershipDate:
            ownershipDate == null ? this.ownershipDate : ownershipDate.value,
        subUsagesStatus: subUsagesStatus ?? this.subUsagesStatus,
        licenes: licenes ?? this.licenes,
        selectedLicense: selectedLicense == null
            ? this.selectedLicense
            : selectedLicense.value,
        detailsStatus: detailsStatus ?? this.detailsStatus,
        gisResponse: gisResponse ?? this.gisResponse,
        gisParams: gisParams ?? this.gisParams,
        attachments: attachments ?? this.attachments,
        applyRequest: applyRequest ?? this.applyRequest);
  }

  bool isNextButtonEnabled() {
    if (currentStep == 0) {
      bool isValid = true;

      if (benificiaryTypeSelection == null) isValid = false;
      return isValid;
    } else if (currentStep == 1) {
      bool form = Formz.validate([phoneValidator]);
      if (form)
        return true;
      else
        return false;
    } else if (currentStep == 2) {
      if (documentTypeSelection == null) return false;

      if (documentTypeSelection == 1) {
        if (selectedLicense == null) return false;
      }

      if (documentTypeSelection == 2) {
        if (selectedOwnerShip == null ||
            (ownershipText?.isEmpty ?? true) ||
            ownershipDate == null ||
            gisResponse == null) return false;
      }
    } else if (currentStep == 3) {
      if (selectedMainUsage == null || selectedSubUsage == null) return false;
    } else if (currentStep == 4) {
      bool valid = requestDetails?.emtithalItems?.firstWhereOrNull(
              (element) => element.submitterAnswer == null) ==
          null;
      return valid;
    } else if (currentStep == 5) {
      bool isValid = true;
      if (attachments != null && attachments!.isNotEmpty) {
        attachments!.forEach((element) {
          if (element.isRequired && element.isUploaded != true) isValid = false;
        });
      }
      return isValid;
    }
    return true;
  }

  ApplyCreateComplianceRequest generateRequest() =>
      ApplyCreateComplianceRequest(
          certificateType:
              documentTypeSelection == 1 ? "LICENSE_NUMBER" : "OWNERSHIP_DOC",
          licenseNumber: documentTypeSelection == 1
              ? selectedLicense?.licenseId?.toInt()
              : null,
          contactMobile: CommonProperties.userInfo?.getPhone(),
          ownershipDocumentDate:
              documentTypeSelection == 2 ? ownershipDate : null,
          ownershipDocumentNo:
              documentTypeSelection == 2 ? ownershipText : null,
          ownershipDocumentType:
              documentTypeSelection == 2 ? selectedOwnerShip?.id : null,
          submitterThrough: benificiaryTypeSelection == 1
              ? "BENEFICARY"
              : "ENGINEERING_OFFICE");

  @override
  List<Object?> get props => [
        status,
        gisResponse,
        gisParams,
        currentStep,
        requestId,
        requestDetails,
        mainUsages,
        errorMessage,
        subUsages,
        ownerShipsTypes,
        enginnerOfficesStatus,
        ownerShipsStatus,
        mainUsagesStatus,
        selectedMainUsage,
        selectedOwnerShip,
        selectedSubUsage,
        ownershipText,
        ownershipDate,
        subUsagesStatus,
        licenes,
        licenseStatus,
        selectedLicense,
        detailsStatus,
        attachments,
        applyRequest,
        documentTypeSelection,
        contactMobileNumber,
        benificiaryTypeSelection
      ];
}

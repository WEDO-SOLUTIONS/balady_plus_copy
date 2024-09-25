import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';
import 'package:balady_plus/app/features/create_compliance/create_compliance_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_response.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:collection/collection.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/models/attachment_model.dart';
import '../../../_shared_feature_/data/entities/validators/phone_number_validation.dart';
import '../../data/models/apply_create_compliance_request_model.dart';
import '../../domain/entities/compliance_appointment_response.dart';
import '../../domain/entities/compliance_deed_info.dart';
import '../../domain/entities/compliance_engoffice_details.dart';
import '../../domain/entities/compliance_gis_resopnse.dart';
import '../../domain/entities/complinace_engoffice_response.dart';
import '../../domain/entities/complinace_licenses_response.dart';
import '../../domain/entities/land_subsidy_contract.dart';
import '../../domain/entities/ownership_doc_type_response.dart';
import '../../domain/entities/send_otp_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class ComplianceState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final BlocRequestStatus mainUsagesStatus;
  final BlocRequestStatus subUsagesStatus;
  final BlocRequestStatus licenseStatus;
  final BlocRequestStatus detailsStatus;

  final BlocRequestStatus ownerShipsStatus;
  final BlocRequestStatus reciptTypesStatus;

  final BlocRequestStatus enginnerOfficesStatus;

  final int currentStep;
  final int? benificiaryTypeSelection;
  final int? documentTypeSelection;
  final int? requestId;
  final ComplianceRequestDetails? requestDetails;
  final ComplinaceLookUpResponse? mainUsages;
  final ComplinaceLookUpResponse? subUsages;
  final ComplinaceLookUpResponse? ownerShipsTypes;
  final ComplinaceLookUpResponse? reciptLists;

  final ComplinaecEngOfficeReponse? engOffices;
  final ComplinaecEngOfficeItem? selectedEngOffice;
  final ComplinaceLookUpItem? selectedMainUsage;
  final ComplinaceLookUpItem? selectedSubUsage;
  final ComplinaceLookUpItem? selectedOwnerShip;
  final ComplinaceLookUpItem? selectedReciptType;

  final String? ownershipText;
  final String? ownershipDate;
  final DateForm? form;
  final ComplianceEngOfficeDetails? engOfficeDetails;
  final ComplinaecLicensesReponse? licenes;
  final ComplianceLisenseItem? selectedLicense;
  final ComplainceGISResponse? gisResponse;
  final GISParams? gisParams;
  final List<AttachmentData>? attachments;
  final List<AttachmentData>? viewAttachments;

  final ApplyCreateComplianceRequest? applyRequest;
  final String? contactMobileNumber;
  final bool? agreement;
  final bool? emtethalAgreement;
  final bool? ownerShipAgreement;
  final bool? contactMobileVerified;
  final SendOtpResponse? sendOtpResponse;
  final bool? isDraft;
  final bool? isDeedPaper;
  final ComplianceDeedInfo? deedInfo;
  final LandSubsidyContract? landSubsidyContract;
  final bool? showEksanId;
  final String? applicantNotes;
  final bool? showDetails;
  final DayItem? visitDate;
  final String? visitTimeFrom;
  final String? visitTimeTo;
  final ComplainceAppointmentResponse? complainceAppointmentResponse;
  final BlocStatus appointmentsStatus;
  final String responseCode;

  PhoneNumberValidation get phoneValidator => contactMobileNumber == null
      ? PhoneNumberValidation.pure()
      : PhoneNumberValidation.dirty(value: contactMobileNumber);

  String? get phoneErrorText => phoneValidator.error?.message != null
      ? (phoneValidator.error?.message ?? "").tr()
      : null;

  ComplianceState(
      {required this.currentStep,
      this.responseCode = "",
      this.status = BlocStatus.initial,
      this.appointmentsStatus = BlocStatus.initial,
      this.mainUsagesStatus = BlocRequestStatus.initial,
      this.enginnerOfficesStatus = BlocRequestStatus.initial,
      this.subUsagesStatus = BlocRequestStatus.initial,
      this.ownerShipsStatus = BlocRequestStatus.initial,
      this.licenseStatus = BlocRequestStatus.initial,
      this.reciptTypesStatus = BlocRequestStatus.initial,
      this.licenes,
      this.agreement,
      this.contactMobileNumber,
      this.applyRequest,
      this.form,
      this.isDraft,
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
      this.viewAttachments,
      this.engOffices,
      this.selectedEngOffice,
      this.engOfficeDetails,
      this.emtethalAgreement,
      this.ownerShipAgreement,
      this.contactMobileVerified,
      this.sendOtpResponse,
      this.isDeedPaper,
      this.selectedReciptType,
      this.reciptLists,
      this.deedInfo,
      this.landSubsidyContract,
      this.showEksanId,
      this.applicantNotes,
      this.showDetails,
      this.visitDate,
      this.visitTimeFrom,
      this.visitTimeTo,
      this.complainceAppointmentResponse});

  ComplianceState copyWith({
    final BlocStatus? status,
    final BlocStatus? appointmentsStatus,
    final int? currentStep,
    final String? responseCode,
    final int? benificiaryTypeSelection,
    final int? documentTypeSelection,
    final int? requestId,
    final bool? agreement,
    final ComplianceRequestDetails? requestDetails,
    final ComplinaceLookUpResponse? mainUsages,
    final ComplinaceLookUpResponse? subUsages,
    final ComplinaceLookUpResponse? ownerShipsTypes,
    final BlocRequestStatus? mainUsagesStatus,
    final BlocRequestStatus? ownerShipsStatus,
    final BlocRequestStatus? enginnerOfficesStatus,
    final BlocRequestStatus? subUsagesStatus,
    final BlocRequestStatus? licenseStatus,
    final BlocRequestStatus? reciptTypesStatus,
    final String? errorMessage,
    final ComplinaceLookUpItem? selectedMainUsage,
    final Nullable<ComplinaceLookUpItem?>? selectedSubUsage,
    final ComplinaecEngOfficeReponse? engOffices,
    final Nullable<ComplinaceLookUpItem?>? selectedOwnerShip,
    final Nullable<String?>? ownershipText,
    final Nullable<String?>? ownershipDate,
    final DateForm? form,
    final ComplinaecLicensesReponse? licenes,
    final Nullable<ComplianceLisenseItem?>? selectedLicense,
    final BlocRequestStatus? detailsStatus,
    final ComplainceGISResponse? gisResponse,
    final GISParams? gisParams,
    final List<AttachmentData>? attachments,
    final List<AttachmentData>? viewAttachments,
    final ApplyCreateComplianceRequest? applyRequest,
    final String? contactMobileNumber,
    final Nullable<ComplinaecEngOfficeItem?>? selectedEngOffice,
    final Nullable<ComplianceEngOfficeDetails?>? engOfficeDetails,
    final bool? emtethalAgreement,
    final bool? ownerShipAgreement,
    final Nullable<bool?>? contactMobileVerified,
    final Nullable<SendOtpResponse?>? sendOtpResponse,
    final bool? isDraft,
    final Nullable<bool?>? isDeedPaper,
    final Nullable<ComplinaceLookUpItem?>? selectedReciptType,
    final ComplinaceLookUpResponse? reciptLists,
    final Nullable<ComplianceDeedInfo?>? deedInfo,
    final Nullable<LandSubsidyContract?>? landSubsidyContract,
    final bool? showEksanId,
    final String? applicantNotes,
    final bool? showDetails,
    final DayItem? visitDate,
    final String? visitTimeFrom,
    final String? visitTimeTo,
    final ComplainceAppointmentResponse? complainceAppointmentResponse,
    final bool deleteGisData = false,
  }) {
    return ComplianceState(
        status: status ?? this.status,
        responseCode: responseCode ?? "",
        appointmentsStatus: appointmentsStatus ?? this.appointmentsStatus,
        contactMobileNumber: contactMobileNumber ?? this.contactMobileNumber,
        visitDate: visitDate ?? this.visitDate,
        visitTimeFrom: visitTimeFrom ?? this.visitTimeFrom,
        visitTimeTo: visitTimeTo ?? this.visitTimeTo,
        currentStep: currentStep ?? this.currentStep,
        agreement: agreement ?? this.agreement,
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
        selectedSubUsage: selectedSubUsage == null
            ? this.selectedSubUsage
            : selectedSubUsage.value,
        ownershipText:
            ownershipText == null ? this.ownershipText : ownershipText.value,
        ownershipDate:
            ownershipDate == null ? this.ownershipDate : ownershipDate.value,
        form: form ?? this.form,
        subUsagesStatus: subUsagesStatus ?? this.subUsagesStatus,
        licenes: licenes ?? this.licenes,
        selectedLicense: selectedLicense == null
            ? this.selectedLicense
            : selectedLicense.value,
        detailsStatus: detailsStatus ?? this.detailsStatus,
        gisResponse: deleteGisData ? null : (gisResponse ?? this.gisResponse),
        gisParams: gisParams ?? this.gisParams,
        attachments: attachments ?? this.attachments,
        viewAttachments: viewAttachments ?? this.viewAttachments,
        applyRequest: applyRequest ?? this.applyRequest,
        engOffices: engOffices ?? this.engOffices,
        selectedEngOffice: selectedEngOffice == null
            ? this.selectedEngOffice
            : selectedEngOffice.value,
        engOfficeDetails: engOfficeDetails == null
            ? this.engOfficeDetails
            : engOfficeDetails.value,
        emtethalAgreement: emtethalAgreement ?? this.emtethalAgreement,
        ownerShipAgreement: ownerShipAgreement ?? this.ownerShipAgreement,
        contactMobileVerified: contactMobileVerified == null
            ? this.contactMobileVerified
            : contactMobileVerified.value,
        sendOtpResponse: sendOtpResponse == null
            ? this.sendOtpResponse
            : sendOtpResponse.value,
        isDraft: isDraft ?? this.isDraft,
        isDeedPaper: isDeedPaper == null ? this.isDeedPaper : isDeedPaper.value,
        selectedReciptType: selectedReciptType == null
            ? this.selectedReciptType
            : selectedReciptType.value,
        reciptTypesStatus: reciptTypesStatus ?? this.reciptTypesStatus,
        reciptLists: reciptLists ?? this.reciptLists,
        deedInfo: deedInfo == null ? this.deedInfo : deedInfo.value,
        landSubsidyContract: landSubsidyContract == null
            ? this.landSubsidyContract
            : landSubsidyContract.value,
        applicantNotes: applicantNotes ?? this.applicantNotes,
        showEksanId: showEksanId ?? this.showEksanId,
        showDetails: showDetails ?? this.showDetails,
        complainceAppointmentResponse: complainceAppointmentResponse ??
            this.complainceAppointmentResponse);
  }

  bool isNextButtonEnabled() {
    if (currentStep == 0) {
      bool isValid = true;

      if (benificiaryTypeSelection == null) isValid = false;
      return isValid;
    } else if (currentStep == 1) {
      bool form = Formz.validate([phoneValidator]);
      //    if (form)
      //      return true;
      //    else
      //    return false;
      return true;
    } else if (currentStep == 2) {
      if (documentTypeSelection == null) return false;

      if (documentTypeSelection == 1) {
        if (selectedLicense == null) return false;
      }

      if (documentTypeSelection == 2) {
        if (selectedOwnerShip == null ||
            (ownershipText?.isEmpty ?? true) ||
            ownerShipAgreement != true) {
          return false;
        }

        if (selectedOwnerShip?.id == 112) {
          if (isDeedPaper == true) {
            if (ownershipDate == null) return false;
          } else {
            if (deedInfo == null) return false;
          }
        }

        if (selectedOwnerShip?.id == 340) {
          if (selectedReciptType?.id == null || ownershipDate == null) {
            return false;
          }
        }

        if (selectedOwnerShip?.id == 146 && showEksanId != false) {
          if (landSubsidyContract?.contractNumber == null) {
            return false;
          }
        }
      }
    } else if (currentStep == 3) {
      if (selectedMainUsage == null ||
          selectedSubUsage == null ||
          (gisResponse == null && documentTypeSelection == 2)) return false;
    } else if (currentStep == 4 && benificiaryTypeSelection == 1) {
      /* bool valid = requestDetails?.emtithalItems?.firstWhereOrNull(
              (element) => element.submitterAnswer == null) ==
          null;
      return valid;*/

      return true;
    } else if (currentStep == 4 && benificiaryTypeSelection == 2) {
      bool valid = engOfficeDetails != null;
      return valid;
    } else if (currentStep == 5) {
      bool isValid = true;
      if (attachments != null && attachments!.isNotEmpty) {
        attachments!.forEach((element) {
          if (element.isRequired && element.isUploaded != true) isValid = false;
        });
      }
      return isValid;
    } else if ((currentStep == 6)) {
      if (requestDetails?.isRequestReturnedFromMunicipality == true &&
          (applicantNotes?.isEmpty ?? true)) return false;
    } else if ((currentStep == 7) && !showNewAppointments) {
      return agreement ?? false;
    } else if ((currentStep == 8 && showNewAppointments)) {
      return agreement ?? false;
    }
    return true;
  }

  ApplyCreateComplianceRequest generateRequest() {
    String? ownershipDateValue =
        documentTypeSelection == 2 ? ownershipDate : null;

    String? ownershipTextValue =
        documentTypeSelection == 2 ? ownershipText : null;

    if (selectedOwnerShip?.id == 112 && isDeedPaper == false) {
      ownershipDateValue = deedInfo?.getDeedDate();
    }

    if (selectedOwnerShip?.id == 146 && showEksanId != false) {
      ownershipDateValue = landSubsidyContract?.getDate();
      ownershipTextValue = landSubsidyContract?.contractNumber;
    }

    return ApplyCreateComplianceRequest(
      certificateType:
          documentTypeSelection == 1 ? "LICENSE_NUMBER" : "OWNERSHIP_DOC",
      licenseNumber: documentTypeSelection == 1
          ? selectedLicense?.licenseId?.toInt()
          : null,
      agencyRequestKey:
          CommonProperties.getCurrentUserProfile()?.agencyRequestKey,
      contactMobile: contactMobileNumber,
      ownershipDocumentDate: ownershipDateValue,
      ownershipDocumentNo: ownershipTextValue,
      ownershipDocumentType:
          documentTypeSelection == 2 ? selectedOwnerShip?.id : null,
      submitterThrough:
          benificiaryTypeSelection == 1 ? "BENEFICARY" : "ENGINEERING_OFFICE",
      paper: selectedOwnerShip?.id == 112 ? isDeedPaper : null,
      receiptTypeId:
          selectedOwnerShip?.id == 340 ? selectedReciptType?.id : null,
    );
  }

  Future<DateTime?> getOwnerShipDate() async {
    if (ownershipDate != null) {
      List<String> date = ownershipDate!.split("/");
      int? year = int.tryParse(date[0]);
      int? month = int.tryParse(date[1]);
      int? day = int.tryParse(date[2]);
      if (year != null && month != null && day != null) {
        if (year >= 1356) {
          HijriCalendar calendar = HijriCalendar();

          calendar.hDay = day;
          calendar.hMonth = month;
          calendar.hYear = year;
          return calendar.hijriToGregorian(year, month, day);
        } else {
          String d =
              "${day.toString().padLeft(2, "0")}/${month.toString().padLeft(2, "0")}/$year";

          String hijri =
              await BaladyServices(webService: sl()).getGorgianDate(d) ?? "";
          List<String> date = hijri!.split("/");
          int? year1 = int.tryParse(date[0]);
          int? month1 = int.tryParse(date[1]);
          int? day1 = int.tryParse(date[2]);
          if (year1 != null && month1 != null && day1 != null) {
            HijriCalendar calendar = HijriCalendar();

            calendar.hDay = day1;
            calendar.hMonth = month1;
            calendar.hYear = year1;
            return calendar.hijriToGregorian(year1, month1, day1);
          }
        }
        return null;
      }
    }
  }

  DateTime? getOwnerShipDateTime() {
    try {
      if (ownershipDate != null) {
        List<String> date = ownershipDate!.split("/");
        int? year = int.tryParse(date[0]);
        int? month = int.tryParse(date[1]);
        int? day = int.tryParse(date[2]);
        if (year != null && month != null && day != null) {
          HijriCalendar calendar = HijriCalendar();

          calendar.hDay = day;
          calendar.hMonth = month;
          calendar.hYear = year;
          return calendar.hijriToGregorian(year, month, day);

          return null;
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  Future<String?> getOwnerShipDateStr() async {
    if ((ownershipDate != null && form == null) || form == DateForm.hijri) {
      return ownershipDate!;
    } else {
      String date =
          await DateTime.tryParse(ownershipDate ?? "")!.toHijriFormattedDate1();

      return date;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        status,
        gisResponse,
        appointmentsStatus,
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
        viewAttachments,
        applyRequest,
        documentTypeSelection,
        contactMobileNumber,
        benificiaryTypeSelection,
        agreement,
        selectedEngOffice,
        engOffices,
        engOfficeDetails,
        ownerShipAgreement,
        emtethalAgreement,
        contactMobileVerified,
        form,
        isDraft,
        isDeedPaper,
        selectedReciptType,
        reciptTypesStatus,
        reciptLists,
        showEksanId,
        applicantNotes,
        visitTimeTo,
        visitTimeFrom,
        visitDate
      ];

  bool get showNewAppointments =>
      ((requestDetails?.showMomtathelVisitSection ?? false) &&
          (requestDetails?.isReadOnly == false));

  bool get editOnlyAppointment =>
      ((requestDetails?.showMomtathelVisitSection ?? false) &&
          (requestDetails?.isReadOnly == true));
}

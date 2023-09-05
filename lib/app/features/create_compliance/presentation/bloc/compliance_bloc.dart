import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/verify_otp_request.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/models/attachment_model.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/use_cases/submit_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:collection/collection.dart';

import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../data/models/apply_create_compliance_request_model.dart';
import '../../data/models/compliance_certificate_items_request.dart';
import '../../data/models/save_contract_info_request.dart';
import '../../data/models/save_location_compliance_request.dart';
import '../../domain/entities/comliance_request_details.dart';
import '../../domain/entities/compliance_attachment_request.dart';
import '../../domain/entities/compliance_gis_resopnse.dart';
import '../../domain/entities/complinace_licenses_response.dart';
import '../../domain/entities/ownership_doc_type_response.dart';
import '../../domain/use_cases/apply_compliance.dart';
import '../../domain/use_cases/get_compliance_details.dart';
import '../../domain/use_cases/get_compliance_engoffices.dart';
import '../../domain/use_cases/get_compliance_engoffices_details.dart';
import '../../domain/use_cases/get_compliance_gis.dart';
import '../../domain/use_cases/get_compliance_license.dart';
import '../../domain/use_cases/get_compliance_main_usage.dart';
import '../../domain/use_cases/get_compliance_sub_usage.dart';
import '../../domain/use_cases/get_ownership_types.dart';
import '../../domain/use_cases/save_attachment.dart';
import '../../domain/use_cases/save_compliance_certificate_items.dart';
import '../../domain/use_cases/save_compliance_contract.dart';
import '../../domain/use_cases/save_compliance_location.dart';
import '../../domain/use_cases/send_otp.dart';
import '../../domain/use_cases/submit_compliance_request.dart';
import '../../domain/use_cases/verify_otp.dart';
import '../pages/otp_page/compliance_otp_screen.dart';
import '../widgets/compliance_submission/create_compliance_summery.dart';
import '../widgets/compliance_submission/engoffice_submit_step_compliance.dart';
import '../widgets/compliance_submission/fifth_submit_step.dart';
import '../widgets/compliance_submission/first_submit_step_compliance.dart';
import '../widgets/compliance_submission/fourth_step_compliance.dart';
import '../widgets/compliance_submission/second_submit_step_compliance.dart';
import '../widgets/compliance_submission/third_submit_step_compliance.dart';
import '../widgets/compliance_submission/usage_submit_step_compliance.dart';

class ComplianceBloc extends Bloc<ComplianceEvent, ComplianceState> {
  PageController pageController = PageController(initialPage: 0);

  List pagesListHimSelf = [
    FirstComplianceSubmissionWidget(),
    SecondSubmissonCompliance(),
    ThirdSubmissionCompliance(),
    UsageSubmissionCompliance(),
    FourthStepCompliance(),
    FifthComplianceSubmitStep(),
    CreateComplianceSummurySection()
  ];

  List pagesListEngOffice = [
    FirstComplianceSubmissionWidget(),
    SecondSubmissonCompliance(),
    ThirdSubmissionCompliance(),
    UsageSubmissionCompliance(),
    EngOfficeSubmissionCompliance(),
    FifthComplianceSubmitStep(),
    CreateComplianceSummurySection()
  ];

  final ApplyCompliance _applyCompliance;
  final GetComplianceByRequestId _getComplianceByRequestId;
  final GetComplianceEngOfficesDetails _getComplianceEngOfficesDetails;
  final GetComplianceEngOffices _getComplianceEngOffices;
  final GetComplianceLicenses _getComplianceLicenses;
  final GetComplianceMainUsages _getComplianceMainUsages;
  final GetComplianceSubUsages _getComplianceSubUsages;
  final GetOwnerShipTypes _getOwnerShipTypes;
  final SaveComplianceCertificateItems _saveComplianceCertificateItems;
  final SaveContractCompliance _saveContractCompliance;
  final SubmitComplianceRequest _submitComplianceRequest;
  final SaveLocationCompliance _saveLocationCompliance;
  final GetComplianceGIS _getComplianceGIS;
  final SaveAttachment _saveAttachment;
  final SendOTP _sendOTP;
  final VerifyOTP _verifyOTP;

  ComplianceBloc()
      : _applyCompliance = ApplyCompliance(repository: sl()),
        _getComplianceByRequestId = GetComplianceByRequestId(repository: sl()),
        _getComplianceEngOfficesDetails =
            GetComplianceEngOfficesDetails(repository: sl()),
        _getComplianceEngOffices = GetComplianceEngOffices(repository: sl()),
        _getComplianceLicenses = GetComplianceLicenses(repository: sl()),
        _getComplianceMainUsages = GetComplianceMainUsages(repository: sl()),
        _getComplianceSubUsages = GetComplianceSubUsages(repository: sl()),
        _getOwnerShipTypes = GetOwnerShipTypes(repository: sl()),
        _saveComplianceCertificateItems =
            SaveComplianceCertificateItems(repository: sl()),
        _saveContractCompliance = SaveContractCompliance(repository: sl()),
        _submitComplianceRequest = SubmitComplianceRequest(repository: sl()),
        _saveLocationCompliance = SaveLocationCompliance(repository: sl()),
        _getComplianceGIS = GetComplianceGIS(repository: sl()),
        _saveAttachment = SaveAttachment(repository: sl()),
        _sendOTP = SendOTP(repository: sl()),
        _verifyOTP = VerifyOTP(repository: sl()),
        super(ComplianceState(
          status: BlocStatus.initial,
          currentStep: 0,
        )) {
    on<ComplianceEvent>((event, emit) {
      emit(state);
    });
    add(const ComplianceEvent());
    emit(state.copyWith(
        contactMobileNumber: CommonProperties.userInfo!.getPhone()));
    on<ChangePageEvent>(_pageChangeHandler);
    // on<RadioSelectEvent>(_radioChangeHandler);
    on<GetMainUsagesEvent>(_getMainUsagesHandler);
    on<GetSubUsagesEvent>(_getSubUsagesHandler);
    on<GetOwnerShipTypesEvent>(_getOwnerShipTypeHandeler);
    on<GetEngOfficesListEvent>(_getEngOfficesHandler);
    on<SaveContractEvent>(_saveContractData);
    on<UpdateFieldsEvent>(_updateFormFields);
    on<ApplyEvent>(_applyEventHandler);
    on<GetLicensesEvent>(_getLicensesHandler);
    on<GetRequestDetails>(_getRequestDetails);
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<ChangeImtethalItemEvent>(_changeImtethalItems);
    on<SaveImtethalItemsEvent>(_saveImtethalPoints);
    on<SaveFileEvent>(_saveFileHandler);
    on<SubmitComplianceEvent>(_submitRequest);
    on<GetComplianceGISEvent>(_getGISInfo);
    on<SaveLocationData>(_saveLocationData);
    on<DeleteFileEvent>(_deleteFile);
    on<ChangeAgreementEvent>(_changeAgreementHandler);
    on<GetEngOfficeDetailsEvent>(_getEngOfficeDetailsHandler);
    on<SendOTPEvent>(_sendOTPHandler);
    on<VerifyOTPEvent>(_verifyOTPHandler);
  }
  Future<void> _pageChangeHandler(ChangePageEvent e, Emitter emitter) async {
    emitter(state.copyWith(currentStep: e.index, errorMessage: ""));
    pageController.jumpToPage((e.index).toInt());
  }

  Future<void> _updateFormFields(UpdateFieldsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        form: e.form,
        sendOtpResponse: e.mobileNumber != null ? Nullable(null) : null,
        contactMobileVerified: e.mobileNumber != null ? Nullable(null) : null,
        benificiaryTypeSelection: e.benificiaryTypeSelection,
        documentTypeSelection: e.documentTypeSelection,
        selectedOwnerShip: Nullable(e.selectedOwnerShip == null
            ? state.selectedOwnerShip
            : e.selectedOwnerShip),
        selectedMainUsage: e.selectedMainUsage,
        contactMobileNumber: e.mobileNumber,
        selectedSubUsage: e.selectedSubUsage,
        selectedLicense: Nullable(e.selectedLicense == null
            ? state.selectedLicense
            : e.selectedLicense),
        ownershipDate: Nullable(
            e.ownershipDate == null ? state.ownershipDate : e.ownershipDate),
        emtethalAgreement: e.emtethalAgreeemnt,
        ownerShipAgreement: e.ownershipAgreement,
        ownershipText: Nullable(
            e.ownershipText == null ? state.ownershipText : e.ownershipText)));

    if (e.documentTypeSelection != null)
      emitter(state.copyWith(
          errorMessage: "",
          selectedOwnerShip: Nullable(null),
          selectedLicense: Nullable(null),
          ownershipDate: Nullable(null),
          ownershipText: Nullable(null)));
  }

  /* Future<void> _radioChangeHandler(RadioSelectEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        documentTypeSelection: e.index,
        selectedOwnerShip: Nullable(null),
        selectedLicense: Nullable(null),
        ownershipDate: Nullable(null),
        ownershipText: Nullable(null)));
  }*/

  Future<void> _getGISInfo(GetComplianceGISEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failOrSuccess = await _getComplianceGIS(e.params);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(gisResponse: r, status: BlocStatus.success));
    });
  }

  Future<void> _saveContractData(SaveContractEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failOrSuccess = await _saveContractCompliance(SaveContractInfoRequest(
        designerEngOfficeId: state.selectedEngOffice?.engOfficeNo,
        requestId: state.requestId));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) async {
      int nextPage = state.currentStep + 1;
      emitter(state.copyWith(status: BlocStatus.performing));
      emitter(state.copyWith(
          status: BlocStatus.success, currentStep: nextPage, errorMessage: ""));
      await pageController.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    });
  }

  Future<void> _saveLocationData(SaveLocationData e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    SaveLocationComplianceRequest? request;

    if (state.documentTypeSelection == 1) {
      request = SaveLocationComplianceRequest(
          mainUsageCode: state.selectedMainUsage?.id,
          subUsageCode: state.selectedSubUsage?.id,
          requsestId: state.requestId);
    } else {
      request = SaveLocationComplianceRequest(
          mainUsageCode: state.selectedMainUsage?.id,
          subUsageCode: state.selectedSubUsage?.id,
          municipalityId: state.gisResponse?.amanaCode,
          subMunicipalityId: state.gisResponse?.municipalityCode,
          districtId: state.gisResponse?.districtCode,
          cityId: state.gisResponse?.cityCode,
          streetId: state.gisResponse?.streetCode,
          streetName: state.gisResponse?.streetName,
          mapNumber: state.gisResponse?.planNo,
          mapName: state.gisResponse?.planName,
          x: state.gisParams?.x.toString(),
          y: state.gisParams?.y.toString(),
          landNumber: state.gisResponse?.parcelNo,
          landArea: state.gisResponse?.area,
          isLicense: state.documentTypeSelection == 1,
          guid: state.gisResponse?.guid,
          requsestId: state.requestId);
    }
    final failOrSuccess = await _saveLocationCompliance(request);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) async {
      int nextPage = state.currentStep + 1;
      emitter(state.copyWith(status: BlocStatus.performing));
      emitter(state.copyWith(
          status: BlocStatus.success, currentStep: nextPage, errorMessage: ""));
      await pageController.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    });
  }

  Future<void> _getMainUsagesHandler(
      GetMainUsagesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      mainUsagesStatus: BlocRequestStatus.submissionGetLoading,
    ));

    final failOrSuccess = await _getComplianceMainUsages(NoParams());

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        mainUsagesStatus: BlocRequestStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          mainUsages: r,
          mainUsagesStatus: BlocRequestStatus.submissionGetSuccess));
    });
  }

  Future<void> _applyEventHandler(ApplyEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    print("FFF");
    ApplyCreateComplianceRequest request = state.generateRequest();
    print("GG");
    final failOrSuccess = await _applyCompliance(request);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          requestId: r.result,
          status: BlocStatus.success,
          errorMessage: "",
          applyRequest: request));
      add(GetRequestDetails());
    });
  }

  Future<void> _getLicensesHandler(GetLicensesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      licenseStatus: BlocRequestStatus.submissionGetLoading,
    ));

    final failOrSuccess = await _getComplianceLicenses(NoParams());

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        licenseStatus: BlocRequestStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          licenes: r, licenseStatus: BlocRequestStatus.submissionGetSuccess));
    });
  }

  Future<void> _getRequestDetails(
      GetRequestDetails event, Emitter emitter) async {
    emitter(state.copyWith(
      detailsStatus: BlocRequestStatus.submissionGetLoading,
    ));

    final failOrSuccess = await _getComplianceByRequestId(
        event.requestId ?? state.requestId.toString());

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        detailsStatus: BlocRequestStatus.failure,
      ));
    }, (r) async {
      List<AttachmentData> attachmentData = (r.beneficaryAttachments ?? [])
          .map((e) => AttachmentData(
              id: e.id.toString(),
              memo: e.name ?? "",
              title: "${e.name} ${e.allowedFilesExtension}",
              isRequired: e.isMandatory ?? false,
              isUploaded: false))
          .toList();

      ComplinaceLookUpItem? selectedMainUsage = state.selectedMainUsage;
      ComplinaceLookUpItem? selectedSubUsage = state.selectedSubUsage;

      if (r.mainUsageCode != null && r.mainUsageName != null) {
        selectedMainUsage =
            ComplinaceLookUpItem(id: r.mainUsageCode, name: r.mainUsageName);
      }
      if (r.subUsageCode != null && r.subUsageName != null) {
        selectedSubUsage =
            ComplinaceLookUpItem(id: r.subUsageCode, name: r.subUsageName);
      }

      emitter(state.copyWith(
          requestDetails: r,
          errorMessage: "",
          selectedMainUsage: selectedMainUsage,
          selectedSubUsage: selectedSubUsage,
          detailsStatus: BlocRequestStatus.submissionGetSuccess,
          attachments: attachmentData));

      if (event.requestId == null) {
        int nextPage = state.currentStep + 1;
        emitter(state.copyWith(status: BlocStatus.performing));
        emitter(state.copyWith(
            status: BlocStatus.success,
            currentStep: nextPage,
            errorMessage: ""));
        await pageController.animateToPage(nextPage,
            duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      } else {
        setUpDraft(r);
      }
    });

    // await _(ComplianceCertificateItemsRequest(requestId: state.requestId, ));
  }

  void setUpDraft(ComplianceRequestDetails? r) {
    List<AttachmentData> attachmentData = (r?.beneficaryAttachments ?? [])
        .map((e) => AttachmentData(
            id: e.id.toString(),
            memo: e.name ?? "",
            fileName: e.fileName,
            filePath: e.attachUrl,
            title: "${e.name} ${e.allowedFilesExtension}",
            isRequired: e.isMandatory ?? false,
            isUploaded: e.attached ?? false))
        .toList();

    ComplinaceLookUpItem? selectedMainUsage = state.selectedMainUsage;
    ComplinaceLookUpItem? selectedSubUsage = state.selectedSubUsage;
    ComplinaceLookUpItem? selectedOwnerShip = state.selectedOwnerShip;

    int? submitterThrough = state.benificiaryTypeSelection;
    int? certificateBaseType = state.documentTypeSelection;
    int? requestId = state.requestId;

    if (r?.mainUsageCode != null && r?.mainUsageName != null) {
      selectedMainUsage =
          ComplinaceLookUpItem(id: r?.mainUsageCode, name: r?.mainUsageName);
    }
    if (r?.subUsageCode != null && r?.subUsageName != null) {
      selectedSubUsage =
          ComplinaceLookUpItem(id: r?.subUsageCode, name: r?.subUsageName);
    }

    if (r?.subUsageCode != null && r?.subUsageName != null) {
      selectedOwnerShip = ComplinaceLookUpItem(
          id: r?.ownershipDocInfoDto?.ownershipDocumentType,
          name: r?.ownershipDocInfoDto?.ownerShipDocTypeName);
    }

    if (r?.submitterThrough == "BENEFICARY") {
      submitterThrough = 1;
    } else {
      submitterThrough = 2;
    }

    if (r?.certificateBaseType == "OWNERSHIP_DOC") {
      certificateBaseType = 2;
    } else {
      certificateBaseType = 1;
    }
    requestId = r?.requestId;

    emit(state.copyWith(
        requestDetails: r,
        isDraft: true,
        requestId: requestId,
        contactMobileVerified: Nullable(true),
        selectedOwnerShip: Nullable(selectedOwnerShip),
        ownershipText:
            Nullable(r?.ownershipDocInfoDto?.ownershipDocumentNo ?? ""),
        ownershipDate:
            Nullable(r?.ownershipDocInfoDto?.ownershipDocumentDate ?? ""),
        gisParams: (r?.locationResponseInfoDto?.x != null &&
                r?.locationResponseInfoDto?.y != null)
            ? GISParams(
                x: double.tryParse(r!.locationResponseInfoDto!.x!)!,
                y: double.tryParse(r!.locationResponseInfoDto!.y!)!)
            : null,
        gisResponse: r?.locationResponseInfoDto?.municipalityId != null
            ? ComplainceGISResponse(
                amanaCode: r?.locationResponseInfoDto?.municipalityId,
                amanaName: r?.locationResponseInfoDto?.municipalityName,
                municipalityCode: r?.locationResponseInfoDto?.subMunicipalityId,
                municipalityName:
                    r?.locationResponseInfoDto?.subMunicipalityName,
                districtCode: r?.locationResponseInfoDto?.districtId != null
                    ? r?.locationResponseInfoDto?.districtId.toString()
                    : null,
                districtName: r?.locationResponseInfoDto?.districtName,
                streetCode: r?.locationResponseInfoDto?.streetId != null
                    ? r?.locationResponseInfoDto?.streetId.toString()
                    : null,
                city: r?.locationResponseInfoDto?.cityName,
                cityCode: r?.locationResponseInfoDto?.cityId != null
                    ? r?.locationResponseInfoDto?.cityId.toString()
                    : null,
                planName: r?.locationResponseInfoDto?.mapName,
                planNo: r?.locationResponseInfoDto?.mapNumber,
                parcelNo: r?.locationResponseInfoDto?.landNumber,
                area: r?.locationResponseInfoDto?.landArea,
                guid: r?.locationResponseInfoDto?.guid,
              )
            : null,
        ownerShipAgreement: true,
        benificiaryTypeSelection: submitterThrough,
        documentTypeSelection: certificateBaseType,
        errorMessage: "",
        /*  emtethalAgreement: true,
        ownerShipAgreement: r?.emtithalItems?.firstWhereOrNull(
                    (element) => element.submitterAnswer == null) !=
                null
            ? false
            : true,*/
        selectedLicense: r?.licenseNumber != null
            ? Nullable(ComplianceLisenseItem(
                licenseId: double.tryParse(r?.licenseNumber),
                expirationDate: r?.licenseExpiryDate,
                issuingDate: r?.licenseIssueDate,
                statusName: r?.licenseStatusName,
                statusId: r?.licenseStatusId))
            : null,
        selectedMainUsage: selectedMainUsage,
        selectedSubUsage: selectedSubUsage,
        detailsStatus: BlocRequestStatus.submissionGetSuccess,
        attachments: attachmentData));
  }

  Future<void> _getEngOfficesHandler(
      GetEngOfficesListEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        enginnerOfficesStatus: BlocRequestStatus.submissionGetLoading,
        selectedEngOffice: null,
        engOfficeDetails: null));

    final failOrSuccess = await _getComplianceEngOffices(NoParams());

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        enginnerOfficesStatus: BlocRequestStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          engOffices: r,
          enginnerOfficesStatus: BlocRequestStatus.submissionGetSuccess));
    });
  }

  Future<void> _getEngOfficeDetailsHandler(
      GetEngOfficeDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        status: BlocStatus.loading,
        selectedEngOffice: Nullable(null),
        engOfficeDetails: Nullable(null)));

    final failOrSuccess =
        await _getComplianceEngOfficesDetails(e.item.engOfficeNo ?? "");

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          engOfficeDetails: Nullable(r),
          selectedEngOffice: Nullable(e.item),
          status: BlocStatus.success));
    });
  }

  Future<void> _sendOTPHandler(SendOTPEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failOrSuccess = await _sendOTP(state.contactMobileNumber ?? "");

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success, sendOtpResponse: Nullable(r)));
      if (e.showOTPPage == true)
        NavigationService.navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: this,
            child: ComplianceOtpScreen(),
          ),
        ));
    });
  }

  Future<void> _verifyOTPHandler(VerifyOTPEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failOrSuccess = await _verifyOTP(VerifyOTPRequest(
        mobileNumber: state.contactMobileNumber ?? "",
        token: e.otpValue,
        tokenId: state.sendOtpResponse?.tokenId ?? ""));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success, contactMobileVerified: Nullable(true)));
    });
  }

  Future<void> _getOwnerShipTypeHandeler(
      GetOwnerShipTypesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      ownerShipsStatus: BlocRequestStatus.submissionGetLoading,
    ));

    final failOrSuccess = await _getOwnerShipTypes(NoParams());

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        ownerShipsStatus: BlocRequestStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          ownerShipsTypes: r,
          ownerShipsStatus: BlocRequestStatus.submissionGetSuccess));
    });
  }

  Future<void> _getSubUsagesHandler(
      GetSubUsagesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        subUsagesStatus: BlocRequestStatus.submissionGetLoading,
        selectedMainUsage: e.item));

    final failOrSuccess = await _getComplianceSubUsages(
        (e.item?.id ?? state.selectedMainUsage?.id) ?? 0);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        subUsagesStatus: BlocRequestStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
        subUsages: r,
        subUsagesStatus: BlocRequestStatus.submissionGetSuccess,
      ));
    });
  }

  Future<void> _deleteFile(DeleteFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<AttachmentData> attachments = state.attachments ?? [];
    attachments[e.index].base64 = null;
    attachments[e.index].fileName = null;
    attachments[e.index].filePath = null;
    attachments[e.index].isUploaded = false;
    emitter(
        state.copyWith(status: BlocStatus.success, attachments: attachments));
  }

  Future<void> _saveFileHandler(SaveFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failOrSuccess = await _saveAttachment(ComplinaceAttachmentRequest(
        requestId: state.requestId!,
        attahment: state.attachments![e.index].copyWith(
            fileName: e.fileName, filePath: e.filePath, base64: e.base64)));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      List<AttachmentData> attachments = state.attachments ?? [];
      attachments[e.index].base64 = e.base64;
      attachments[e.index].fileName = e.fileName;
      attachments[e.index].filePath = e.filePath;
      attachments[e.index].isUploaded = true;
      emitter(
          state.copyWith(status: BlocStatus.success, attachments: attachments));
    });
  }

  void cancelIncident() {
    hideKeyboard(); //MM
    bool Function(Route<dynamic>) predicate =
        ModalRoute.withName(RouteName.bottomNavigation);
    NavigationService.navigatorKey.currentState!.popUntil((predicate));
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    // print("DataLog ${state}");
    if (isLastPage()) {
      print("HERE");
      add(SubmitComplianceEvent());
    } else if (state.currentStep == 0 && state.benificiaryTypeSelection == 2) {
      bool Function(Route<dynamic>) predicate =
          ModalRoute.withName(RouteName.bottomNavigation);
      NavigationService.navigatorKey.currentState!
          .pushNamedAndRemoveUntil(RouteName.etmamMainPage, predicate);
    } else if (state.currentStep == 1) {
      if (state.contactMobileVerified != true) {
        CommonFunctions.showError("compliance_check_mobile".tr());
      } else {
        if (state.status == BlocStatus.performing) return;
        int nextPage = state.currentStep + 1;
        emitter(state.copyWith(
          status: BlocStatus.performing,
        ));
        emitter(state.copyWith(
            status: BlocStatus.success,
            currentStep: nextPage,
            errorMessage: ""));
        await pageController.animateToPage(nextPage,
            duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      }
    } else if (state.currentStep == 2 && state.benificiaryTypeSelection == 1) {
      if (state.generateRequest() == state.applyRequest ||
          state.isDraft == true) {
        add(GetRequestDetails());
      } else {
        add(ApplyEvent());
      }
    } else if (state.currentStep == 3) {
      add(SaveLocationData());
    } else if (state.currentStep == 4 && state.benificiaryTypeSelection == 1) {
      bool valid = state.requestDetails?.emtithalItems?.firstWhereOrNull(
              (element) => element.submitterAnswer == null) ==
          null;
      if (valid)
        add(SaveImtethalItemsEvent());
      else {
        CommonFunctions.showError("الرجاء اختيار جميع بنود الإمتثال");
      }
    } else if (state.currentStep == 4 && state.benificiaryTypeSelection == 2) {
      add(SaveContractEvent());
    } else {
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentStep + 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      emitter(state.copyWith(
          status: BlocStatus.success, currentStep: nextPage, errorMessage: ""));
      await pageController.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    }
    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentStep == 0.0 ||
        (state.isDraft == true && state.currentStep == 2)) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentStep - 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      await pageController.animateToPage(prvoiusPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      emitter(state.copyWith(
          status: BlocStatus.success,
          currentStep: prvoiusPage,
          errorMessage: ""));
    }
    hideKeyboard();
  }

  Future<void> _changeImtethalItems(
      ChangeImtethalItemEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    ComplianceRequestDetails? r = state.requestDetails;

    r?.emtithalItems?[e.index] = e.item;

    emitter(state.copyWith(requestDetails: r, status: BlocStatus.success));
  }

  Future<void> _saveImtethalPoints(
      SaveImtethalItemsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failOrSuccess = await _saveComplianceCertificateItems(
        ComplianceCertificateItemsRequest(
            requestId: state.requestId,
            items: (state.requestDetails?.emtithalItems ?? [])
                .map((e) => ComplianceCertificateItem(
                    itemAnswer: e.submitterAnswer, itemId: e.itemId))
                .toList()));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
      ));

      int nextPage = state.currentStep + 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      emitter(state.copyWith(
          status: BlocStatus.success, currentStep: nextPage, errorMessage: ""));
      await pageController.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    });
  }

  Future<void> _submitRequest(SubmitComplianceEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    final failOrSuccess =
        await _submitComplianceRequest(state.requestId.toString());
    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
      ));
      bool Function(Route<dynamic>) predicate =
          ModalRoute.withName(RouteName.bottomNavigation);
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute, predicate,
          arguments: SuccessScreenArgs(
              thanksMessage: r,
              type: PAGE_TYPE.emtethal,
              idNumber: state.requestId.toString()));
    });
  }

  bool isLastPage() {
    return state.currentStep == (pages().length - 1);
  }

  List<dynamic> pages() => state.benificiaryTypeSelection == 1
      ? pagesListHimSelf
      : pagesListEngOffice;

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _changeAgreementHandler(
      ChangeAgreementEvent e, Emitter emitter) async {
    hideKeyboard();
    print(e.isagree);
    emitter(state.copyWith(agreement: e.isagree, errorMessage: ""));
  }
}

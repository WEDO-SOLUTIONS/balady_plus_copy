import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/verify_otp_request.dart';
import 'package:balady_plus/app/features/create_compliance/domain/use_cases/delete_compliance_request.dart';
import 'package:balady_plus/app/features/create_compliance/domain/use_cases/get_appointment.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/models/attachment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:collection/collection.dart';

import '../../../../../etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../data/models/apply_create_compliance_request_model.dart';
import '../../data/models/compliance_certificate_item_request.dart';
import '../../data/models/compliance_certificate_items_request.dart';
import '../../data/models/save_contract_info_request.dart';
import '../../data/models/save_location_compliance_request.dart';
import '../../domain/entities/comliance_request_details.dart';
import '../../domain/entities/compliance_attachment_request.dart';
import '../../domain/entities/compliance_deed_info_request.dart';
import '../../domain/entities/compliance_gis_resopnse.dart';
import '../../domain/entities/complinace_licenses_response.dart';
import '../../domain/entities/land_subsidy_contract_request.dart';
import '../../domain/entities/ownership_doc_type_response.dart';
import '../../domain/entities/submit_emtithal_request.dart';
import '../../domain/use_cases/apply_compliance.dart';
import '../../domain/use_cases/cancel_compliance_certificate.dart';
import '../../domain/use_cases/download_compliance_certificate.dart';
import '../../domain/use_cases/get_compliance_details.dart';
import '../../domain/use_cases/get_compliance_engoffices.dart';
import '../../domain/use_cases/get_compliance_engoffices_details.dart';
import '../../domain/use_cases/get_compliance_gis.dart';
import '../../domain/use_cases/get_compliance_license.dart';
import '../../domain/use_cases/get_compliance_main_usage.dart';
import '../../domain/use_cases/get_compliance_sub_usage.dart';
import '../../domain/use_cases/get_deed_info.dart';
import '../../domain/use_cases/get_entity_etmam_id.dart';
import '../../domain/use_cases/get_land_contract.dart';
import '../../domain/use_cases/get_ownership_types.dart';
import '../../domain/use_cases/get_recipt_types.dart';
import '../../domain/use_cases/save_attachment.dart';
import '../../domain/use_cases/save_compliance_certificate_item.dart';
import '../../domain/use_cases/save_compliance_certificate_items.dart';
import '../../domain/use_cases/save_compliance_contract.dart';
import '../../domain/use_cases/save_compliance_location.dart';
import '../../domain/use_cases/send_otp.dart';
import '../../domain/use_cases/submit_compliance_request.dart';
import '../../domain/use_cases/upload_clause_attachment.dart';
import '../../domain/use_cases/validate_compliance_certificate_items.dart';
import '../../domain/use_cases/verify_otp.dart';
import '../dialogs/exit_draft_dialog.dart';
import '../dialogs/save_draft_dialog.dart';
import '../widgets/compliance_submission/create_compliance_summery.dart';
import '../widgets/compliance_submission/engoffice_submit_step_compliance.dart';
import '../widgets/compliance_submission/fifth_submit_step.dart';
import '../widgets/compliance_submission/first_submit_step_compliance.dart';
import '../widgets/compliance_submission/fourth_step_compliance.dart';
import '../widgets/compliance_submission/second_submit_step_compliance.dart';
import '../widgets/compliance_submission/seventh_submit_step.dart';
import '../widgets/compliance_submission/sixth_submit_step.dart';
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
    SixthComplianceSubmitStep(),
    CreateComplianceSummurySection()
  ];

  List pagesListHimSelfWithAppointments = [
    FirstComplianceSubmissionWidget(),
    SecondSubmissonCompliance(),
    ThirdSubmissionCompliance(),
    UsageSubmissionCompliance(),
    FourthStepCompliance(),
    FifthComplianceSubmitStep(),
    SixthComplianceSubmitStep(),
    SeventhSubmitComplianceSubmitStep(),
    CreateComplianceSummurySection()
  ];

  List pageEditAppointments = [
    SeventhSubmitComplianceSubmitStep(),
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
  final SaveComplianceCertificateItem _saveComplianceCertificateItem;
  final SaveContractCompliance _saveContractCompliance;
  final SubmitComplianceRequest _submitComplianceRequest;
  final SaveLocationCompliance _saveLocationCompliance;
  final GetComplianceGIS _getComplianceGIS;
  final SaveAttachment _saveAttachment;
  final SendOTP _sendOTP;
  final VerifyOTP _verifyOTP;
  final DownloadComplianceCertificate _downloadCmplianceCertificate;
  final DeleteComplianceRequest _deleteComlianceRequest;
  final GetEtmamId _getEtmamId;
  final GetReciptTypes _getReciptTypes;
  final GetDeedInfo _getDeedInfo;
  final GetLandContract _getLandContract;
  final UploadClauseAttachment _uploadClauseAttachment;
  final ValidateComplianceCertificateItem _validateComplianceCertificateItem;
  final CancelComplianceCertificate _cancelComplianceCertificate;
  final GetComplianceAppointments _getAppointments;
  final bool? showDetails;

  ComplianceBloc({this.showDetails})
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
        _saveComplianceCertificateItem =
            SaveComplianceCertificateItem(repository: sl()),
        _saveContractCompliance = SaveContractCompliance(repository: sl()),
        _submitComplianceRequest = SubmitComplianceRequest(repository: sl()),
        _saveLocationCompliance = SaveLocationCompliance(repository: sl()),
        _getComplianceGIS = GetComplianceGIS(repository: sl()),
        _saveAttachment = SaveAttachment(repository: sl()),
        _sendOTP = SendOTP(repository: sl()),
        _verifyOTP = VerifyOTP(repository: sl()),
        _deleteComlianceRequest = DeleteComplianceRequest(repository: sl()),
        _downloadCmplianceCertificate =
            DownloadComplianceCertificate(repository: sl()),
        _getEtmamId = GetEtmamId(repository: sl()),
        _getDeedInfo = GetDeedInfo(repository: sl()),
        _getLandContract = GetLandContract(repository: sl()),
        _getReciptTypes = GetReciptTypes(repository: sl()),
        _uploadClauseAttachment = UploadClauseAttachment(repository: sl()),
        _validateComplianceCertificateItem =
            ValidateComplianceCertificateItem(repository: sl()),
        _getAppointments = GetComplianceAppointments(repository: sl()),
        _cancelComplianceCertificate =
            CancelComplianceCertificate(repository: sl()),
        super(ComplianceState(
            status: BlocStatus.initial,
            currentStep: 0,
            showDetails: showDetails)) {
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
    on<DownloadCertificateEvent>(_downloadCertificate);
    on<DeleteComplianceRequestEvent>(_deleteComplianceRequest);
    on<GetEtmamEntityIdEvent>(_getEtmamIdHandler);
    on<GetReciptTypesEvent>(_getReciptTypesHandler);

    on<GetComplianceDeedInfoEvent>(_getDeedInfoHandler);
    on<GetComplianceLandContractEvent>(_getLandContractHandler);
    on<SaveImtethalItemEvent>(_saveImtethalPoint);
    on<CancelComplianceCertificateEvent>(_cancelComplainceCertificate);
    on<ChangeApplicantNotesEvent>(_changeApplicantNotesHandler);
    on<GetAppointments>(_getAppintmentHandler);

    on<ChangeSelectedAppointmentDay>(_changeSelectedAppointmentDayHandler);
    on<ChangeSelectedAppointmentSlot>(_changeSelectedAppointmentSlotHandler);
  }

  Future<void> _pageChangeHandler(ChangePageEvent e, Emitter emitter) async {
    emitter(state.copyWith(currentStep: e.index, errorMessage: ""));
    pageController.jumpToPage((e.index).toInt());
    sendEventPage((e.index).toInt());
  }

  Future<void> _changeApplicantNotesHandler(
      ChangeApplicantNotesEvent e, Emitter emitter) async {
    emitter(state.copyWith(applicantNotes: e.text));
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
      selectedSubUsage: Nullable(e.selectedSubUsage == null
          ? state.selectedSubUsage
          : e.selectedSubUsage),
      selectedLicense: Nullable(e.selectedLicense == null
          ? state.selectedLicense
          : e.selectedLicense),
      ownershipDate: ((state.selectedOwnerShip != e.selectedOwnerShip) &&
              e.selectedOwnerShip != null)
          ? Nullable(null)
          : Nullable(
              e.ownershipDate == null ? state.ownershipDate : e.ownershipDate),
      emtethalAgreement: e.emtethalAgreeemnt,
      ownerShipAgreement: e.ownershipAgreement,
      isDeedPaper:
          Nullable(e.isDeedPaper == null ? state.isDeedPaper : e.isDeedPaper),
      selectedReciptType: Nullable(
        e.selectedReciptType == null
            ? state.selectedReciptType
            : e.selectedReciptType,
      ),
      ownershipText: ((state.selectedOwnerShip != e.selectedOwnerShip) &&
              e.selectedOwnerShip != null)
          ? Nullable(null)
          : Nullable(
              e.ownershipText == null ? state.ownershipText : e.ownershipText,
            ),
      deedInfo: ((state.selectedOwnerShip != e.selectedOwnerShip) &&
                  e.selectedOwnerShip != null) ||
              (e.ownershipText != null &&
                  (e.ownershipText != state.ownershipText))
          ? Nullable(null)
          : Nullable(state.deedInfo),
      landSubsidyContract: ((state.selectedOwnerShip != e.selectedOwnerShip) &&
                  e.selectedOwnerShip != null) ||
              (e.ownershipText != null &&
                  (e.ownershipText != state.ownershipText))
          ? Nullable(null)
          : Nullable(state.landSubsidyContract),
    ));

    if (e.documentTypeSelection != null)
      emitter(
        state.copyWith(
          errorMessage: "",
          selectedOwnerShip: Nullable(null),
          selectedLicense: Nullable(null),
          ownershipDate: Nullable(null),
          ownershipText: Nullable(null),
        ),
      );

    if (e.benificiaryTypeSelection == 1) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Compliance_Certificate_Open_Select_Benficiry_Event);
    } else if (e.benificiaryTypeSelection == 2) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Compliance_Certificate_Open_Select_EngOffice_Event);
    }
    if (e.selectedLicense != null && state.requestId != null) {
      add(const GetRequestDetails(updateCurrentRequest: true));
    }
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
    emitter(state.copyWith(status: BlocStatus.loading));

    final failOrSuccess = await _getComplianceGIS(e.params);

    failOrSuccess.fold(
      (l) {
        emitter(
          state.copyWith(
            errorMessage: (l as ServerFailure).errorMessage,
            status: BlocStatus.failure,
          ),
        );
      },
      (r) {
        emitter(state.copyWith(gisResponse: r, status: BlocStatus.success));
      },
    );
  }

  Future<void> _getAppintmentHandler(GetAppointments e, Emitter emitter) async {
    emitter(state.copyWith(
      appointmentsStatus: BlocStatus.loading,
    ));
    final failOrSuccess = await _getAppointments((
      state.requestDetails?.locationResponseInfoDto?.x ??
          state.gisParams?.x.toString() ??
          "",
      state.requestDetails?.locationResponseInfoDto?.y ??
          state.gisParams?.y.toString() ??
          ""
    ));
    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        appointmentsStatus: BlocStatus.failure,
        responseCode: l.errorCode,
      ));
    }, (r) async {
      emitter(state.copyWith(
          appointmentsStatus: BlocStatus.success,
          complainceAppointmentResponse: r));
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
      pageController.jumpToPage(nextPage);
      sendEventPage(nextPage);
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
        requsestId: state.requestId,
      );
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
          requsestId: state.requestId,
          isEmtithalMand: state.gisResponse?.targetBuilding);
    }
    final failOrSuccess = await _saveLocationCompliance(request);

    failOrSuccess.fold((l) {
      emitter(
        state.copyWith(
          errorMessage: (l as ServerFailure).errorMessage,
          status: BlocStatus.failure,
        ),
      );
    }, (r) async {
      if (e.save == true) {
        bool Function(Route<dynamic>) predicate =
            ModalRoute.withName(RouteName.bottomNavigation);
        NavigationService.navigatorKey.currentState!.popUntil((predicate));
      } else {
        int nextPage = state.currentStep + 1;
        emitter(state.copyWith(status: BlocStatus.performing));
        emitter(
          state.copyWith(
            status: BlocStatus.success,
            currentStep: nextPage,
            errorMessage: "",
          ),
        );
        pageController.jumpToPage(nextPage);

        sendEventPage(nextPage);

        add(GetRequestDetails(updateCurrentRequest: true));
      }
    });
  }

  Future<void> _getReciptTypesHandler(
      GetReciptTypesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      reciptTypesStatus: BlocRequestStatus.submissionGetLoading,
    ));

    final failOrSuccess = await _getReciptTypes(NoParams());

    failOrSuccess.fold(
      (l) {
        emitter(
          state.copyWith(
            errorMessage: (l as ServerFailure).errorMessage,
            reciptTypesStatus: BlocRequestStatus.submissionGetFailure,
          ),
        );
      },
      (r) {
        emitter(
          state.copyWith(
            reciptLists: r,
            reciptTypesStatus: BlocRequestStatus.submissionGetSuccess,
          ),
        );
      },
    );
  }

  Future<void> _getMainUsagesHandler(
      GetMainUsagesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      mainUsagesStatus: BlocRequestStatus.submissionGetLoading,
    ));

    final failOrSuccess = await _getComplianceMainUsages(NoParams());

    failOrSuccess.fold(
      (l) {
        emitter(
          state.copyWith(
            errorMessage: (l as ServerFailure).errorMessage,
            mainUsagesStatus: BlocRequestStatus.submissionGetFailure,
          ),
        );
      },
      (r) {
        emitter(
          state.copyWith(
            mainUsages: r,
            mainUsagesStatus: BlocRequestStatus.submissionGetSuccess,
          ),
        );
      },
    );
  }

  Future<void> _applyEventHandler(ApplyEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    ApplyCreateComplianceRequest request = state.generateRequest();
    request.requestId = state.requestId;
    final failOrSuccess = await _applyCompliance(request);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emitter(
        state.copyWith(
          requestId: r.result,
          status: BlocStatus.success,
          errorMessage: "",
          applyRequest: request,
        ),
      );
      add(GetRequestDetails());
    });
  }

  Future<void> _getLicensesHandler(GetLicensesEvent e, Emitter emitter) async {
    if (state.licenseStatus == BlocRequestStatus.submissionGetSuccess) return;
    emitter(state.copyWith(
      licenseStatus: BlocRequestStatus.submissionGetLoading,
    ));

    final failOrSuccess = await _getComplianceLicenses(NoParams());

    failOrSuccess.fold((l) {
      if ((l as ServerFailure).errorCode == "2") {
        emitter(state.copyWith(
            licenseStatus: BlocRequestStatus.submissionGetSuccess));
      } else {
        emitter(
          state.copyWith(
            errorMessage: (l as ServerFailure).errorMessage,
            licenseStatus: BlocRequestStatus.submissionGetFailure,
          ),
        );
      }
    }, (r) {
      emitter(
        state.copyWith(
          licenes: r,
          licenseStatus: BlocRequestStatus.submissionGetSuccess,
        ),
      );
    });
  }

  Future<void> _getRequestDetails(
      GetRequestDetails event, Emitter emitter) async {
    emitter(
      state.copyWith(
        detailsStatus: BlocRequestStatus.submissionGetLoading,
      ),
    );

    final failOrSuccess = await _getComplianceByRequestId(
      event.requestId ?? state.requestId.toString(),
    );

    failOrSuccess.fold((l) {
      emitter(
        state.copyWith(
          errorMessage: (l as ServerFailure).errorMessage,
          detailsStatus: BlocRequestStatus.failure,
        ),
      );
    }, (r) async {
      if (event.updateCurrentRequest == true) {
        ComplianceRequestDetails? requestDetails = state.requestDetails;

        requestDetails?.showMomtathelVisitSection = r.showMomtathelVisitSection;
        requestDetails?.isReadOnly = r.isReadOnly;

        emitter(
          state.copyWith(
            requestDetails: requestDetails,
            errorMessage: "",
            detailsStatus: BlocRequestStatus.submissionGetSuccess,
          ),
        );

        return;
      }
      // if (r.submitterThrough == "BENEFICARY"||r.submitterThrough == "MOMTATHEL") {
      List<AttachmentData> attachmentData = [];
      List<AttachmentData> viewAttachmentData = [];

      attachmentData = (r.beneficaryAttachments ?? [])
          .map(
            (e) => AttachmentData(
              id: e.id.toString(),
              memo: e.name ?? "",
              title: "${e.name} ${e.allowedFilesExtension}",
              isRequired: e.isMandatory ?? false,
              isUploaded: false,
            ),
          )
          .toList();

      viewAttachmentData = (r.requestAttachments ?? [])
          .map(
            (e) => AttachmentData(
              id: e.id.toString(),
              memo: e.name ?? "",
              title: "${e.name} ${e.allowedFilesExtension}",
              isRequired: true,
              isUploaded: false,
            ),
          )
          .toList();

      ComplinaceLookUpItem? selectedMainUsage = state.selectedMainUsage;
      ComplinaceLookUpItem? selectedSubUsage = state.selectedSubUsage;

      if (r.mainUsageCode != null && r.mainUsageName != null) {
        selectedMainUsage = ComplinaceLookUpItem(
          id: r.mainUsageCode,
          name: r.mainUsageName,
        );
      }
      if (r.subUsageCode != null && r.subUsageName != null) {
        selectedSubUsage = ComplinaceLookUpItem(
          id: r.subUsageCode,
          name: r.subUsageName,
        );
      }

      emitter(
        state.copyWith(
            requestDetails: r,
            errorMessage: "",
            selectedMainUsage: selectedMainUsage,
            selectedSubUsage: Nullable(selectedSubUsage),
            detailsStatus: BlocRequestStatus.submissionGetSuccess,
            attachments: attachmentData,
            viewAttachments: viewAttachmentData),
      );

      if (event.requestId == null) {
        int nextPage = state.currentStep + 1;
        emitter(state.copyWith(status: BlocStatus.performing));
        emitter(
          state.copyWith(
            status: BlocStatus.success,
            currentStep: nextPage,
            errorMessage: "",
          ),
        );
        pageController.jumpToPage(nextPage);

        sendEventPage(nextPage);
      } else {
        setUpDraft(r);
      }
      // } else {
      //   CommonFunctions.openBaldyWithRefreshCookie(
      //     event.redirectUrl,
      //     pushReplacement: true,
      //   );
      // }
    });

    // await _(ComplianceCertificateItemsRequest(requestId: state.requestId, ));
  }

  void setUpDraft(ComplianceRequestDetails? r) {
    List<AttachmentData> attachmentData = [];
    List<AttachmentData> viewAttachmentData = [];

    attachmentData = (r?.beneficaryAttachments ?? [])
        .map((e) => AttachmentData(
            id: e.id.toString(),
            memo: e.name ?? "",
            fileName: e.fileName,
            filePath: e.attachUrl,
            title: "${e.name} ${e.allowedFilesExtension}",
            isRequired: e.isMandatory ?? false,
            isUploaded: e.attached ?? false))
        .toList();

    viewAttachmentData = (r?.requestAttachments ?? [])
        .map((e) => AttachmentData(
            id: e.id.toString(),
            memo: e.name ?? "",
            fileName: e.fileName,
            filePath: e.attachUrl,
            title: "${e.name} ${e.allowedFilesExtension}",
            isRequired: true,
            isUploaded: e.attached ?? false))
        .toList();

    ComplinaceLookUpItem? selectedMainUsage = state.selectedMainUsage;
    ComplinaceLookUpItem? selectedSubUsage = state.selectedSubUsage;
    ComplinaceLookUpItem? selectedOwnerShip = state.selectedOwnerShip;
    ComplinaceLookUpItem? selectedReciptType = state.selectedReciptType;

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

    if (r?.ownershipDocInfoDto?.ownershipDocumentType != null) {
      selectedOwnerShip = ComplinaceLookUpItem(
          id: r?.ownershipDocInfoDto?.ownershipDocumentType,
          name: r?.ownershipDocInfoDto?.ownerShipDocTypeName);
    }

    if (r?.ownershipDocInfoDto?.receiptTypeId != null) {
      selectedReciptType = ComplinaceLookUpItem(
          id: r?.ownershipDocInfoDto?.receiptTypeId,
          name: r?.ownershipDocInfoDto?.receiptTypeDesc);
    }

    if (r?.mainUsageCode != null && r?.mainUsageName != null) {
      add(GetSubUsagesEvent(item: selectedMainUsage, clearSub: false));
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

//String applicantNotes = r?.applicantNotes?.firstWhereOrNull((element) => element.)
    emit(
      state.copyWith(
          requestDetails: r,
          isDraft: true,
          currentStep: 3,
          requestId: requestId,
          selectedReciptType: Nullable(selectedReciptType),
          contactMobileVerified: Nullable(true),
          selectedOwnerShip: Nullable(selectedOwnerShip),
          ownershipText:
              Nullable(r?.ownershipDocInfoDto?.ownershipDocumentNo ?? ""),
          ownershipDate:
              Nullable(r?.ownershipDocInfoDto?.ownershipDocumentDate ?? ""),
          gisParams: r?.locationResponseInfoDto?.gisParams(),
          gisResponse: r?.locationResponseInfoDto?.municipalityId != null
              ? ComplainceGISResponse(
                  amanaCode: r?.locationResponseInfoDto?.municipalityId,
                  amanaName: r?.locationResponseInfoDto?.municipalityName,
                  municipalityCode:
                      r?.locationResponseInfoDto?.subMunicipalityId,
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
                  parcelNo: r?.locationResponseInfoDto?.landsInfo?.landsInfo
                      ?.firstOrNull?.landNumber,
                  area: r?.locationResponseInfoDto?.landsInfo?.landsInfo
                      ?.firstOrNull?.landArea,
                  guid: r?.locationResponseInfoDto?.guid,
                  streetName: r?.locationResponseInfoDto?.streetName,
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
                  licenseId: r?.licenseNumber?.toDouble(),
                  expirationDate: r?.licenseExpiryDate,
                  issuingDate: r?.licenseIssueDate,
                  statusName: r?.licenseStatusName,
                  statusId: r?.licenseStatusId))
              : null,
          selectedMainUsage: selectedMainUsage,
          selectedSubUsage: Nullable(selectedSubUsage),
          detailsStatus: BlocRequestStatus.submissionGetSuccess,
          attachments: attachmentData,
          viewAttachments: viewAttachmentData),
    );
  }

  Future<void> _getEngOfficesHandler(
      GetEngOfficesListEvent e, Emitter emitter) async {
    emitter(
      state.copyWith(
        enginnerOfficesStatus: BlocRequestStatus.submissionGetLoading,
        selectedEngOffice: null,
        engOfficeDetails: null,
      ),
    );

    final failOrSuccess = await _getComplianceEngOffices(NoParams());

    failOrSuccess.fold(
      (l) {
        emitter(
          state.copyWith(
            errorMessage: (l as ServerFailure).errorMessage,
            enginnerOfficesStatus: BlocRequestStatus.failure,
          ),
        );
      },
      (r) {
        emitter(state.copyWith(
            engOffices: r,
            enginnerOfficesStatus: BlocRequestStatus.submissionGetSuccess));
      },
    );
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
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Compliance_Certificate_Send_OTP_Event);

      emitter(state.copyWith(
          status: BlocStatus.success, sendOtpResponse: Nullable(r)));
      if (e.showOTPPage == true)
        NavigationService.navigatorKey.currentState?.pushNamed(
          RouteName.submitComplianceOTPPage,
          arguments: this,
        );
    });
  }

  Future<void> _downloadCertificate(
      DownloadCertificateEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failOrSuccess =
        await _downloadCmplianceCertificate(state.requestId.toString());

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success));
      CommonFunctions.createOpenTempBytesFile(
          "${DateTime.now().millisecondsSinceEpoch}.pdf", r!);
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
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Compliance_Certificate_Verify_OTP_Event);

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
        ownerShipsStatus: BlocRequestStatus.submissionGetFailure,
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
        selectedMainUsage: e.item,
        selectedSubUsage: e.clearSub == false ? null : Nullable(null)));

    final failOrSuccess = await _getComplianceSubUsages(
        (e.item?.id ?? state.selectedMainUsage?.id) ?? 0);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        subUsagesStatus: BlocRequestStatus.submissionGetFailure,
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

    if (state.currentStep >= 3) {
      showCustomDialog(SaveDraftDialog(
        onClose: () {},
        onSave: () {
          if (state.currentStep == 6 ||
              state.currentStep == 5 ||
              isLastPage()) {
            bool Function(Route<dynamic>) predicate =
                ModalRoute.withName(RouteName.bottomNavigation);
            NavigationService.navigatorKey.currentState!.popUntil((predicate));
          } else {
            add(GoToNextPageEvent(save: true));
          }
        },
      ));
    } else if (state.currentStep < 3) {
      showCustomDialog(ExitDraftDialog(
        onClose: () {},
        onSave: () {
          bool Function(Route<dynamic>) predicate =
              ModalRoute.withName(RouteName.bottomNavigation);
          NavigationService.navigatorKey.currentState!.popUntil((predicate));
        },
      ));
    } else {
      bool Function(Route<dynamic>) predicate =
          ModalRoute.withName(RouteName.bottomNavigation);
      NavigationService.navigatorKey.currentState!.popUntil((predicate));
    }
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    if (isLastPage() || state.editOnlyAppointment) {
      add(SubmitComplianceEvent());
    } else if (state.currentStep == 0 && state.benificiaryTypeSelection == 2) {
      add(GetEtmamEntityIdEvent());
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
        pageController.jumpToPage(nextPage);
        sendEventPage(nextPage);
      }
    } else if (state.currentStep == 2 && state.benificiaryTypeSelection == 1) {
      // hear need delete location data
      emitter(state.copyWith(deleteGisData: true));
      if (state.generateRequest() == state.applyRequest ||
          state.isDraft == true) {
        add(GetRequestDetails());
      } else {
        add(ApplyEvent());
      }
    } else if (state.currentStep == 3) {
      add(SaveLocationData(save: e.save));
    } else if (state.currentStep == 4 && state.benificiaryTypeSelection == 1) {
      bool valid =
          state.requestDetails?.emtithalItems?.firstWhereOrNull((element) {
                print(element.submitterAnswer);
                return element.submitterAnswer == null;
              }) ==
              null;
      add(SaveImtethalItemsEvent(save: e.save));
      //if (valid)
      //  add(SaveImtethalItemsEvent(save: e.save));
      /// else {
      //   CommonFunctions.showError("please_select_all_complaince_terms".tr());
      //  }
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
      pageController.jumpToPage(nextPage);
      sendEventPage(nextPage);
    }
    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentStep == 0.0 ||
        (state.isDraft == true && state.currentStep == 3)) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentStep - 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      pageController.jumpToPage(prvoiusPage);
      sendEventPage(prvoiusPage);

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

    final failOrSuccess = await _validateComplianceCertificateItem(
      state.requestId!,
    );

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
      ));

      if (e.save == true) {
        bool Function(Route<dynamic>) predicate =
            ModalRoute.withName(RouteName.bottomNavigation);
        NavigationService.navigatorKey.currentState!.popUntil((predicate));
      } else {
        int nextPage = state.currentStep + 1;
        emitter(state.copyWith(
          status: BlocStatus.performing,
        ));
        emitter(state.copyWith(
            status: BlocStatus.success,
            currentStep: nextPage,
            errorMessage: ""));
        pageController.jumpToPage(nextPage);
        sendEventPage(nextPage);
      }
    });
  }

  Future<void> _cancelComplainceCertificate(
      CancelComplianceCertificateEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failOrSuccess = await _cancelComplianceCertificate(
      state.requestId!,
    );

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
      NavigationService.navigatorKey.currentState!.popUntil((predicate));
    });
  }

  Future<void> _saveImtethalPoint(
      SaveImtethalItemEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    if (e.item.file != null && e.item.file?.isUploaded != true) {
      final failOrSuccess =
          await _uploadClauseAttachment((e.item.file!, state.requestId!));

      await failOrSuccess.fold((l) {
        emitter(state.copyWith(
          errorMessage: (l as ServerFailure).errorMessage,
          status: BlocStatus.failure,
        ));
      }, (r) async {
        emitter(state.copyWith(status: BlocStatus.performing));

        ComplianceRequestDetails? details = state.requestDetails;
        details?.emtithalItems?[e.index].file = details
            .emtithalItems?[e.index].file
            ?.copyWith(isUploaded: true, fileKey: r.fileKey);

        emitter(state.copyWith(
            errorMessage: "",
            status: BlocStatus.success,
            requestDetails: details));
        final failOrSuccess = await _saveComplianceCertificateItem(
            ComplianceCertificateItemRequest(
          requestId: state.requestId,
          attachmentId: e.item.showNoteAndAttachments(
                  details?.isRequestReturnedFromMunicipality ?? false)
              ? r.fileKey ?? e.item.file?.fileKey
              : null,
          itemAnswer: e.item.submitterAnswer,
          itemId: e.item.itemId,
          note: e.item.showNoteAndAttachments(
                  details?.isRequestReturnedFromMunicipality ?? false)
              ? e.item.notes
              : null,
        ));

        await failOrSuccess.fold((l) {
          emitter(state.copyWith(
            errorMessage: (l as ServerFailure).errorMessage,
            status: BlocStatus.failure,
          ));
        }, (r) async {
          emitter(state.copyWith(status: BlocStatus.performing));

          ComplianceRequestDetails? details = state.requestDetails;

          details?.emtithalItems?[e.index].edit = false;
          emitter(state.copyWith(
              errorMessage: "",
              status: BlocStatus.success,
              requestDetails: details));
        });
      });
    } else {



      final failOrSuccess = await _saveComplianceCertificateItem(
          ComplianceCertificateItemRequest(
              requestId: state.requestId,
              attachmentId: e.item.showNoteAndAttachments(
                      state.requestDetails?.isRequestReturnedFromMunicipality ??
                          false)
                  ? e.item.file?.fileKey
                  : null,
              itemAnswer: e.item.submitterAnswer,
              itemId: e.item.itemId,
              note: e.item.showNoteAndAttachments(
                      state.requestDetails?.isRequestReturnedFromMunicipality ??
                          false)
                  ? e.item.notes
                  : null));

      failOrSuccess.fold((l) {
        emitter(state.copyWith(
          errorMessage: (l as ServerFailure).errorMessage,
          status: BlocStatus.failure,
        ));
      }, (r) async {
        emitter(state.copyWith(status: BlocStatus.performing));
        ComplianceRequestDetails? details = state.requestDetails;
        details?.emtithalItems?[e.index].edit = false;
        emitter(state.copyWith(
            errorMessage: "",
            status: BlocStatus.success,
            requestDetails: details));
      });
    }
  }

  Future<void> _submitRequest(SubmitComplianceEvent e, Emitter emitter) async {
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Compliance_Certificate_Send_Request_Event);

    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    final failOrSuccess = await _submitComplianceRequest((
      state.requestId.toString(),
      SubmitEmtithalRequest(
          notes: state.applicantNotes,
          visitDate: state.visitDate?.slotDate,
          visitTimeFrom: state.visitTimeFrom,
          visitTimeTo: state.visitTimeTo)
    ));
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
              thanksMessage: r.$1,
              isFawry: r.$2,
              type: PAGE_TYPE.emtethal,
              idNumber: state.requestId.toString()));
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Compliance_Certificate_Open_Success_Page_Event);
    });
  }

  Future<void> _getEtmamIdHandler(
      GetEtmamEntityIdEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    final failOrSuccess = await _getEtmamId(state.requestId.toString());
    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
      ));
      // await sl<EtmamEntryPointCubit>().onLogin();

      bool Function(Route<dynamic>) predicate =
          ModalRoute.withName(RouteName.bottomNavigation);
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.etmamMainPageCitySelector, predicate,
          arguments: (true, r));
    });
  }

  Future<void> _deleteComplianceRequest(
      DeleteComplianceRequestEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    final failOrSuccess =
        await _deleteComlianceRequest(state.requestId.toString());
    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
      ));
      add(GetRequestDetails());

      NavigationService.navigatorKey.currentState!.pushNamed(
          RouteName.successRoute,
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.deleteEmtethal,
              idNumber: state.requestId.toString()));
    });
  }

  Future<void> _getDeedInfoHandler(
      GetComplianceDeedInfoEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    String? ownerId;
    String? crType;
    if (CommonProperties.getCurrentUserProfile()?.profileType ==
        UserProfileType.Agent) {
      ownerId = CommonProperties.selectedAgent?.grantorNumber;
      crType = CommonProperties.selectedAgent?.grantorTypeId;
    }

    if (CommonProperties.getCurrentUserProfile()?.profileType ==
        UserProfileType.Delegator) {
      ownerId = CommonProperties.getCurrentUserProfile()?.id;
      crType = CommonProperties.getCurrentUserProfile()?.type;
    }

    String? deedNumber = state.ownershipText;
    final failOrSuccess = await _getDeedInfo(ComplianceDeedInfoRequest(
        ownerId: ownerId, ownerIdType: crType, deedNumber: deedNumber));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          deedInfo: Nullable(r),
          status: BlocStatus.success,
          ownershipDate: Nullable(r.getDeedDate()),
          ownershipText: Nullable(r.deedNumber.toString())));
    });
  }

  Future<void> _getLandContractHandler(
      GetComplianceLandContractEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    String? ownerId;

    if (CommonProperties.getCurrentUserProfile()?.profileType ==
        UserProfileType.Agent) {
      ownerId = CommonProperties.selectedAgent?.grantorNumber;
    }

    final failOrSuccess =
        await _getLandContract(LandSubsidyContractRequest(id: ownerId));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          errorMessage: (l as ServerFailure).errorMessage,
          status: BlocStatus.failure,
          showEksanId: (l as ServerFailure).statusCode == 400
              ? false
              : state.showEksanId));
    }, (r) {
      emitter(state.copyWith(
          landSubsidyContract: Nullable(r),
          status: BlocStatus.success,
          ownershipDate: Nullable(r.getDate()),
          showEksanId: true,
          ownershipText: Nullable(r.contractNumber.toString())));
    });
  }

  bool isLastPage() {
    return state.currentStep == (pages().length - 1);
  }

  List<dynamic> pages() {
    if (state.showNewAppointments) {
      return pagesListHimSelfWithAppointments;
    } else if (state.editOnlyAppointment) {
      return pageEditAppointments;
    } else {
      return pagesListHimSelf;
    }
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _changeAgreementHandler(
      ChangeAgreementEvent e, Emitter emitter) async {
    hideKeyboard();

    emitter(state.copyWith(agreement: e.isagree, errorMessage: ""));
  }

  Future<void> _changeSelectedAppointmentDayHandler(
      ChangeSelectedAppointmentDay e, Emitter emitter) async {
    hideKeyboard();

    emitter(state.copyWith(visitDate: e.item, errorMessage: ""));
  }

  Future<void> _changeSelectedAppointmentSlotHandler(
      ChangeSelectedAppointmentSlot e, Emitter emitter) async {
    hideKeyboard();

    emitter(state.copyWith(
        visitTimeFrom: e.visitFrom, visitTimeTo: e.visitTo, errorMessage: ""));
  }

  void sendEventPage(int page) {
    String eventName = "";

    if (page == 0) {
      eventName =
          UXCamEvents.Compliance_Certificate_Open_Select_Method_Step_Event;
    } else if (page == 1) {
      eventName =
          UXCamEvents.Compliance_Certificate_Open_Application_Info_Step_Event;
    } else if (page == 2) {
      eventName =
          UXCamEvents.Compliance_Certificate_Open_Document_Info_Step_Event;
    } else if (page == 3) {
      eventName = UXCamEvents.Compliance_Certificate_Open_Usage_Info_Step_Event;
    } else if (page == 4) {
      eventName =
          UXCamEvents.Compliance_Certificate_Open_Compliance_Info_Step_Event;
    } else if (page == 5) {
      eventName =
          UXCamEvents.Compliance_Certificate_Open_Attachments_Info_Step_Event;
    } else if (page == 6) {
      eventName = UXCamEvents.Compliance_Certificate_Open_Review_Step_Event;
    }

    if (eventName.isNotEmpty) CommonFunctions.sendUXCamEvent(eventName);
  }

  static showCustomDialog(Widget dialog, {bool isDismiss = true}) {
    showDialog(
        context: NavigationService.navigatorKey.currentState!.context,
        barrierDismissible: isDismiss,
        builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: dialog));
  }
}

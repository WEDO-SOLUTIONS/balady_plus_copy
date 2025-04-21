import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/models/attachment_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meta/meta.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../../features/_shared_feature_/data/entities/validators/cr_700_validation.dart';
import '../../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../commercial_license/domain/use_cases/get_commercial_endorsements.dart';
import '../../../../../commercial_license/presentation/step4/widgets/endorsements_agreement.dart';
import '../../../../data/models/renew_request_details.dart';
import '../../../../domain/entities/cr_attachment_response.dart';
import '../../../../domain/entities/save_renew_request.dart';
import '../../../../domain/use_cases/get_clean_contracts.dart';
import '../../../../domain/use_cases/get_cr_Attacments.dart';
import '../../../../domain/use_cases/get_deed_info.dart';
import '../../../../domain/use_cases/get_ejar_info.dart';
import '../../../../domain/use_cases/get_info_request.dart';
import '../../../../domain/use_cases/get_renew_request_details.dart';
import '../../../../domain/use_cases/get_renew_years.dart';
import '../../../../domain/use_cases/save_cr_Attacments.dart';
import '../../../../domain/use_cases/save_request_info.dart';
import '../../../../domain/use_cases/submit_renew.dart';
import '../../../../domain/use_cases/submit_renew_Attacments.dart';
import '../../../../renew_commercial_license_exports.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';

part 'renew_commercial_license_event.dart';

part 'renew_commercial_license_state.dart';

class RenewCommercialLicenseBloc
    extends Bloc<RenewCommercialLicenseEvent, RenewCommercialLicenseState> {
  PageController controller = PageController();
  final CalculateRequestInfo _calculateRequestInfo;
  final GetRenewYears _getRenewYears;
  final GetEjarInfo _getEjarInfo;
  final GetCleanContracts _getCleanContracts;
  final SaveRenewRequestInfo _saveRenewRequestInfo;

  final GetCrAttachments _getCrAttachments;
  final SaveCrAttachment _saveCrAttachment;
  final SubmitRenewAttachments _submitRenewAttachments;
  final GetRenewRequestDetails _renewRequestDetails;
  final GetCommercailEndorsements _getCommercailEndorsements;
  final SubmitRenew _submitRenew;
  final GetDeedInfo _getDeedInfo;


  RenewCommercialLicenseBloc({required int requestId})
      : _getRenewYears = GetRenewYears(repository: sl()),
        _calculateRequestInfo = CalculateRequestInfo(repository: sl()),
        _getEjarInfo = GetEjarInfo(repository: sl()),
        _getCleanContracts = GetCleanContracts(repository: sl()),
        _saveRenewRequestInfo = SaveRenewRequestInfo(repository: sl()),
        _getCrAttachments = GetCrAttachments(repository: sl()),
        _saveCrAttachment = SaveCrAttachment(repository: sl()),
        _submitRenewAttachments = SubmitRenewAttachments(repository: sl()),
        _renewRequestDetails = GetRenewRequestDetails(repository: sl()),
        _submitRenew = SubmitRenew(repository: sl()),
        _getDeedInfo = GetDeedInfo(repository: sl()),
        _getCommercailEndorsements= GetCommercailEndorsements(repository: sl()),
        super(RenewCommercialLicenseState(requestId: requestId)) {
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<GetRenewYearsEvent>(_getRenewYearsHandler);
    on<GetRequestInfoEvent>(_getRequestInfoHandler);
    on<UpdateRenewYearsEvent>(_updateRenewYears);
    on<ChangeInsidePetrolStationEvent>(_changeInsidePetrolStationHandler);
    add(GetRequestInfoEvent());
    getEndorsements();
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    int nextPage = state.currentPageValue + 1;

    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;

      emitter(state.copyWith(status: BlocStatus.performing, errorMessage: ""));

      await controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
      emitter(
        state.copyWith(
          status: BlocStatus.success,
          currentPageValue: nextPage,
        ),
      );
      sendStepEvent(nextPage);
    }

    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    int prvoiusPage = state.currentPageValue - 1;

    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      emitter(state.copyWith(status: BlocStatus.performing, errorMessage: ""));
      await controller.animateToPage(prvoiusPage,
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: prvoiusPage));
      sendStepEvent(prvoiusPage);
    }

    hideKeyboard();
  }

  Future<void> _getRenewYearsHandler(
      GetRenewYearsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        renewYearsStatus: BlocRequestStatus.submissionGetLoading,
        errorMessage: ""));
    final failOrSuccess = await _getRenewYears(state.requestId!);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          renewYearsStatus: BlocRequestStatus.submissionGetFailure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
          renewYearsStatus: BlocRequestStatus.submissionGetSuccess,
          renewYears: r.data?.result));
    });
  }

  Future<void> _getRequestInfoHandler(
      GetRequestInfoEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        calculateInfoRequestStatus: BlocStatus.loading,
        licensePeriod: int.tryParse(e.year ?? "")));
    final failOrSuccess = await _calculateRequestInfo(RenewInfoRequest(
        licensePeriod: state.licensePeriod, requestId: state.requestId!));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          calculateInfoRequestStatus: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emitter(state.copyWith(
          calculateInfoRequestStatus: BlocStatus.success, info: r));
      setUpData();
      setUpDraft();
    });
  }


  Future<void> getEndorsements() async {
    int requestId = state.requestId!;
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final failOrSuccess = await _getCommercailEndorsements(requestId);

    failOrSuccess.fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (res) {



      if (res.isNotEmpty) {
        BottomSheetDialog.showDraggableSheet(
            enableDrag: false,
            isDismissible: false,
            NavigationService.navigatorKey.currentContext!,
            child: EndorsementsAgreement(
              lstEndorsements: res.map((item) => (item as String).tr()).toList() ,
            ));

      }
      emit(state.copyWith(status: BlocStatus.success));
    });




  }

  Future<void> _updateRenewYears(
      UpdateRenewYearsEvent e, Emitter emitter) async {
    emitter(state.copyWith(licensePeriod: int.tryParse(e.year)));
  }

  Future<void> updateInvestmentContractNumber(String? value) async {
    emit(state.copyWith(investmentContractNumber: Nullable(value)));
  }

  Future<void> getDeedInfoHandler() async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final failOrSuccess = await _getDeedInfo(
        state.deedInfoRequst?.copyWith(ownerIdType: "CR_700") ??
            DeedInfoRequest());

    failOrSuccess.fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          ejarVerified: Nullable(false),
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emit(state.copyWith(
          status: BlocStatus.success, deedVerified: Nullable(true)));
    });
  }

  Future<void> getEjarInfoHandler() async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final failOrSuccess =
        await _getEjarInfo(state.ejarInfoRequst ?? EjarInfoRequest());

    failOrSuccess.fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          ejarVerified: Nullable(false),
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emit(state.copyWith(
          status: BlocStatus.success, ejarVerified: Nullable(true)));
    });
  }

  bool isLastPage() {
    return state.currentPageValue == (state.pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /*void updateSalama(
      {final bool? salamaPermitExist,
      final String? salamaPermitNumber,
      final String? slamaReportNumber}) {
    emit(state.copyWith(
        salamaPermitExist: salamaPermitExist,
        salamaPermitNumber:
            salamaPermitNumber != null ? Nullable(salamaPermitNumber) : null,
        slamaReportNumber: salamaPermitNumber != null
            ? Nullable((salamaPermitNumber))
            : null));
  }*/

  void updateCleanOptions(CRContractCleanRenewOptions type) {
    emit(state.copyWith(
        crContractCleanRenewOptions: Nullable(type), errorMessage: ""));

    if (type == CRContractCleanRenewOptions.service) {
      getCleanContracts();
    }
  }

  void updateSalama(
      {String? salamaReport, String? salamaBill, String? salamaPermit}) {
    emit(state.copyWith(
        salamaReportNumber: Nullable(salamaReport),
        salamaPermitNumber: Nullable(salamaPermit),
        salamaBillNumber: Nullable(salamaBill),
        errorMessage: ""));
  }

  void updateSalamaExists(bool? value) {
    emit(state.copyWith(
        salamaExists: Nullable(value),
        salamaReportNumber: Nullable(null),
        salamaPermitNumber: Nullable(null),
        salamaBillNumber: Nullable(null),
        errorMessage: ""));
  }

  void updateSubmitterType(CRSubmitterType type) {
    emit(state.copyWith(
        crSubmitterType: Nullable(type),
        crContractType: Nullable(null),
        crContractOption: Nullable(null),
        contractNumber: Nullable(null),
        contractDate: Nullable(null),
        selectedInvestmentContract: Nullable(null),
        errorMessage: ""));
  }

  void updateCRContractType(CRContractType type) {
    emit(state.copyWith(
        crContractType: Nullable(type),
        crContractOption: Nullable(null),
        contractNumber: Nullable(null),
        contractDate: Nullable(null),
        selectedInvestmentContract: Nullable(null),
        errorMessage: ""));
  }

  void updateCRContractOption(CRContractOption type) {
    emit(state.copyWith(
        crContractOption: Nullable(type),
        contractNumber: Nullable(null),
        contractDate: Nullable(null),
        selectedInvestmentContract: Nullable(null),
        cleanContractEndDate: Nullable(null),
        errorMessage: ""));

    // getInvestmentContracts();
  }

  void updateContractNumber(String value) {
    emit(state.copyWith(contractNumber: Nullable(value), errorMessage: ""));
  }

  void updateContractDate(String value) {
    emit(state.copyWith(contractDate: Nullable(value), errorMessage: ""));
  }

  void updateCleanContractDate(String value) {
    emit(state.copyWith(
        cleanContractEndDate: Nullable(value), errorMessage: ""));
  }

  void selectInvestmentContract(InvestmentContractItem? item) {
    emit(state.copyWith(
        selectedInvestmentContract: Nullable(item), errorMessage: ""));
  }

  void updateDeedInfo({String? ownerId, String? deedNumber}) {
    state.copyWith(status: BlocStatus.loading, errorMessage: "");

    DeedInfoRequest deedInfoRequst = state.deedInfoRequst ?? DeedInfoRequest();

    deedInfoRequst = deedInfoRequst.copyWith(
      ownerId: ownerId,
      deedNumber: deedNumber,
    );

    emit(state.copyWith(
        status: BlocStatus.success,
        deedInfoRequst: deedInfoRequst,
        deedVerified: Nullable(false),
        errorMessage: ""));
  }

  void updateTenancyInfo(
      {String? id, String? tenancyContractNumber, String? versionNumber}) {
    state.copyWith(status: BlocStatus.loading, errorMessage: "");

    EjarInfoRequest ejarInfoRequst = state.ejarInfoRequst ?? EjarInfoRequest();

    String nationalId = ejarInfoRequst.nationalId ?? "";
    String iqamaNumber = ejarInfoRequst.iqamaNumber ?? "";

    if (id?.startsWith("1") ?? false) {
      nationalId = id!;
      iqamaNumber = "";
    }
    if (id?.startsWith("2") ?? false) {
      nationalId = "";
      iqamaNumber = id!;
    }
    ejarInfoRequst = ejarInfoRequst.copyWith(
      iqamaNumber: iqamaNumber,
      nationalId: nationalId,
      tenancyContractNumber: tenancyContractNumber,
      versionNumber: versionNumber,
    );

    emit(state.copyWith(
        status: BlocStatus.success,
        ejarInfoRequst: Nullable(ejarInfoRequst),
        ejarVerified: Nullable(false),
        errorMessage: ""));
    print(state.ejarInfoRequst?.tenancyContractNumber);
  }

  void selectCleanContract(CleanContractItem? item) {
    emit(state.copyWith(
      selectedCleanContract: Nullable(item),
    ));
  }

  void getCleanContracts() async {
    int requestId = state.requestId!;

    emit(state.copyWith(
        contractsListStatus: BlocStatus.loading, errorMessage: ""));
    final response =
        await _getCleanContracts(CleanContractsRequest(requestId: requestId));
    response.fold(
        (failure) => emit(state.copyWith(
              contractsListStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          contractsListStatus: BlocStatus.success,
          cleanContractsResponse: Nullable(success)));
    });
  }

  void saveInfoRequest() async {
    int requestId = state.requestId!;

    bool? citizenPledgedToClean;
    if ((state.crContractCleanRenewOptions ==
            CRContractCleanRenewOptions.attach ||
        state.crContractCleanRenewOptions ==
            CRContractCleanRenewOptions.service)) {
      citizenPledgedToClean = true;
    }

    if ((state.crContractCleanRenewOptions ==
        CRContractCleanRenewOptions.payAll)) {
      citizenPledgedToClean = false;
    }

    String? contractNumber =
        state.info?.cleanContractResponseDto?.cleanContractInfo?.contractNumber;

    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    final response = await _saveRenewRequestInfo(
      SaveRenewRequest(
        requestId: requestId,
        citizenPledgedToClean: citizenPledgedToClean,
        deedInfoRequest: state.deedInfoRequst,
        cleanContractEndDate:
            CommonFunctions.padHijriDate(state.cleanContractEndDate),
        cleanContractNumber:
            state.selectedCleanContract?.unifiedCleanContractNo ??
                int.tryParse(state.getExitingContractNumber() ?? ""),
        contractDate: CommonFunctions.padHijriDate(state.contractDate),
        contractNumber: state.contractNumber,
        contractOption: state.crContractOption?.name,
        contractType: state.crContractType?.name,
        ejarContractInfo: state.ejarInfoRequst,
        investmentContractNumber: state.investmentContractNumber,
        sadadPeriod: state.licensePeriod,
        salamaBillNumber: state.salamaBillNumber,
        salamaPermitNumber: state.salamaPermitNumber,
        salamaReportNumber: state.salamaReportNumber,
        insidePetrolStation: state.insidePetrolStation,
        salamaPermitExist:
            state.salamaExists == true /*|| state.isOnlyPermit()*/,
      ),
    );
    response.fold((failure) {
      print(failure);
      emit(
        state.copyWith(
            status: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage),
      );
    }, (success) {
      print(success);
      emit(state.copyWith(
        status: BlocStatus.success,
      ));

      getAttachments();
    });
  }

  void getAttachments() async {
    int requestId = state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final response = await _getCrAttachments(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      List<AttachmentData> attachmentData = (success.items ?? [])
          .map((e) => AttachmentData(
                id: e.id.toString(),
                memo: e.name ?? "",
                title: "${e.name} ${e.allowedFilesExtension}",
                isRequired: e.isMandatory ?? false,
                isUploaded: e.attached ?? false,
                filePath: e.attachUrl,
                fileName: e.fileName,
              ))
          .toList();

      emit(state.copyWith(
          status: BlocStatus.success, attachments: attachmentData));
      add(const GoToNextPageEvent());
    });
  }

  deleteFile(int index) async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    List<AttachmentData> attachments = state.attachments ?? [];
    attachments[index].base64 = null;
    attachments[index].fileName = null;
    attachments[index].filePath = null;
    attachments[index].isUploaded = false;
    emit(state.copyWith(status: BlocStatus.success, attachments: attachments));
  }

  saveFile(
      {required int index,
      required String filePath,
      required String fileName,
      required String fileBase64}) async {
    int requestId = state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading));

    final failOrSuccess = await _saveCrAttachment(CrAttachmentRequest(
        requestId: requestId,
        data: state.attachments![index].copyWith(
            fileName: fileName, filePath: filePath, base64: fileBase64)));

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      List<AttachmentData> attachments = state.attachments ?? [];
      attachments[index].base64 = fileBase64;
      attachments[index].fileName = fileName;
      attachments[index].filePath = filePath;
      attachments[index].isUploaded = true;
      emit(
          state.copyWith(status: BlocStatus.success, attachments: attachments));
    });
  }

  void getRenewRequestDetails() async {
    int requestId = state.requestId!;

    emit(state.copyWith(
        requestDetailsStatus: BlocStatus.loading, errorMessage: ""));
    final response = await _renewRequestDetails(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              requestDetailsStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          requestDetailsStatus: BlocStatus.success,
          renewRequestDetails: success));
    });
  }

  void submitAttachments() async {
    int requestId = state.requestId!;
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final response = await _submitRenewAttachments(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(status: BlocStatus.success));

      add(const GoToNextPageEvent());
    });
  }

  void setUpData() {
    if (state.cleanOptionBALADIASADAD())
      emit(state.copyWith(
          crContractCleanRenewOptions:
              Nullable(CRContractCleanRenewOptions.payAll)));

    emit(state.copyWith(
      salamaExists: Nullable(null),
    ));
  }

  void setUpDraft() {
    bool isEjarVerified = state.info?.ownershipResponseDto?.tenancyContractInfo
            ?.tenancyContractNumber !=
        null;

    String id =
        state.info?.ownershipResponseDto?.tenancyContractInfo?.nationalId ?? "";

    String nationalId = "";
    String iqamaNumber = "";

    if (id.startsWith("1")) {
      nationalId = id!;
      iqamaNumber = "";
    }
    if (id.startsWith("2")) {
      nationalId = "";
      iqamaNumber = id;
    }


    final bool? insidePetrolStation = state.info?.insidePetrolStation;

    insidePetrolStation != null;

    emit(state.copyWith(
        insidePetrolStation: insidePetrolStation,
        disableInsidePetrolStation: insidePetrolStation != null));
  }

  void submitRenew() async {
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.RenewCommercialLicense_Send_Request_Event);

    int requestId = state.requestId!;
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final response = await _submitRenew(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(status: BlocStatus.success));

      NavigationService.navigatorKey.currentState!.popAndPushNamed(
        CommercialRouteName.submitApplicationSuccessfullyRenew,
        arguments: (
          "",
          success.data?.result,
          state.renewRequestDetails?.calculatorResponse?.totalCost
        ),
      );
    });
  }

  Future<void> _changeInsidePetrolStationHandler(
      ChangeInsidePetrolStationEvent e, Emitter emitter) async {
    if (state.disableInsidePetrolStation == false)
      emitter(state.copyWith(insidePetrolStation: e.value, errorMessage: ""));
  }

  void sendStepEvent(int stepNo) {
    if (stepNo == 0) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.RenewCommercialLicense_Open_Info_Step_Event);
    } else if (stepNo == 1) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.RenewCommercialLicense_Open_Attachments_Step_Event);
    } else if (stepNo == 2) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.RenewCommercialLicense_Open_Calculator_Step_Event);
    }
  }
}

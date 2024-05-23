import 'dart:convert';

import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/use_cases/create_objection.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../_shared_feature_/data/entities/validators/incident_desc_validation.dart';
import '../../../objectable_transactions/domain/entities/reason_model.dart';
import '../../../objectable_transactions/domain/entities/transaction_details.dart';
import '../../../objectable_transactions/domain/use_cases/upload_file_v2.dart';
import '../../../objectable_transactions/objections_exports.dart';
import '../pages/create_objection_details_page.dart';
import '../pages/create_objection_request_info_page.dart';
import '../pages/create_objection_user_info_page.dart';
import '../widgets/summery_widgets/summury_section.dart';

part 'create_objection_event.dart';

part 'create_objection_state.dart';

class CreateObjectionBloc
    extends Bloc<CreateObjectionEvent, CreateObjectionState> {
  final CreateObjection _createObjection;
  final UploadFileV2 _uploadFile;
  final TransactionDetails? details;
  final ObjectableTransactionsEntity? item;
  PageController controller = PageController();

  late List pagesList = [
    CreateObjectionRequestInfoPage(),
    CreateObjectionUserInfoPage(),
    CreateObjectionDetailsPage(),
    SummurySection()
  ];

  CreateObjectionBloc({this.item, this.details})
      : _createObjection = CreateObjection(repository: sl()),
        _uploadFile = UploadFileV2(repository: sl()),
        super(CreateObjectionState(
          reasons: [ReasonModel()],
          details: details,
          item: item,
        )) {
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<GoToNextPageEvent>(_goToNextPageHandler);

    /*--- Form Fields  Events --- */

    on<ChangeIssueDescEvent>(_changeIssueDescHandler);

    /*--- Submissions  Events --- */

    on<UploadFileEvent>(_uploadFileHandler);
    on<SubmitIncidentEvent>(_submitIncidentHandler);
    on<CreateIncidentRegisteredEvent>(_createIncidentRegisteredHandler);
    on<AddNewReasonEvent>(
      (event, emit) {
        emit(state.copyWith(status: BlocStatus.loading));

        List<ReasonModel> reasons = state.reasons ?? [];
        reasons.add(ReasonModel(guid: CommonFunctions.generateGUID()));
        emit(state.copyWith(status: BlocStatus.success, reasons: reasons));
      },
    );

    on<DeleteNewReasonEvent>(
      (event, emit) {
        emit(state.copyWith(status: BlocStatus.loading));

        List<ReasonModel> reasons = state.reasons ?? [];
        reasons.removeAt(event.index);
        emit(state.copyWith(status: BlocStatus.success, reasons: reasons));
      },
    );

    on<RemoveFileEvent>(_removeFileHandler);
  }

  Future<void> _changeIssueDescHandler(
      ChangeIssueDescEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<ReasonModel> reasons = state.reasons ?? [];

    reasons[e.index].notes = e.text;

    emitter(state.copyWith(
        errorMessage: "", reasons: reasons, status: BlocStatus.success));
  }

  Future<void> _submitIncidentHandler(
      SubmitIncidentEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));

    List<ReasonModel> reasons = state.reasons ?? [];
    dynamic features = [];

    List<
        Either<Failure,
            UploadFileResponse>> failureOrSuccess = await Future.wait<
        Either<Failure,
            UploadFileResponse>>(reasons
        .mapIndexed((index, e) => e
                        .file?.id ==
                    null &&
                e.file?.filePath != null
            ? _uploadFile(AttachmentItem(
                base64: e.file?.fileBase64,
                filePath: e.file?.filePath,
                caseId:
                    "${state.item?.transactionId ?? state.details?.violationId}-${CommonFunctions.generateGUID()}",
                categoryId: "Objections",
                index: index))
            : null)
        .whereNotNull());

    failureOrSuccess.forEach((element) {
      element.fold((failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) {
        int? index = success.index;
        if (index != null) {
          reasons[index] = ReasonModel(
              notes: reasons[index].notes,
              file: reasons[index]
                  .file
                  ?.copyWith(isUploaded: true, id: success.id));
        }
      });
    });

    emitter(state.copyWith(
      status: BlocStatus.success,
      reasons: reasons,
      errorMessage: "",
    ));

    List<bool> r = reasons.map((e) {
      if (e.file?.filePath != null) {
        if (e.file?.id != null)
          return true;
        else
          return false;
      } else {
        return true;
      }
    }).toList();

    if (!r.contains(false)) {
      add(CreateIncidentRegisteredEvent());
    }
  }

  Future<void> _createIncidentRegisteredHandler(
      CreateIncidentRegisteredEvent e, Emitter emitter) async {
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Objectable_Transaction_Send_Request_Event);

    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));

    CreateObjectionParams params = CreateObjectionParams();
    if (item != null)
      params = CreateObjectionParams(
          municipalityID: item?.originalMunicipalityId,
          subMunicipalityID: item?.originalSubMunicipalityId,
          serviceGroupId: item?.applicationId,
          serviceId: item?.serviceId,
          objectionTypeId: item?.objectionTypeId,
          objectedTransactionId: item?.transactionId,
          serviceTypeId: item?.serviceTypeId,
          licenseNumber: item?.licenseNumber,
          licenseTypeID: item?.licenseTypeID,
          objectedTransactionDisplayNumber: item?.transactionNumber, //
          submitterRole: CommonProperties.selectedDelegator != null
              ? CommonProperties.selectedDelegator?.roleId
              : "001",
          facilityUniqueID:
              CommonProperties.selectedDelegator?.unifiedNationalNumber,
          commercialRecord: CommonProperties.selectedDelegator?.crNumber,
          reasons: state.reasons!
              .map((e) => CreateObjectionReasonsParams(
                    fileId: e.file?.id,
                    fileName: e.file?.fileName,
                    fileType: lookupMimeType(e.file?.filePath ?? ""),
                    reason: e.notes,
                  ))
              .toList());
    else {
      params = CreateObjectionParams(
          municipalityID: details?.municipalityId,
          subMunicipalityID: details?.subMunicipalityId,
          serviceGroupId: details?.serviceGroupId,
          serviceId: details?.serviceId,
          serviceTypeId: details?.serviceTypeId,
          objectionTypeId: details?.objectionTypeId,
          objectedTransactionId: details?.violationId,
          submitterRole: CommonProperties.selectedDelegator != null
              ? CommonProperties.selectedDelegator?.roleId
              : "001",
          facilityUniqueID:
              CommonProperties.selectedDelegator?.unifiedNationalNumber,
          commercialRecord: CommonProperties.selectedDelegator?.crNumber,
          reasons: state.reasons!
              .map((e) => CreateObjectionReasonsParams(
                    fileId: e.file?.id,
                    fileName: e.file?.fileName,
                    fileType: lookupMimeType(e.file?.filePath ?? ""),
                    reason: e.notes,
                  ))
              .toList());
    }

    final failureOrSuccess = await _createObjection(params);

    failureOrSuccess.fold((failure) {
      ServerFailure serverFailure = (failure as ServerFailure);

      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: serverFailure.errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
      ));

      bool Function(Route<dynamic>) predicate =
          ModalRoute.withName(RouteName.bottomNavigation);

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Objectable_Transaction_Open_Success_Page_Event);
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute, predicate,
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.objction,
              idNumber: success.objectionRequestNumber));
    });
  }

  Future<void> _uploadFileHandler(UploadFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<ReasonModel> reasons = state.reasons ?? [];

    reasons[e.index].file = e.params;

    emitter(state.copyWith(
      status: BlocStatus.success,
      reasons: reasons,
      errorMessage: "",
    ));
  }

  Future<void> _removeFileHandler(RemoveFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<ReasonModel> reasons = state.reasons ?? [];

    reasons[e.index].file = null;

    emitter(state.copyWith(
      status: BlocStatus.success,
      reasons: reasons,
      errorMessage: "",
    ));
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.performing) return;
    int nextPage = state.currentPageValue + 1;
    emitter(state.copyWith(
      status: BlocStatus.performing,
    ));
    controller.jumpToPage(
      nextPage,
    );
    sendPageData(nextPage);
    emitter(
        state.copyWith(status: BlocStatus.success, currentPageValue: nextPage));

    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentPageValue - 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      controller.jumpToPage(prvoiusPage);
      sendPageData(prvoiusPage);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: prvoiusPage));
    }
    hideKeyboard();
  }

  void cancelRequest() {
    hideKeyboard();
    NavigationService.navigatorKey.currentState!
        .popUntil(ModalRoute.withName(RouteName.bottomNavigation));
  }

  bool isLastPage() {
    return state.currentPageValue == (pagesList.length - 1);
  }

  void sendPageData(int pageNo) {
    String eventName = "";
    if (pageNo == 0) {
      eventName = UXCamEvents.Objectable_Transaction_Open_Info_Step_Event;
    } else if (pageNo == 1) {
      eventName = UXCamEvents.Objectable_Transaction_Open_User_Data_Step_Event;
    } else if (pageNo == 2) {
      eventName = UXCamEvents.Objectable_Transaction_Open_Reasons_Step_Event;
    } else if (pageNo == 3) {
      eventName = UXCamEvents.Objectable_Transaction_Open_Review_Step_Event;
    }

    CommonFunctions.sendUXCamEvent(eventName);
  }
}

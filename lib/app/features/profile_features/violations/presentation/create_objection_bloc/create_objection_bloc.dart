import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/use_cases/create_objection.dart';
import 'package:balady_plus/app/features/profile_features/violations/domain/entities/violation_details_entity.dart';
import 'package:balady_plus/app/features/profile_features/violations/domain/entities/violations_entity.dart';
import 'package:balady_plus/app/features/profile_features/violations/presentation/pages/create_objection_details_page.dart';
import 'package:balady_plus/app/features/profile_features/violations/presentation/pages/create_objection_request_info_page.dart';
import 'package:balady_plus/app/features/profile_features/violations/presentation/pages/create_objection_user_info_page.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/services/services_exports.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/data/entities/validators/incident_desc_validation.dart';
import '../../../../objectable_transactions/domain/entities/attachment_item.dart';
import '../../../../objectable_transactions/domain/entities/reason_model.dart';
import '../../../../objectable_transactions/domain/entities/upload_file_response.dart';
import '../../../../objectable_transactions/domain/use_cases/upload_file.dart';
import '../../../../objectable_transactions/objections_exports.dart';
import '../widgets/summery_widgets/summury_section.dart';

part 'create_objection_event.dart';

part 'create_objection_state.dart';

class CreateObjectionBloc
    extends Bloc<CreateObjectionEvent, CreateObjectionState> {
  final CreateObjection _createObjection;
  final UploadFile _uploadFile;
  final ViolationDetailsEntity? details;
  final ViolationsEntity? item;
  PageController controller = PageController();

  late List pagesList = [
    CreateObjectionRequestInfoPage(
      violationsEntity: item,
    ),
    CreateObjectionUserInfoPage(),
    CreateObjectionDetailsPage(),
    SummurySection()
  ];

  CreateObjectionBloc({this.item, this.details})
      : _createObjection = CreateObjection(repository: sl()),
        _uploadFile = UploadFile(repository: sl()),
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
        reasons.add(ReasonModel());
        emit(state.copyWith(status: BlocStatus.success, reasons: reasons));
      },
    );
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
                    "${state.details?.violationId}-${CommonFunctions.generateGUID()}",
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
        if (e.file?.id != null) {
          return true;
        } else {
          return false;
        }
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
    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));

    CreateObjectionParams params = CreateObjectionParams();
    if (item != null) {
      params = CreateObjectionParams(
          municipalityID: item?.municipalityId,
          subMunicipalityID: item?.subMunicipalityId,
          serviceGroupId: item?.applicationId,
          serviceId: item?.serviceId,
          serviceTypeId: item?.serviceTypeId,
          objectionTypeId: item?.objectionTypeId,
          objectedTransactionId: details?.violationId,
          //   licenseNumber: item?.licenseNumber,
          //  licenseTypeID: item?.licenseTypeId,
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
    } else {
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

      /*
      bool Function(Route<dynamic>) predicate =
          ModalRoute.withName(RoutesNames.ObjectionsHomePage);

      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RoutesNames.successRoute, predicate,
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.objction,
              idNumber: success.objectionRequestNumber));*/
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
    await controller.animateToPage(nextPage,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
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
      await controller.animateToPage(prvoiusPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
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
}

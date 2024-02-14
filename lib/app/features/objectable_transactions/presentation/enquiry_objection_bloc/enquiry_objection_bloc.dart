import 'dart:convert';

import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
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
import '../../../objectable_transactions/domain/use_cases/upload_file.dart';
import '../../../objections/domain/entities/objection_details.dart';
import '../../domain/entities/enquiry_objection_reply_params.dart' as request;
import '../../domain/entities/enquiry_objection_reply_params.dart';
import '../../domain/entities/objection_enquiry_details.dart';
import '../../domain/use_cases/get_enquiry_objection_details.dart';

part 'enquiry_objection_event.dart';

part 'enquiry_objection_state.dart';

class EnquiryObjectionBloc
    extends Bloc<EnquiryObjectionEvent, EnquiryObjectionState> {
  final EnquiryItem item;
  final GetEnquiryObjectionDetails _getEnquiryObjection;
  final UploadFile _uploadFile;
  PageController controller = PageController();

  EnquiryObjectionBloc({
    required this.item,
  })  : _getEnquiryObjection = GetEnquiryObjectionDetails(repository: sl()),
        _uploadFile = UploadFile(repository: sl()),
        super(EnquiryObjectionState(item: item)) {
    //on<UploadFileEvent>(_uploadFileHandler);
    on<GetEnquiryObjectionEvent>(_getEnquiryObjectionHandler);
  }

  Future<void> _getEnquiryObjectionHandler(
      GetEnquiryObjectionEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failOrSuccess =
        await _getEnquiryObjection(state.item.enquiryRequestNumber ?? "");

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          errorMessage: (l as ServerFailure).errorMessage,
          status: BlocStatus.failure));
    }, (r) {
      emitter(state.copyWith(
          errorMessage: "", status: BlocStatus.success, details: r));

      request.EnquiryObjectionReplyDetails details =
          state.requestDetails ?? request.EnquiryObjectionReplyDetails();

      details.objectionRequestNumber = r.enquiryRequestNumber;
      details.objectionRequestNumber = r.objectionRequestNumber;
      details.enquiryQuestionList = [];
      r.enquiryQuestionList?.forEachIndexed((index, element) {
        details.enquiryQuestionList?[index].questionId = element.questionId;
        details.enquiryQuestionList?[index].questionAttachmentList =
            (r.enquiryQuestionList?[index].questionAttachmentList ?? [])
                .map((e) => request.QuestionAttachmentList(
                    questionAttachmentLocation: e.questionAttachmentLocation,
                    questionAttachmentName: e.questionAttachmentName))
                .toList();
      });
    });
  }
/*
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
      errorMessage: "",
    ));
  }

  Future<void> _removeFileHandler(RemoveFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<ReasonModel> reasons = state.reasons ?? [];

    reasons[e.index].file = null;

    emitter(state.copyWith(
      status: BlocStatus.success,
      errorMessage: "",
    ));
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
*/
}

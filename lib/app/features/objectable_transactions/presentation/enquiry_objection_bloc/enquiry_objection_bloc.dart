import 'dart:convert';

import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
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
import '../../domain/entities/attachment_item.dart';
import '../../domain/entities/enquiry_objection_reply_params.dart' as request;
import '../../domain/entities/enquiry_objection_reply_params.dart';
import '../../domain/entities/objection_enquiry_details.dart';
import '../../domain/entities/upload_file_response.dart';
import '../../domain/use_cases/get_enquiry_objection_details.dart';
import '../../domain/use_cases/reply_enquiry_objection.dart';

part 'enquiry_objection_event.dart';

part 'enquiry_objection_state.dart';

class EnquiryObjectionBloc
    extends Bloc<EnquiryObjectionEvent, EnquiryObjectionState> {
  final EnquiryItem item;
  final GetEnquiryObjectionDetails _getEnquiryObjection;
  final ReplyEnquiryObjectionDetails _replyEnquiryObjectionDetails;

  final UploadFile _uploadFile;
  PageController controller = PageController();

  EnquiryObjectionBloc({
    required this.item,
  })  : _getEnquiryObjection = GetEnquiryObjectionDetails(repository: sl()),
        _uploadFile = UploadFile(repository: sl()),
        _replyEnquiryObjectionDetails =
            ReplyEnquiryObjectionDetails(repository: sl()),
        super(EnquiryObjectionState(item: item)) {
    //on<UploadFileEvent>(_uploadFileHandler);
    on<GetEnquiryObjectionEvent>(_getEnquiryObjectionHandler);
    add(const GetEnquiryObjectionEvent());

    /*--- Form Fields  Events --- */

    on<ChangeIssueDescEvent>(_changeIssueDescHandler);

    /*--- Submissions  Events --- */
    on<SubmitIncidentEvent>(_submitIncidentHandler);
    on<CreateIncidentRegisteredEvent>(_createIncidentRegisteredHandler);

    on<UploadFileEvent>(_uploadFileHandler);

    on<RemoveFileEvent>(_removeFileHandler);
  }

  Future<void> _getEnquiryObjectionHandler(
      GetEnquiryObjectionEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failOrSuccess =
        await _getEnquiryObjection(state.item.enquiryRequestNumber ?? "");

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          errorMessage: (l as ServerFailure).errorMessage,
          status: BlocStatus.failure));
    }, (r) {
      emitter(state.copyWith(
          errorMessage: "", status: BlocStatus.success, details: r));

      request.EnquiryObjectionReplyDetails details =
          state.requestDetails ?? request.EnquiryObjectionReplyDetails();

      details.enquiryRequestNumber = r.enquiryRequestNumber;
      details.objectionRequestNumber = r.objectionRequestNumber;
      details.enquiryQuestionList = List.generate(
          r.enquiryQuestionList?.length ?? 0,
          (index) => request.EnquiryQuestionList());

      r.enquiryQuestionList?.forEachIndexed((index, element) {
        details.enquiryQuestionList?[index].questionId = element.questionId;
        details.enquiryQuestionList?[index].question = element.question;

        details.enquiryQuestionList?[index].questionAttachmentList =
            (r.enquiryQuestionList?[index].questionAttachmentList ?? [])
                .map((e) => request.QuestionAttachmentList(
                    questionAttachmentLocation: e.questionAttachmentLocation,
                    questionAttachmentName: e.questionAttachmentName))
                .toList();
      });

      emitter(state.copyWith(
          errorMessage: "",
          status: BlocStatus.success,
          requestDetails: details));
    });
  }

  Future<void> _uploadFileHandler(UploadFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    EnquiryObjectionReplyDetails? requestDetails = state.requestDetails;

    requestDetails?.enquiryQuestionList?[e.index].answerAttachmentList = [
      request.AnswerAttachmentList(file: e.params)
    ];

    emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
        requestDetails: requestDetails));
  }

  Future<void> _changeIssueDescHandler(
      ChangeIssueDescEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    EnquiryObjectionReplyDetails? requestDetails = state.requestDetails;

    requestDetails?.enquiryQuestionList?[e.index].answer = e.text;

    emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
        requestDetails: requestDetails));
  }

  Future<void> _removeFileHandler(RemoveFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    EnquiryObjectionReplyDetails? requestDetails = state.requestDetails;

    requestDetails
        ?.enquiryQuestionList?[e.index].answerAttachmentList?[0].file = null;

    emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
        requestDetails: requestDetails));
  }

  Future<void> _submitIncidentHandler(
      SubmitIncidentEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));

    EnquiryObjectionReplyDetails? requestDetails = state.requestDetails;
    dynamic features = [];

    List<Either<Failure, UploadFileResponse>> failureOrSuccess =
        await Future.wait<Either<Failure, UploadFileResponse>>(requestDetails!
            .enquiryQuestionList!
            .mapIndexed((index, e) => e
                            .answerAttachmentList?.firstOrNull?.file?.id ==
                        null &&
                    e.answerAttachmentList?.firstOrNull?.file?.filePath != null
                ? _uploadFile(AttachmentItem(
                    base64:
                        e.answerAttachmentList?.firstOrNull?.file?.fileBase64,
                    filePath: e.answerAttachmentList?.firstOrNull?.file?.filePath,
                    caseId: "${state.item?.enquiryRequestNumber}-${e.questionId}-${CommonFunctions.generateGUID()}",
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
          FileDataItem? file = requestDetails
              .enquiryQuestionList?[index].answerAttachmentList?[0].file;

          file = file?.copyWith(isUploaded: true, id: success.id);
          requestDetails
              .enquiryQuestionList?[index].answerAttachmentList?[0].file = file;
          requestDetails.enquiryQuestionList?[index].answerAttachmentList?[0]
              .answerAttachmentLocation = file?.id;
          requestDetails.enquiryQuestionList?[index].answerAttachmentList?[0]
              .answerAttachmentName = file?.fileName;

          ;
        }
      });
    });

    emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
        requestDetails: requestDetails));

    List<bool> r = requestDetails.enquiryQuestionList!.map((e) {
      if (e.answerAttachmentList?[0].file?.filePath != null) {
        if (e.answerAttachmentList?[0].file?.id != null)
          return true;
        else
          return false;
      } else {
        return true;
      }
    }).toList();
    print("here $r");
    if (!r.contains(false)) {
      print("G");
      add(CreateIncidentRegisteredEvent());
    }
  }

  Future<void> _createIncidentRegisteredHandler(
      CreateIncidentRegisteredEvent e, Emitter emitter) async {
    // CommonFunctions.sendUXCamEvent(
    //     UXCamEvents.Objectable_Transaction_Send_Request_Event);
    try {
      hideKeyboard();
      emitter(state.copyWith(status: BlocStatus.loading));

      final failureOrSuccess =
          await _replyEnquiryObjectionDetails(state.requestDetails!);

      failureOrSuccess.fold((failure) {
        print(failure);
        ServerFailure serverFailure = (failure as ServerFailure);

        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: serverFailure.errorMessage,
        ));
      }, (success) {
        emitter(state.copyWith(
          status: BlocStatus.success,
        ));

        //bool Function(Route<dynamic>) predicate =
        //    ModalRoute.withName(RouteName.bottomNavigation);

        //CommonFunctions.sendUXCamEvent(
        //    UXCamEvents.Objectable_Transaction_Open_Success_Page_Event);
        /* NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            RouteName.successRoute, predicate,
            arguments: SuccessScreenArgs(
                type: PAGE_TYPE.objction,
                idNumber: success.objectionRequestNumber));*/

        NavigationService.navigatorKey.currentState!.pop(true);
      });
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

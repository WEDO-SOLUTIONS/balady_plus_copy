import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/features/profile_features/incidents/domain/use_cases/get_request_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../../core/services/services_exports.dart'
    show NavigationService;
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/pages/pdf_view.dart';
import '../../../../transaction_inquiry/presentation/core/models/download_file_result.dart';
import '../../data/models/request_details_response.dart';
import '../../domain/entities/download_file_params.dart';
import '../../domain/entities/request_details_page_params.dart';
import '../../domain/entities/request_details_response.dart';
import '../../domain/use_cases/download_file.dart';
import '../../domain/use_cases/get_inc_details.dart';
import '../../domain/use_cases/get_inq_details.dart';
import '../../domain/use_cases/get_msr_details.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'crm_details_event.dart';
part 'crm_details_state.dart';

class CrmDetailsBloc extends Bloc<CrmDetailsEvent, CrmDetailsState> {
  final GetIncDetails getIncDetails;
  final GetInqDetails getInqDetails;
  final GetMsrDetails getMsrDetails;
  final GetRequestDetails getRequestDetails;
  final DownloadFile downloadFile;
  CrmDetailsBloc(
      {required RequestsType crmRequestType,
      required RequestDetailsPageParams pageParams})
      : getIncDetails = GetIncDetails(repository: sl()),
        getInqDetails = GetInqDetails(repository: sl()),
        getMsrDetails = GetMsrDetails(repository: sl()),
        getRequestDetails = GetRequestDetails(repository: sl()),
        downloadFile = DownloadFile(repository: sl()),
        super(CrmDetailsState(
            crmRequestType: crmRequestType, pageParams: pageParams)) {
    on<DownloadFileEvent>(_downloadFileHandler);
    on<GetCRMRequestEvent>((event, emit) async {
      emit(
        state.copyWith(
          crmRequestsStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );
      var failureOrSuccess;

      if (state.crmRequestType != RequestsType.DC &&
          state.crmRequestType != RequestsType.VHR) {
        if (state.crmRequestType == RequestsType.REQ) {
          failureOrSuccess = await getMsrDetails(event.id);
        } else if (state.crmRequestType == RequestsType.INC ||
            state.crmRequestType == RequestsType.TSR) {
          failureOrSuccess = await getIncDetails(event.id);
        } else if (state.crmRequestType == RequestsType.INQ) {
          failureOrSuccess = await getInqDetails(event.id);
        }
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (requests) {
            emit(
              state.copyWith(
                  crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
                  details: requests),
            );
          },
        );
      } else {
        failureOrSuccess = await getRequestDetails(event.id);
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (requests) {
            emit(
              state.copyWith(
                  crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
                  requestDetails: requests),
            );
          },
        );
      }
    });

    loadData();
  }

  void loadData() {
    if (state.crmRequestType != RequestsType.DC &&
        state.crmRequestType != RequestsType.VHR &&
        state.crmRequestType != RequestsType.TSR) {
      add(GetCRMRequestEvent(id: state.pageParams?.details.pzInsKey ?? ""));
    } else {
      if (state.crmRequestType == RequestsType.TSR)
        add(GetCRMRequestEvent(
            id: state.pageParams?.details.incidentNumber ?? ""));
      else
        add(GetCRMRequestEvent(id: state.pageParams?.details.pyId ?? ""));
    }
  }

  void showFile(DownloadFileResult file) async {
    try {
      if (file.attachName.toLowerCase().contains(".pdf")) {
        Navigator.push(
            NavigationService.navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => PDFViewer(
                      file: base64.decode(file.attachmentStream),
                      title: file.attachName,
                    )));
      } else if (file.attachName.toLowerCase().contains(".png") ||
          file.attachName.toLowerCase().contains(".jpeg") ||
          file.attachName.toLowerCase().contains(".jpg")) {
        Navigator.push(
            NavigationService.navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) =>
                    FullImageView(imageBase64: file.attachmentStream)));
      } else {
        try {
          final encodedStr = file.attachmentStream;
          Uint8List bytes = base64.decode(encodedStr);
          String dir = (await getTemporaryDirectory()).path;
          File filetemp = File("$dir/" + file.attachName);
          await filetemp.writeAsBytes(bytes);
          OpenFile.open(filetemp.path);
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

  Future<void> _downloadFileHandler(
      DownloadFileEvent e, Emitter emitter) async {
    if (state.crmRequestsStatus == BlocRequestStatus.submissionGetLoading)
      return;
    List<DownloadFileResult> files = state.files ?? [];
    int? index = files.indexWhere((element) => element.id == e.item.pzInsKey);
    if (index != -1) {
      showFile(files[index]);
      return;
    }
    emitter(state.copyWith(
        crmRequestsStatus: BlocRequestStatus.submissionGetLoading));

    try {
      var failureOrSuccess = await downloadFile(DownLoadFileParams(
          fileKey: e.item.pzInsKey ?? "", daemId: e.daemKey));

      failureOrSuccess.fold((l) {
        emitter(state.copyWith(
            crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
            errorMessage: ("errors_server_error_1").tr()));
      }, (response) {
        if (response?.errors.isNotEmpty ?? false) {
          emitter(state.copyWith(
              crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: response!.errors[0].message));
        } else {
          if (response == null) {
            emitter(state.copyWith(
                crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
                errorMessage: ("errors_server_error_1").tr()));
          } else {
            response.id = e.item.pzInsKey;
            if (files != null) {
              if (!files.contains(response)) {
                files.add(response);
              }
            } else {
              files = [];
              files.add(response);
            }
            emitter(state.copyWith(
                crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
                files: files,
                errorMessage: ""));

            showFile(response);
          }
        }
      });
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      emitter(state.copyWith(
          crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
          errorMessage: ("errors_server_error_1").tr()));
    }
  }
}

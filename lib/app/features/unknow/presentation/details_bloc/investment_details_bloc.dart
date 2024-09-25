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

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/pages/pdf_view.dart';
import '../../../profile_features/incidents/domain/entities/download_file_params.dart';
import '../../../transaction_inquiry/presentation/core/models/download_file_result.dart';
import '../../../transaction_inquiry/presentation/widgets/request_service/attachment_list.dart';
import '../../domain/use_cases/download_file.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'investment_details_event.dart';
part 'investment_details_state.dart';

class InvestmentDetailsBloc
    extends Bloc<InvestmentDetailsEvent, InvestmentDetailsState> {
  final DownloadFile downloadFile;
  InvestmentDetailsBloc()
      : downloadFile = DownloadFile(repository: sl()),
        super(InvestmentDetailsState()) {
    on<DownloadFileEvent>(_downloadFileHandler);
  }

  void showFile(DownloadIMSFileResult file) async {
    try {
      if (file.attachName?.toLowerCase().contains(".pdf") ?? false) {
/*
        Navigator.push(
            NavigationService.navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => PDFViewer(
                      file: base64.decode(file.attachmentStream!),
                      title: file.attachName,
                    )));
      } else if ((file.attachName?.toLowerCase().contains(".png") ?? false) ||
          (file.attachName?.toLowerCase().contains(".jpeg") ?? false) ||
          (file.attachName?.toLowerCase().contains(".jpg") ?? false)) {
        Navigator.push(
            NavigationService.navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) =>
                    FullImageView(imageBase64: file.attachmentStream!)));
      } else {*/
        try {
          final encodedStr = file.attachmentStream;
          Uint8List bytes = base64.decode(encodedStr!);
          String dir = (await getTemporaryDirectory()).path;
          File filetemp = File("$dir/" + (file.attachName ?? ""));
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

    emitter(state.copyWith(
        crmRequestsStatus: BlocRequestStatus.submissionGetLoading));

    try {
      var failureOrSuccess = await downloadFile(DownLoadFileParams(
        fileKey: e.fileKey ?? "",
      ));

      failureOrSuccess.fold((l) {
        emitter(state.copyWith(
            crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
            errorMessage: ("errors_server_error_1").tr()));
      }, (response) {
        if (response?.errors?.isNotEmpty ?? false) {
          emitter(state.copyWith(
              crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: response!.errors?[0].message));
        } else {
          if (response == null) {
            emitter(state.copyWith(
                crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
                errorMessage: ("errors_server_error_1").tr()));
          } else {
            emitter(state.copyWith(
                crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
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

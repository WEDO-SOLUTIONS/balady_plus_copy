import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/data/entities/validators/desc_validation.dart';
import '../../../../vd/domain/entities/upload/upload_file_params.dart';
import '../../../../vd/domain/use_cases/upload_file.dart';
import '../../domain/entities/reply_retrive_car_params.dart';
import '../../domain/use_cases/reply_retrive_car.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'retrieve_vehicles_event.dart';

part 'retrieve_vehicles_state.dart';

class ReplyRetrieveVehiclesBloc
    extends Bloc<ReplyRetrieveVehiclesEvent, ReplyRetrieveVehiclesState> {
  final ReplyReriveCar _replyRetriveCar;
  final UploadFile _uploadFile;
  final String pzInsKey;

  ReplyRetrieveVehiclesBloc({required this.pzInsKey})
      : _replyRetriveCar = ReplyReriveCar(repository: sl()),
        _uploadFile = UploadFile(repository: sl()),
        super(ReplyRetrieveVehiclesState()) {
    /*--- Form Fields  Events --- */

    on<ChangeIssueDescEvent>(_changeIssueDescHandler);

    /*--- Submissions  Events --- */

    on<UploadFileEvent>(_uploadFileHandler);
    on<SubmitIncidentEvent>(_submitIncidentHandler);
    on<CreateIncidentRegisteredEvent>(_createIncidentRegisteredHandler);
  }

  Future<void> _changeIssueDescHandler(
      ChangeIssueDescEvent e, Emitter emitter) async {
    emitter(state.copyWith(errorMessage: "", notes: e.text));
  }

  Future<void> _submitIncidentHandler(
      SubmitIncidentEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;

    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));

    if (state.file != null && state.file?.id == null) {
      var failureOrSuccess = await _uploadFile(UploadFileParams(
          attachStream: state.file?.fileBase64,
          filePath: state.file?.filePath));
      await failureOrSuccess.fold((failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) {
        FileDataItem? file =
            state.file?.copyWith(id: success.fileId, isUploaded: true);
        emitter(state.copyWith(
          status: BlocStatus.success,
          file: file,
          errorMessage: "",
        ));
        if (CommonProperties.isLoggedInMunicipality) {
          add(CreateIncidentRegisteredEvent());
        } else {}
      });
    } else {
      if (CommonProperties.isLoggedInMunicipality) {
        add(CreateIncidentRegisteredEvent());
      } else {}
    }
  }

  Future<void> _createIncidentRegisteredHandler(
      CreateIncidentRegisteredEvent e, Emitter emitter) async {
    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));
    try {
      final failureOrSuccess = await _replyRetriveCar(ReplyRetriveCarParams(
          applicantNote: state.notes ?? "",
          attachmentID: state.file?.id ?? "",
          pzInsKey: pzInsKey));

      failureOrSuccess.fold((failure) {
        ServerFailure serverFailure = (failure as ServerFailure);

        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: serverFailure.errorMessage,
        ));
      }, (success) {
        emitter(state.copyWith(
          status: BlocStatus.success1,
        ));
      });
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

  Future<void> _uploadFileHandler(UploadFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    emitter(state.copyWith(
      status: BlocStatus.success,
      file: e.params,
      errorMessage: "",
    ));
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

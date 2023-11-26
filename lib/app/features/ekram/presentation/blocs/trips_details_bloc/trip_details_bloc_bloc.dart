import 'package:balady_new_app/app/core/shared_local_services/common.dart';
import 'package:balady_new_app/app/core/shared_local_services/helpers.dart';
import 'package:balady_new_app/app/features/ekram/data/model/trips_details_params.dart';
import 'package:balady_new_app/app/features/ekram/data/model/upload_letter_params.dart';
import 'package:balady_new_app/app/features/ekram/domain/entities/trip_details.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/complete_trip.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/delete_trip.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/download_attachment.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/get_deceased_driver_request_details.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/get_trips.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/upload_trip.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/shared/core/data/entities/lookup_item.dart';
import 'package:balady_new_app/shared/core/errors/errors_exports.dart';
import 'package:balady_new_app/shared/core/utils/enums/bloc_status.dart';
import 'package:balady_new_app/shared/features/_shared_feature_/shared/data/entities/file_data_item.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import 'package:mime/mime.dart';
import 'package:collection/collection.dart';

part 'trip_details_bloc_event.dart';

part 'trip_details_bloc_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final GetTrips _getTrips;
  final DeleteTrip _deleteTrip;
  final CompleteTrip _completeTrip;
  final GetLookUp _getLookUp;
  final UploadLetter _uploadLetter;
  final DownloadAttachment _downloadAttachment;
  final GetDeceasedDriverRequestDetails _getDeceasedDriverRequestDetails;

  TripDetailsBloc(
      {required DeleteTrip deleteTrip,
      required CompleteTrip completeTrip,
      required GetLookUp getLookUp,
      required GetTrips getTrips,
      required TripDetailsParmas params,
      required UploadLetter uploadLetter,
      required DownloadAttachment downloadAttachment,
      required GetDeceasedDriverRequestDetails getDeceasedDriverRequestDetails})
      : _getTrips = getTrips,
        _deleteTrip = deleteTrip,
        _completeTrip = completeTrip,
        _getLookUp = getLookUp,
        _uploadLetter = uploadLetter,
        _downloadAttachment = downloadAttachment,
        _getDeceasedDriverRequestDetails = getDeceasedDriverRequestDetails,
        super(TripDetailsState(
            requestId: params.requestId,
            deathInfo: params.info,
            params: params,
            isCompleted:
                params.requestStatusId == 6 || params.requestStatusId == 5,
            transportAttachResponseDtoList:
                params.transportAttachResponseDtoList)) {
    on<TripDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetDriverRequestDetails>(_getDeceasedDriverRequestHandler);

    on<GetTripsDetailsInDialogEvent>(_getTripsDetailsInDialogHandler);
    on<CompleteTripEvent>(_completeTripHandler);
    on<DeleteTripEvent>(_deleteTripHandler);
    on<UploadLetterEvent>(_uploadLetterHandler);
    on<UploadHdSharieEvent>(_uploadHdSharieHandler);

    on<DownLoadAttachmentEvent>(_downLoadAttachmentHandler);
    getStationTypeLookUp();
    add(GetTripsDetailsInDialogEvent());
  }

  Future<void> _getDeceasedDriverRequestHandler(
      GetDriverRequestDetails e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    var failureOrSuccess =
        await _getDeceasedDriverRequestDetails(state.requestId);
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        transportAttachResponseDtoList:
            success.data?.result?.transportAttachResponseDtoList,
        isCompleted: success.data?.result?.requestStatusId == 6 ||
            success.data?.result?.requestStatusId == 5,
        errorMessage: "",
      ));
    });
  }

  Future<List<LookUpItem>?> getStationTypeLookUp() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getLookUp(30500);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.retry,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        stationTypes: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<void> _getTripsDetailsInDialogHandler(
      GetTripsDetailsInDialogEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getTrips(state.deathInfo.deathInfoId!);

    failureOrSuccess.fold((failure) {
      String? errorCode = (failure as ServerFailure).errorCode;
      BlocStatus status = BlocStatus.failure;
      if (errorCode == "2") {
        status = BlocStatus.success;
      }
      emitter(state.copyWith(
          status: status,
          errorMessage: status == BlocStatus.failure
              ? (failure as ServerFailure).errorMessage
              : null,
          tripDetails: status == BlocStatus.success ? [] : null));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
        tripDetails: success.data?.result,
      ));
    });
  }

  Future<void> _deleteTripHandler(DeleteTripEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _deleteTrip(e.id);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      showSuccess(success.data?.responseMessage ?? "");
      add(GetTripsDetailsInDialogEvent());
    });
  }

  Future<void> _completeTripHandler(
      CompleteTripEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _completeTrip(state.deathInfo.deathInfoId!);

    failureOrSuccess.fold((failure) {
      print(failure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
          status: BlocStatus.success, errorMessage: "", isCompleted: true));

      showSuccess(success.data?.responseMessage ?? "");

      add(GetDriverRequestDetails());
    });
  }

  Future<void> _uploadLetterHandler(
      UploadLetterEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _uploadLetter(UploadLetterParamas(
        attachTypeId: 8507,
        contentType: lookupMimeType(e.file!.filePath)!,
        fileContent: e.file!.fileBase64,
        id: e.requestId,
        requestId: state.requestId,
        fileName: e.file!.fileName,
        otherFiles: state.transportAttachResponseDtoList
                ?.where((element) => element.attachmentType != 8507)
                .toList() ??
            []));

    failureOrSuccess.fold((failure) {
      print(failure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));
      showSuccess(success.data?.responseMessage ?? "");
      add(GetDriverRequestDetails());
    });
  }

  Future<void> _uploadHdSharieHandler(
      UploadHdSharieEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _uploadLetter(UploadLetterParamas(
        attachTypeId: 8508,
        contentType: lookupMimeType(e.file!.filePath)!,
        fileContent: e.file!.fileBase64,
        id: e.requestId,
        requestId: state.requestId,
        fileName: e.file!.fileName,
        otherFiles: state.transportAttachResponseDtoList
                ?.where((element) => element.attachmentType != 8508)
                .toList() ??
            []));

    failureOrSuccess.fold((failure) {
      print(failure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));
      showSuccess(success.data?.responseMessage ?? "");
      add(GetDriverRequestDetails());
    });
  }

  Future<void> _downLoadAttachmentHandler(
      DownLoadAttachmentEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _downloadAttachment(e.id);

    failureOrSuccess.fold((failure) {
      print(failure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));
      Helpers.openFileLocal(success.data, contentType: success.type);
    });
  }
}

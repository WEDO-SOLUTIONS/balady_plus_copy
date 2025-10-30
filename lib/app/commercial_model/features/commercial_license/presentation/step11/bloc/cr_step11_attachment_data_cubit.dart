import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license/domain/entities/cr_attachment_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/models/attachment_model.dart';
import '../../../commercial_license_exports.dart'
    show CommercialLicenseBloc, CrAttachmentRequest, GoToNextPageEvent;
import '../../../domain/use_cases/get_qr_attachments.dart';
import '../../../domain/use_cases/submit_qr.dart';
import '../../../domain/use_cases/upload_qr_attachments.dart';

part 'cr_step11_attachment_data_state.dart';

class CRStep11AttachmentCubit extends Cubit<CRStep11AttachmentState> {
  final GetQrAttachments _getCrAttachments;
  final UploadQrAttachments _saveCrAttachment;
  final SubmitQR _submitQR;

  CRStep11AttachmentCubit()
      : _getCrAttachments = GetQrAttachments(repository: sl()),
        _saveCrAttachment = UploadQrAttachments(repository: sl()),
        _submitQR = SubmitQR(repository: sl()),
        super(const CRStep11AttachmentState()) {}

  void getAttachments() async {
    int requestId =
        sl<CommercialLicenseBloc>().state.applyCommercialResponse!.requestId!;

    emit(state.copyWith(attachmentStatus: BlocStatus.loading));
    final response = await _getCrAttachments(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              attachmentStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      List<AttachmentData> attachmentData = (success.items ?? [])
          .map((e) => AttachmentData(
              id: e.id.toString(),
              memo: e.name ?? "",
              title: "${e.name} ${e.allowedFilesExtension}",
              isRequired: e.isMandatory ?? false,
              filePath: e.attachUrl,
              fileName: e.fileName,
              isUploaded: e.attached ?? false))
          .toList();

      emit(state.copyWith(
          attachmentStatus: BlocStatus.success, attachments: attachmentData));
    });
  }

  void updateAgreement(bool? value) {
    emit(state.copyWith(attachmentAgreement: value));
  }

  deleteFile(int index) async {
    emit(state.copyWith(status: BlocStatus.loading));

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
    int? requestId =
        sl<CommercialLicenseBloc>().state.applyCommercialResponse?.requestId!;

    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

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

  void save() async {
    emit(state.copyWith(status: BlocStatus.loading));
    int? requestId =
        sl<CommercialLicenseBloc>().state.applyCommercialResponse?.requestId;

    final failureOrSuccess = await _submitQR(requestId!);

    failureOrSuccess.fold((l) {
      emit(
        state.copyWith(
            errorMessage: (l as ServerFailure).errorMessage,
            status: BlocStatus.failure),
      );
    }, (r) {
      emit(
        state.copyWith(errorMessage: "", status: BlocStatus.success),
      );
      sl<CommercialLicenseBloc>().add(const GoToNextPageEvent());
    });
  }
}

import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/commercial_license/domain/entities/cr_attachment_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../transaction_inquiry/presentation/core/models/attachment_model.dart';
import '../../../commercial_license_exports.dart'
    show CommercialLicenseBloc, CrAttachmentRequest;
import '../../../domain/use_cases/get_cr_Attacments.dart';
import '../../../domain/use_cases/save_cr_Attacments.dart';

part 'cr_step5_attachment_data_state.dart';

class CRStep5AttachmentCubit extends Cubit<CRStep5AttachmentState> {
  final GetCrAttachments _getCrAttachments;
  final SaveCrAttachment _saveCrAttachment;

  CRStep5AttachmentCubit()
      : _getCrAttachments = GetCrAttachments(repository: sl()),
        _saveCrAttachment = SaveCrAttachment(repository: sl()),
        super(CRStep5AttachmentState()) {
    getAttachments();
  }

  void getAttachments() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading));
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
              isUploaded: false))
          .toList();

      emit(state.copyWith(
          status: BlocStatus.success, attachments: attachmentData));
    });
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
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

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
}

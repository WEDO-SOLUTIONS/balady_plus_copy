import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license/domain/entities/cr_attachment_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license/domain/use_cases/validate_salama_attachments.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/models/attachment_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/data/entities/file_data_item.dart';
import '../../../commercial_license_exports.dart'
    show
        AddBeneficiaryNotes,
        CommercialLicenseBloc,
        CrAddNotesRequest,
        CrAttachmentRequest,
        CredenceItem,
        GetRequestCredence,
        GoToNextPageEvent,
        UploadCredence,
        ValidateAprovals,
        ValidateSalamaAttachmentsRequest;
import '../../../domain/use_cases/get_cr_Attacments.dart';
import '../../../domain/use_cases/save_cr_Attacments.dart';
import '../../../domain/use_cases/validate_approvals.dart';

part 'cr_step5_attachment_data_state.dart';

class CRStep5AttachmentCubit extends Cubit<CRStep5AttachmentState> {
  final GetCrAttachments _getCrAttachments;
  final SaveCrAttachment _saveCrAttachment;
  final AddBeneficiaryNotes _addBeneficiaryNotes;
  final ValidateAprovals _validateApprovals;
  final ValidateSalamaAttachments _validateSalamaAttachments;
  final GetRequestCredence _getRequestCredence;
  final UploadCredence _uploadCredence;
  CRStep5AttachmentCubit()
      : _getCrAttachments = GetCrAttachments(repository: sl()),
        _saveCrAttachment = SaveCrAttachment(repository: sl()),
        _addBeneficiaryNotes = AddBeneficiaryNotes(repository: sl()),
        _validateApprovals = ValidateAprovals(repository: sl()),
        _getRequestCredence = GetRequestCredence(repository: sl()),
        _uploadCredence = UploadCredence(repository: sl()),
        _validateSalamaAttachments =
            ValidateSalamaAttachments(repository: sl()),
        super(const CRStep5AttachmentState()) {}

  void getAttachments() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;
    //4517311700

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

  void getCredneces() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(
      credenceStatus: BlocStatus.loading,
      errorMessage: "",
    ));
    final response = await _getRequestCredence(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              credenceStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      List<CredenceItem> list = [];
      list.addAll(success.electronic ?? []);
      list.addAll(success.manual ?? []);

      emit(state.copyWith(credenceStatus: BlocStatus.success, crdences: list));
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

  void updateNotes(String? notes) {
    emit(state.copyWith(
      notes: notes,
      errorMessage: "",
    ));
  }

  void addBeneficiaryNotes() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));
    final response = await _addBeneficiaryNotes(
        CrAddNotesRequest(requestId: requestId, notes: state.notes));
    await response.fold(
        (failure) async => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) async {
      validateSalamaAttachments();
    });
  }

  void validateSalamaAttachments() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading));
    final response = await _validateSalamaAttachments(
        ValidateSalamaAttachmentsRequest(requestId: requestId));
    await response.fold(
        (failure) async => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) async {
      validateApprovals();
    });
  }

  void validateApprovals() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading));
    final response = await _validateApprovals(requestId);
    await response.fold(
        (failure) async => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) async {
      emit(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));
      // Go To QR Flow , if validate Approvals = true;
      if (success == true) {
        sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));
      }

      /*else if (success == false) {
        sl<CommercialLicenseBloc>().goToCalucaltePage();
      }*/

      // Go To Calculate Flow if validate Approvals = false
    });
  }

  void uploadCrednece(FileDataItem item, int index) async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

    final failOrSuccess = await _uploadCredence(CrAttachmentRequest(
        requestId: requestId,
        data: AttachmentData(
            id: state.crdences![index].credenceId!.toString(),
            fileName: item.fileName,
            filePath: item.filePath,
            base64: item.fileBase64,
            memo: item.fileName,
            title: item.fileName,
            isRequired: true,
            isUploaded: false)));

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      List<CredenceItem> attachments = state.crdences ?? [];
      attachments[index].attachmentUrl = item.filePath;

      emit(state.copyWith(status: BlocStatus.success, crdences: attachments));
    });
  }

  deleteCredence(int index) async {
    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

    List<CredenceItem> attachments = state.crdences ?? [];
    attachments[index].attachmentUrl = null;

    emit(state.copyWith(status: BlocStatus.success, crdences: attachments));
  }
}

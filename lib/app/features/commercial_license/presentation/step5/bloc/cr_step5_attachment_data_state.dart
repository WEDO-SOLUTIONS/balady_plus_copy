part of 'cr_step5_attachment_data_cubit.dart';

class CRStep5AttachmentState extends Equatable {
  final BlocStatus status;
  final BlocStatus attachmentStatus;
  final BlocStatus credenceStatus;

  final String? errorMessage;
  final CrAttachmentResponse? attachmentResponse;
  final List<AttachmentData>? attachments;
  final String? notes;
  final List<CredenceItem>? crdences;

  const CRStep5AttachmentState(
      {this.status = BlocStatus.initial,
      this.attachmentStatus = BlocStatus.initial,
      this.credenceStatus = BlocStatus.initial,
      this.errorMessage,
      this.attachmentResponse,
      this.attachments,
      this.notes,
      this.crdences});

  @override
  List<Object?> get props {
    return [
      status,
      attachmentStatus,
      credenceStatus,
      errorMessage,
      attachmentResponse,
      attachments,
      notes,
      crdences
    ];
  }

  CRStep5AttachmentState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      CrAttachmentResponse? attachmentResponse,
      BlocStatus? attachmentStatus,
      BlocStatus? credenceStatus,
      List<AttachmentData>? attachments,
      String? notes,
      List<CredenceItem>? crdences}) {
    return CRStep5AttachmentState(
        status: status ?? this.status,
        attachmentStatus: attachmentStatus ?? this.attachmentStatus,
        credenceStatus: credenceStatus ?? this.credenceStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        attachments: attachments ?? this.attachments,
        attachmentResponse: attachmentResponse ?? this.attachmentResponse,
        notes: notes ?? this.notes,
        crdences: crdences ?? this.crdences);
  }

  bool isFormValid() {
    bool isValid = true;

    attachments?.forEach((element) {
      if (element.isUploaded == false && element.isRequired == true) {
        isValid = false;
      }
    });
    return isValid;
  }
}

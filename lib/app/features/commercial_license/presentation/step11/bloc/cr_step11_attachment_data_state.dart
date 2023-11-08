part of 'cr_step11_attachment_data_cubit.dart';

class CRStep11AttachmentState extends Equatable {
  final BlocStatus status;
  final BlocStatus attachmentStatus;

  final String? errorMessage;
  final CrAttachmentResponse? attachmentResponse;
  final List<AttachmentData>? attachments;
  final bool? attachmentAgreement;

  const CRStep11AttachmentState(
      {this.status = BlocStatus.initial,
      this.attachmentStatus = BlocStatus.initial,
      this.errorMessage,
      this.attachmentResponse,
      this.attachments,
      this.attachmentAgreement});

  @override
  List<Object?> get props {
    return [
      status,
      attachmentStatus,
      errorMessage,
      attachmentResponse,
      attachments,
      attachmentAgreement
    ];
  }

  CRStep11AttachmentState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      CrAttachmentResponse? attachmentResponse,
      BlocStatus? attachmentStatus,
      List<AttachmentData>? attachments,
      bool? attachmentAgreement}) {
    return CRStep11AttachmentState(
        status: status ?? this.status,
        attachmentStatus: attachmentStatus ?? this.attachmentStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        attachments: attachments ?? this.attachments,
        attachmentResponse: attachmentResponse ?? this.attachmentResponse,
        attachmentAgreement: attachmentAgreement ?? this.attachmentAgreement);
  }
}

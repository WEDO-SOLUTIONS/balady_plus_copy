part of 'cr_step5_attachment_data_cubit.dart';

class CRStep5AttachmentState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final CrAttachmentResponse? attachmentResponse;
  final List<AttachmentData>? attachments;

  const CRStep5AttachmentState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.attachmentResponse,
      this.attachments});

  @override
  List<Object?> get props {
    return [status, errorMessage, attachmentResponse, attachments];
  }

  CRStep5AttachmentState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      CrAttachmentResponse? attachmentResponse,
      List<AttachmentData>? attachments}) {
    return CRStep5AttachmentState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        attachments: attachments ?? this.attachments,
        attachmentResponse: attachmentResponse ?? this.attachmentResponse);
  }
}

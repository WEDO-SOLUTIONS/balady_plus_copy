part of 'enquiry_objection_bloc.dart';

class EnquiryObjectionState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final FileDataItem? file;
  final String? notes;
  final EnquiryItem item;
  final ObjectionEnquiryDetails? details;
  final EnquiryObjectionReplyDetails? requestDetails;

  EnquiryObjectionState({
    this.status = BlocStatus.initial,
    this.file,
    this.errorMessage,
    this.notes,
    this.details,
    this.requestDetails,
    required this.item,
  });

  IncidentDescValidation get incidentDescValidator => notes == null
      ? IncidentDescValidation.pure()
      : IncidentDescValidation.dirty(value: notes);
  String? get incidentDescErrorText =>
      incidentDescValidator.error?.message != null
          ? (incidentDescValidator.error?.message ?? "").tr()
          : null;

  EnquiryObjectionState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final FileDataItem? file,
      final String? notes,
      final ObjectionEnquiryDetails? details,
      final EnquiryItem? item,
      final EnquiryObjectionReplyDetails? requestDetails}) {
    return EnquiryObjectionState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        file: file ?? this.file,
        notes: notes ?? this.notes,
        item: item ?? this.item,
        details: details ?? this.details,
        requestDetails: requestDetails ?? this.requestDetails);
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, notes, file, details, details, requestDetails];

  bool isFormValid() {
    return true;
  }
}

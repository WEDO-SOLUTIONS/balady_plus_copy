part of 'create_objection_bloc.dart';

class CreateObjectionState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final FileDataItem? file;
  final String? notes;
  final int currentPageValue;
  final ViolationDetailsEntity? details;
  final ViolationsEntity? item;

  final List<ReasonModel>? reasons;

  CreateObjectionState(
      {this.status = BlocStatus.initial,
      this.file,
      this.errorMessage,
      this.notes,
      this.currentPageValue = 0,
      this.details,
      this.item,
      this.reasons});

  IncidentDescValidation get incidentDescValidator => notes == null
      ? const IncidentDescValidation.pure()
      : IncidentDescValidation.dirty(value: notes);
  String? get incidentDescErrorText =>
      incidentDescValidator.error?.message != null
          ? (incidentDescValidator.error?.message ?? "").tr()
          : null;

  CreateObjectionState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final FileDataItem? file,
      final String? notes,
      final List<ReasonModel>? reasons,
      final ViolationDetailsEntity? details,
      final int? currentPageValue,
      final ViolationsEntity? item}) {
    return CreateObjectionState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        file: file ?? this.file,
        notes: notes ?? this.notes,
        reasons: reasons ?? this.reasons,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        details: details ?? this.details,
        item: item ?? this.item);
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        notes,
        file,
        currentPageValue,
        details,
        item,
      ];

  bool isFormValid() {
    return true;
  }
}

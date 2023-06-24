part of 'create_objection_bloc.dart';

class CreateObjectionState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final FileDataItem? file;
  final String? notes;
  final int currentPageValue;
  final TransactionDetails? details;
  final TransactionItem? item;

  final List<ReasonModel>? reasons;
  final DelegatorItem? delegator;

  CreateObjectionState(
      {this.status = BlocStatus.initial,
      this.file,
      this.errorMessage,
      this.notes,
      this.currentPageValue = 0,
      this.details,
      this.item,
      this.reasons,
      this.delegator});

  IncidentDescValidation get incidentDescValidator => notes == null
      ? IncidentDescValidation.pure()
      : IncidentDescValidation.dirty(value: notes);
  String? get incidentDescErrorText =>
      incidentDescValidator.error?.message != null
          ? trans(incidentDescValidator.error?.message ?? "")
          : null;

  CreateObjectionState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final FileDataItem? file,
      final String? notes,
      final List<ReasonModel>? reasons,
      final TransactionDetails? details,
      final int? currentPageValue,
      final TransactionItem? item,
      final DelegatorItem? delegator}) {
    return CreateObjectionState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        file: file ?? this.file,
        notes: notes ?? this.notes,
        reasons: reasons ?? this.reasons,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        details: details ?? this.details,
        item: item ?? this.item,
        delegator: delegator ?? this.delegator);
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
        delegator
      ];

  bool isFormValid() {
    return true;
    FormzStatus descFormStatus = Formz.validate([incidentDescValidator]);

    if (!incidentDescValidator.pure && descFormStatus.isValid) return true;
    return false;
  }
}

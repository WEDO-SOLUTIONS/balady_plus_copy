part of 'retrieve_vehicles_bloc.dart';

class ReplyRetrieveVehiclesState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final FileDataItem? file;
  final String? notes;

  ReplyRetrieveVehiclesState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.file,
      this.notes});

  DescValidation get incidentDescValidator => notes == null
      ? DescValidation.pure()
      : DescValidation.dirty(value: notes);
  String? get incidentDescErrorText =>
      incidentDescValidator.error?.message != null
          ? (incidentDescValidator.error?.message ?? "").tr()
          : null;

  ReplyRetrieveVehiclesState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final FileDataItem? file,
      final String? notes}) {
    return ReplyRetrieveVehiclesState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        file: file ?? this.file,
        notes: notes ?? this.notes);
  }

  @override
  List<Object?> get props => [status, errorMessage, file, notes];

  bool isFormValid() {
    if (incidentDescValidator.isValid && !incidentDescValidator.isPure)
      return true;

    return false;
  }
}

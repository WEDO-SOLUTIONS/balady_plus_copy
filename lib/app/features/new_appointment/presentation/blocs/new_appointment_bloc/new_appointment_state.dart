part of 'new_appointment_bloc.dart';

class NewAppointmentState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final bool? withPreviousTransaction;
  final AppointmentItemInfo? editedItemInfo;
  NewAppointmentState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.editedItemInfo,
      this.withPreviousTransaction});

  bool isNextButtonEnabled() {
    if (currentPageValue == 0) {}

    return false;
  }

  NewAppointmentState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      int? currentPageValue,
      bool? withPreviousTransaction,
      AppointmentItemInfo? editedItemInfo}) {
    return NewAppointmentState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        editedItemInfo: editedItemInfo ?? this.editedItemInfo,
        withPreviousTransaction:
            withPreviousTransaction ?? this.withPreviousTransaction);
  }

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
        withPreviousTransaction,
        errorMessage,
        editedItemInfo
      ];
}

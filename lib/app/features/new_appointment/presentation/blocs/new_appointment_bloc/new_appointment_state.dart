part of 'new_appointment_bloc.dart';

class NewAppointmentState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final bool? withPreviousTransaction;
  NewAppointmentState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.withPreviousTransaction});

  bool isNextButtonEnabled() {
    if (currentPageValue == 0) {}

    return false;
  }

  NewAppointmentState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      int? currentPageValue,
      bool? withPreviousTransaction}) {
    return NewAppointmentState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        withPreviousTransaction:
            withPreviousTransaction ?? this.withPreviousTransaction);
  }

  @override
  List<Object?> get props =>
      [status, currentPageValue, withPreviousTransaction, errorMessage];
}

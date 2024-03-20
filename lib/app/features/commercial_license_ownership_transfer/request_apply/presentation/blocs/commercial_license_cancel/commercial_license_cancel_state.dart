part of 'commercial_license_cancel_bloc.dart';

class CommercialLicenseCancelState extends Equatable {
  const CommercialLicenseCancelState();

  @override
  List<Object> get props => [];

  CommercialLicenseCancelState copyWith() {
    return const CommercialLicenseCancelState();
  }
}

class CommercialLicenseCancelSucceededState
    extends CommercialLicenseCancelState {
  const CommercialLicenseCancelSucceededState();

  @override
  List<Object> get props => [];

  @override
  CommercialLicenseCancelSucceededState copyWith() {
    return const CommercialLicenseCancelSucceededState();
  }
}

class SubmitCancelRequestSucceededState extends CommercialLicenseCancelState {
  final SubmitResponse submitResponse;
  final double totalCost;

  const SubmitCancelRequestSucceededState({
    required this.submitResponse,
    required this.totalCost,
  });

  @override
  List<Object> get props => [submitResponse];
}

class CommercialLicenseCancelLoadingState extends CommercialLicenseCancelState {
  const CommercialLicenseCancelLoadingState();

  @override
  List<Object> get props => [];
}

class CommercialLicenseCancelFailureState extends CommercialLicenseCancelState {
  final String errorMessage;

  const CommercialLicenseCancelFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class SelectedReasonCancel extends CommercialLicenseCancelState {
  final ReasonCancel reasonCancel;

  const SelectedReasonCancel({required this.reasonCancel});

  @override
  List<Object> get props => [reasonCancel];
}

class SelectedAcknowledgePledge extends CommercialLicenseCancelState {
  final bool acknowledgePledge;

  const SelectedAcknowledgePledge({required this.acknowledgePledge});

  @override
  List<Object> get props => [acknowledgePledge];
}

class SelectedHijriCalendar extends CommercialLicenseCancelState {
  final HijriCalendar hijriCalendar;

  const SelectedHijriCalendar({required this.hijriCalendar});

  @override
  List<Object> get props => [hijriCalendar];
}

class ShowedCostInfo extends CommercialLicenseCancelState {
  final bool showCostInfo;

  const ShowedCostInfo({required this.showCostInfo});

  @override
  List<Object> get props => [showCostInfo];
}

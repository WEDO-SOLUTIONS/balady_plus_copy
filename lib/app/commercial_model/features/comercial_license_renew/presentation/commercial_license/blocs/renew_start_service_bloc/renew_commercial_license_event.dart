part of 'renew_commercial_license_bloc.dart';

@immutable
abstract class RenewStartServiceEvent extends Equatable {
  const RenewStartServiceEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends RenewStartServiceEvent {
  const GoToNextPageEvent();
}

class ValidateBeforeApplyEvent extends RenewStartServiceEvent {
  const ValidateBeforeApplyEvent();
}

class RenewApplyEvent extends RenewStartServiceEvent {
  const RenewApplyEvent();
}

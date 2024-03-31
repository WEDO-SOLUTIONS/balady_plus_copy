part of 'request_approval_sequence_cubit.dart';

class RequestApprovalSequenceState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class InitialState implements RequestApprovalSequenceState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

final class LoadingState extends RequestApprovalSequenceState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class EmptyState extends RequestApprovalSequenceState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class FailureState extends RequestApprovalSequenceState {
  final String failureMessage;

  FailureState({required this.failureMessage});

  @override
  List<Object?> get props => [failureMessage];
}

final class SucceedState extends RequestApprovalSequenceState {
  final RequestPermitsModel permitsList;

  SucceedState({required this.permitsList});

  @override
  List<Object?> get props => [permitsList];
}

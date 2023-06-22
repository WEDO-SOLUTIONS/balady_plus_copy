part of 'delegators_cubit.dart';

class DelegatorsState extends Equatable {
  final BlocRequestStatus status;
  final List<DelegatorEntity> delegators;
  final DelegatorEntity? selectedDelegate;
  final String? errorMessage;

  const DelegatorsState({
    this.status = BlocRequestStatus.initial,
    this.delegators = const [],
    this.selectedDelegate,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  DelegatorsState copyWith({
    BlocRequestStatus? status,
    List<DelegatorEntity>? delegators,
    Nullable<DelegatorEntity?>? selectedDelegator,
    String? errorMessage,
  }) {
    return DelegatorsState(
      status: status ?? this.status,
      delegators: delegators ?? this.delegators,
      selectedDelegate: selectedDelegator == null
          ? selectedDelegate
          : selectedDelegator.value,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        delegators,
        selectedDelegate,
        errorMessage,
      ];
}

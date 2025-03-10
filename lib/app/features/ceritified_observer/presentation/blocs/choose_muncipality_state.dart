part of 'choose_muncipality_bloc.dart';


class ChooseMuncipalityState extends Equatable {
  final BlocRequestStatus status;
  final String? errorMessage;
  final ObserverStatusEntity? observerStatusEntity;

  const ChooseMuncipalityState({
    this.status = BlocRequestStatus.initial,
    this.errorMessage,
    this.observerStatusEntity
  });



  ChooseMuncipalityState copyWith({
    BlocRequestStatus? status,
    String? errorMessage,
     ObserverStatusEntity? observerStatusEntity
  }) {
    return ChooseMuncipalityState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
        observerStatusEntity:observerStatusEntity??this.observerStatusEntity
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    observerStatusEntity
  ];
}

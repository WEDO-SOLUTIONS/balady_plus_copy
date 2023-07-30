part of 'sub_services_bloc.dart';

class SubServicesState extends Equatable {
  final BlocStatus blocStatus;

  final SubServiceResponse? subServiceResponse;

  final String? errorMessage;

  const SubServicesState({
    this.errorMessage,
    this.blocStatus = BlocStatus.initial,
    this.subServiceResponse,
  });

  SubServicesState copyWith({
    final String? errorMessage,
    final BlocStatus? blocStatus,
    final SubServiceResponse? subServiceResponse,
  }) {
    return SubServicesState(
      blocStatus: blocStatus ?? this.blocStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      subServiceResponse: subServiceResponse ?? this.subServiceResponse,
    );
  }

  @override
  List<Object> get props => [
        blocStatus,
      ];
}

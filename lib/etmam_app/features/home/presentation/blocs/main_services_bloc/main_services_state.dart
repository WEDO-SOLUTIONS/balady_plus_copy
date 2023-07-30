part of 'main_services_bloc.dart';

class MainServicesState extends Equatable {
  final BlocStatus blocStatus;

  final MainServiceResponse? mainServiceResponse;

  final String? errorMessage;

  const MainServicesState({
    this.errorMessage,
    this.blocStatus = BlocStatus.initial,
    this.mainServiceResponse,
  });

  MainServicesState copyWith({
    final String? errorMessage,
    final BlocStatus? blocStatus,
    final MainServiceResponse? mainServiceResponse,
  }) {
    return MainServicesState(
      blocStatus: blocStatus ?? this.blocStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      mainServiceResponse: mainServiceResponse ?? this.mainServiceResponse,
    );
  }

  @override
  List<Object> get props => [
        blocStatus,
      ];
}

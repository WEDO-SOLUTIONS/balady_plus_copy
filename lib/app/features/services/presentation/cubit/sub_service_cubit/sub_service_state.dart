part of 'sub_service_cubit.dart';

class SubServiceState extends Equatable {
  const SubServiceState();
  SubServiceState copyWith() {
    return const SubServiceState();
  }
  @override
  List<Object?> get props => [];
}

class LoadingSubServiceState extends SubServiceState {
  const LoadingSubServiceState();
  @override
  List<Object?> get props => [];
}

class LoadedSubServiceState extends SubServiceState {
  final List<Service> listOfServices;
  const LoadedSubServiceState({required this.listOfServices});
  @override
  List<Object?> get props => [listOfServices.length];
}

class ErrorSubServiceState extends SubServiceState {
  final String message;
  const ErrorSubServiceState({required this.message});
  @override
  List<Object?> get props => [message];
}




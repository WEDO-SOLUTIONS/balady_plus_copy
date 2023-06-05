part of 'entry_point_cubit.dart';

class EntryPointState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;

  const EntryPointState({
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage];

  EntryPointState copyWith({
    AuthStatus? status,
    String? errorMessage,
  }) {
    return EntryPointState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'EntryPointState(status: $status, errorMessage: $errorMessage)';
}

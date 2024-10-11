part of 'activites_bloc.dart';

class ActivitesState extends Equatable {
  final BlocStatus isicsStatus;
  final List<LookUpItem>? isics;
  final String? errorMessage;

  const ActivitesState({
    this.isicsStatus = BlocStatus.initial,
    this.isics,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        isicsStatus,
        isics,
        errorMessage,
      ];

  ActivitesState copyWith({
    BlocStatus? isicsStatus,
    List<LookUpItem>? isics,
    String? errorMessage,
  }) {
    return ActivitesState(
      isicsStatus: isicsStatus ?? this.isicsStatus,
      isics: isics ?? this.isics,
      errorMessage: errorMessage,
    );
  }
}

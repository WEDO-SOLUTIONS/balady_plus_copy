part of 'work_times_cubit.dart';

class WorkTimesState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final List<WorkingTime>? workingTimes;

  const WorkTimesState(
      {this.workingTimes, this.status = BlocStatus.initial, this.errorMessage});

  @override
  List<Object?> get props => [workingTimes, status, errorMessage];

  WorkTimesState copyWith(
      {List<WorkingTime>? workTimes,
      BlocStatus? status,
      final String? errorMessage}) {
    return WorkTimesState(
        workingTimes: workTimes ?? this.workingTimes,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status);
  }
}

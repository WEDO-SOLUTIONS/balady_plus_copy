part of 'work_times_cubit.dart';

class WorkTimesState extends Equatable {
  final List<WorkTimesEntity> workTimes;

  const WorkTimesState({
    this.workTimes = const [
      WorkTimesEntity(weekDay: 'sunday'),
      WorkTimesEntity(weekDay: 'monday'),
      WorkTimesEntity(weekDay: 'tuesday'),
      WorkTimesEntity(weekDay: 'wednesday'),
      WorkTimesEntity(weekDay: 'thursday'),
      WorkTimesEntity(weekDay: 'friday'),
      WorkTimesEntity(weekDay: 'saturday'),
    ],
  });

  @override
  List<Object> get props => [workTimes];

  WorkTimesState copyWith({
    List<WorkTimesEntity>? workTimes,
  }) {
    return WorkTimesState(
      workTimes: workTimes ?? this.workTimes,
    );
  }
}

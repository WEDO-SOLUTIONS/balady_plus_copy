part of 'cr_step2_activity_data_cubit.dart';

class CrStep2ActivityDataState extends Equatable {
  final BlocStatus subActivitiesStatus;
  final List<SubActivityEntity> subActivities;

  final DropDownItem? selectedIsicActivity;
  final DropDownItem? selectedSubActivity;
  final String errorMessage;

  const CrStep2ActivityDataState({
    this.subActivitiesStatus = BlocStatus.initial,
    this.selectedIsicActivity,
    this.selectedSubActivity,
    this.subActivities = const [],
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
        subActivitiesStatus,
        selectedIsicActivity,
        selectedSubActivity,
        errorMessage,
        subActivities,
      ];

  CrStep2ActivityDataState copyWith({
    BlocStatus? subActivitiesStatus,
    List<SubActivityEntity>? subActivities,
    DropDownItem? selectedIsicActivity,
    DropDownItem? selectedSubActivity,
    String? errorMessage,
  }) {
    return CrStep2ActivityDataState(
      subActivitiesStatus: subActivitiesStatus ?? this.subActivitiesStatus,
      subActivities: subActivities ?? this.subActivities,
      selectedIsicActivity: selectedIsicActivity ?? this.selectedIsicActivity,
      selectedSubActivity: selectedSubActivity ?? this.selectedSubActivity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

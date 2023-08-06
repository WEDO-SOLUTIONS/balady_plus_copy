part of 'cr_step2_activity_data_cubit.dart';

class CrStep2ActivityDataState extends Equatable {
  final BlocStatus subActivitiesStatus;
  final BlocStatus accommodationTypesStatus;

  final List<SubActivityEntity> subActivities;
  final List<CrLookupsEntity> accommodationTypes;

  final DropDownItem? selectedIsicActivity;
  final DropDownItem? selectedSubActivity;
  final DropDownItem? selectedAccommodationType;

  final String errorMessage;

  const CrStep2ActivityDataState({
    this.subActivitiesStatus = BlocStatus.initial,
    this.accommodationTypesStatus = BlocStatus.initial,
    this.selectedIsicActivity,
    this.selectedSubActivity,
    this.selectedAccommodationType,
    this.subActivities = const [],
    this.accommodationTypes = const [],
    this.errorMessage = '',
  });

  @override
  List<Object?> get props =>
      [
        subActivitiesStatus,
        accommodationTypesStatus,
        subActivities,
        accommodationTypes,
        selectedIsicActivity,
        selectedSubActivity,
        selectedAccommodationType,
        errorMessage,
      ];

  CrStep2ActivityDataState copyWith({
    BlocStatus? subActivitiesStatus,
    BlocStatus? accommodationTypesStatus,
    List<SubActivityEntity>? subActivities,
    List<CrLookupsEntity>? accommodationTypes,
    DropDownItem? selectedIsicActivity,
    DropDownItem? selectedSubActivity,
    DropDownItem? selectedAccommodationType,
    String? errorMessage,
  }) {
    return CrStep2ActivityDataState(
      subActivitiesStatus: subActivitiesStatus ?? this.subActivitiesStatus,
      accommodationTypesStatus:
          accommodationTypesStatus ?? this.accommodationTypesStatus,
      subActivities: subActivities ?? this.subActivities,
      accommodationTypes: accommodationTypes ?? this.accommodationTypes,
      selectedIsicActivity: selectedIsicActivity ?? this.selectedIsicActivity,
      selectedSubActivity: selectedSubActivity ?? this.selectedSubActivity,
      selectedAccommodationType:
          selectedAccommodationType ?? this.selectedAccommodationType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

part of 'cr_step2_activity_data_cubit.dart';

class CrStep2ActivityDataState extends Equatable {
  final BlocStatus subActivitiesStatus;
  final BlocStatus accommodationTypesStatus;
  final BlocStatus subActivityDetailsStatus;

  final List<SubActivityEntity> subActivities;
  final List<CrLookupsEntity> accommodationTypes;
  final SubActivityDetails? subActivityDetails;

  final DropDownItem? selectedIsicActivity;
  final DropDownItem? selectedSubActivity;
  final DropDownItem? selectedAccommodationType;

  final String errorMessage;

  const CrStep2ActivityDataState({
    this.subActivitiesStatus = BlocStatus.initial,
    this.accommodationTypesStatus = BlocStatus.initial,
    this.subActivityDetailsStatus = BlocStatus.initial,
    this.selectedIsicActivity,
    this.selectedSubActivity,
    this.subActivityDetails,
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
        subActivityDetailsStatus,
        subActivities,
        accommodationTypes,
        selectedIsicActivity,
        selectedSubActivity,
        selectedAccommodationType,
        subActivityDetails,
        errorMessage,
      ];

  CrStep2ActivityDataState copyWith({
    BlocStatus? subActivitiesStatus,
    BlocStatus? accommodationTypesStatus,
    BlocStatus? subActivityDetailsStatus,
    List<SubActivityEntity>? subActivities,
    List<CrLookupsEntity>? accommodationTypes,
    SubActivityDetails? subActivityDetails,
    DropDownItem? selectedIsicActivity,
    Nullable<DropDownItem?>? selectedSubActivity,
    DropDownItem? selectedAccommodationType,
    String? errorMessage,
  }) {
    return CrStep2ActivityDataState(
      subActivitiesStatus: subActivitiesStatus ?? this.subActivitiesStatus,
      accommodationTypesStatus:
          accommodationTypesStatus ?? this.accommodationTypesStatus,
      subActivityDetailsStatus:
          subActivityDetailsStatus ?? this.subActivityDetailsStatus,
      subActivities: subActivities ?? this.subActivities,
      accommodationTypes: accommodationTypes ?? this.accommodationTypes,
      subActivityDetails: subActivityDetails ?? this.subActivityDetails,
      selectedIsicActivity: selectedIsicActivity ?? this.selectedIsicActivity,
      selectedSubActivity: selectedSubActivity == null
          ? this.selectedSubActivity
          : selectedSubActivity.value,
      selectedAccommodationType:
          selectedAccommodationType ?? this.selectedAccommodationType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

part of 'cr_step2_activity_data_cubit.dart';

class CrStep2ActivityDataState extends Equatable {
  final BlocStatus subActivitiesStatus;
  final BlocStatus accommodationTypesStatus;
  final BlocStatus subActivityDetailsStatus;
  final BlocStatus status;

  final List<SubActivityEntity> subActivities;
  final List<CrLookupsEntity> accommodationTypes;
  final SubActivityDetails? subActivityDetails;

  final IsicActivity? selectedIsicActivity;
  final SubActivityEntity? selectedSubActivity;
  final DropDownItem? selectedAccommodationType;

  final String errorMessage;

  final double? totalArea;
  final WorkersTypes? workerType;

  const CrStep2ActivityDataState(
      {this.subActivitiesStatus = BlocStatus.initial,
      this.accommodationTypesStatus = BlocStatus.initial,
      this.subActivityDetailsStatus = BlocStatus.initial,
      this.status = BlocStatus.initial,
      this.selectedIsicActivity,
      this.selectedSubActivity,
      this.subActivityDetails,
      this.selectedAccommodationType,
      this.subActivities = const [],
      this.accommodationTypes = const [],
      this.errorMessage = '',
      this.totalArea,
      this.workerType});

  @override
  List<Object?> get props => [
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
        totalArea,
        workerType,
        status
      ];

  CrStep2ActivityDataState copyWith(
      {BlocStatus? subActivitiesStatus,
      BlocStatus? accommodationTypesStatus,
      BlocStatus? subActivityDetailsStatus,
      BlocStatus? status,
      List<SubActivityEntity>? subActivities,
      List<CrLookupsEntity>? accommodationTypes,
      SubActivityDetails? subActivityDetails,
      IsicActivity? selectedIsicActivity,
      Nullable<SubActivityEntity?>? selectedSubActivity,
      DropDownItem? selectedAccommodationType,
      String? errorMessage,
      double? totalArea,
      WorkersTypes? workerType}) {
    return CrStep2ActivityDataState(
        status: status ?? this.status,
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
        totalArea: totalArea ?? this.totalArea,
        workerType: workerType ?? this.workerType);
  }
}

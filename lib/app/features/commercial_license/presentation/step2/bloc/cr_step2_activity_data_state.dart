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

  final List<AddetionalActivityItem>? addetionalActivityItems;
  final List<AddetionalActivityItemDetails>? addetionalActivityItemDetails;
  final BlocStatus addetionalActivityListStatus;
  final BlocStatus addetionalActivityDetailsListStatus;

  final List<AddetionalActivityRequest>? selectedAddetionalList;
  final AddetionalActivityItem? addetionalItem;
  final AddetionalActivityItemDetails? addetionalDetailsItem;
  final SubActivityDetails? addetionalDetails;

  const CrStep2ActivityDataState(
      {this.subActivitiesStatus = BlocStatus.initial,
      this.accommodationTypesStatus = BlocStatus.initial,
      this.subActivityDetailsStatus = BlocStatus.initial,
      this.addetionalActivityListStatus = BlocStatus.initial,
      this.addetionalActivityDetailsListStatus = BlocStatus.initial,
      this.addetionalActivityItems,
      this.addetionalActivityItemDetails,
      this.status = BlocStatus.initial,
      this.selectedIsicActivity,
      this.selectedSubActivity,
      this.subActivityDetails,
      this.selectedAccommodationType,
      this.subActivities = const [],
      this.accommodationTypes = const [],
      this.errorMessage = '',
      this.totalArea,
      this.workerType,
      this.selectedAddetionalList,
      this.addetionalItem,
      this.addetionalDetailsItem,
      this.addetionalDetails});

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
        status,
        addetionalActivityListStatus,
        addetionalActivityDetailsListStatus,
        addetionalItem,
        addetionalDetailsItem,
        addetionalDetails,
      ];

  CrStep2ActivityDataState copyWith({
    BlocStatus? subActivitiesStatus,
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
    WorkersTypes? workerType,
    List<AddetionalActivityItem>? addetionalActivityItems,
    List<AddetionalActivityItemDetails>? addetionalActivityItemDetails,
    BlocStatus? additionalActivityListStatus,
    BlocStatus? addetionalActivityDetailsListStatus,
    Nullable<List<AddetionalActivityRequest>?>? selectedAddetionalList,
    Nullable<AddetionalActivityItem?>? addetionalItem,
    Nullable<AddetionalActivityItemDetails?>? addetionalDetailsItem,
    Nullable<SubActivityDetails?>? addetionalDetails,
  }) {
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
        workerType: workerType ?? this.workerType,
        addetionalActivityItems:
            addetionalActivityItems ?? this.addetionalActivityItems,
        addetionalActivityItemDetails:
            addetionalActivityItemDetails ?? this.addetionalActivityItemDetails,
        addetionalActivityListStatus:
            additionalActivityListStatus ?? this.addetionalActivityListStatus,
        addetionalActivityDetailsListStatus:
            addetionalActivityDetailsListStatus ??
                this.addetionalActivityDetailsListStatus,
        selectedAddetionalList: selectedAddetionalList == null
            ? this.selectedAddetionalList
            : selectedAddetionalList.value,
        addetionalItem:
            addetionalItem == null ? this.addetionalItem : addetionalItem.value,
        addetionalDetailsItem: addetionalDetailsItem == null
            ? this.addetionalDetailsItem
            : addetionalDetailsItem.value,
        addetionalDetails: addetionalDetails == null
            ? this.addetionalDetails
            : addetionalDetails.value);
  }

  List<AddetionalActivityItem> getAddetionalActivityItems() {
    List<AddetionalActivityItem> items = [];

    addetionalActivityItems?.forEach((element) {
      var isAdded = false;
      selectedAddetionalList?.forEach((e) {
        if (element.isicCode == e.item?.isicCode) {
          isAdded = true;
        }
      });
      if (!isAdded) {
        items.add(element);
      }
    });
    return items;
  }

  bool isFormValid() {
    return workerType != null &&
        totalArea != null &&
        totalArea != 0 &&
        selectedIsicActivity != null &&
        selectedSubActivity != null;
  }
}

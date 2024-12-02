part of 'step2_activity_data_export_cubit.dart';

class Step2ActivityDataExportState extends Equatable {
  final BlocStatus subActivitiesStatus;
  final BlocStatus accommodationTypesStatus;
  final BlocStatus subActivityDetailsStatus;
  final BlocStatus status;

  final List<SubActivityEntity> subActivities;
  final List<LookupsModel> accommodationTypes;
  final SubActivityDetails? subActivityDetails;

  final IsicActivity? selectedIsicActivity;
  final SubActivityEntity? selectedSubActivity;
  final LookupsModel? selectedAccommodationType;
  final String errorMessage;
  final double? totalArea;
  final String? unitCount;
  final WorkersTypes? workerType;
  final List<AddetionalActivityItem>? addetionalActivityItems;
  final List<AddetionalActivityItemDetails>? addetionalActivityItemDetails;
  final BlocStatus addetionalActivityListStatus;
  final BlocStatus addetionalActivityDetailsListStatus;
  final List<AddetionalActivityRequest>? selectedAddetionalList;
  final AddetionalActivityItem? addetionalItem;
  final AddetionalActivityItemDetails? addetionalDetailsItem;
  final SubActivityDetails? addetionalDetails;
  final bool? atmFeesPaid;
  final bool? draftLoaded;
  final BlocStatus draftStatus;


  final GISResponse? gisResponse;
  final GISParams? location;
  final GISParams? userLocation;
  final bool? isLocationAllowed;
  final bool? readOnly;
  final int? requestNo;
  final SaveLocationResponse? locationResponse;
  final String? landNo;
  final String? mapNo;



  const Step2ActivityDataExportState(
      {this.subActivitiesStatus = BlocStatus.initial,
      this.accommodationTypesStatus = BlocStatus.initial,
      this.draftStatus = BlocStatus.initial,
      this.subActivityDetailsStatus = BlocStatus.initial,
      this.addetionalActivityListStatus = BlocStatus.initial,
      this.addetionalActivityDetailsListStatus = BlocStatus.initial,
      this.addetionalActivityItems,
      this.addetionalActivityItemDetails,
      this.unitCount,
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
      this.addetionalDetails,
      this.atmFeesPaid,
      this.draftLoaded,

        this.gisResponse,
        this.location,
        this.userLocation,
        this.isLocationAllowed = true,
        this.readOnly = false,
        this.locationResponse,
        this.requestNo,
        this.landNo,
        this.mapNo,

      });

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
        unitCount,
        addetionalActivityListStatus,
        addetionalActivityDetailsListStatus,
        addetionalItem,
        addetionalDetailsItem,
        addetionalDetails,
        atmFeesPaid,
        draftLoaded,
        draftStatus,
    gisResponse,
    location,
    userLocation,
    isLocationAllowed,
    readOnly,
    locationResponse,
    requestNo,
    landNo,
    mapNo,
      ];

  Step2ActivityDataExportState copyWith(
      {BlocStatus? subActivitiesStatus,
      BlocStatus? accommodationTypesStatus,
      BlocStatus? subActivityDetailsStatus,
      BlocStatus? status,
      BlocStatus? draftStatus,
      List<SubActivityEntity>? subActivities,
      List<LookupsModel>? accommodationTypes,
      Nullable<SubActivityDetails?>? subActivityDetails,
      IsicActivity? selectedIsicActivity,
      Nullable<SubActivityEntity?>? selectedSubActivity,
        LookupsModel? selectedAccommodationType,
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
      String? unitCount,
      bool? atmFeesPaid,
      bool? draftLoaded,
        final GISResponse? gisResponse,
        final GISParams? location,
        final GISParams? userLocation,
        final bool? isLocationAllowed,
        final bool? readOnly,
        final int? requestNo,
        final SaveLocationResponse? locationResponse,
        final String? landNo,
        final String? mapNo,

      }) {
    return Step2ActivityDataExportState(
        status: status ?? this.status,
        subActivitiesStatus: subActivitiesStatus ?? this.subActivitiesStatus,
        accommodationTypesStatus:
            accommodationTypesStatus ?? this.accommodationTypesStatus,
        subActivityDetailsStatus:
            subActivityDetailsStatus ?? this.subActivityDetailsStatus,
        subActivities: subActivities ?? this.subActivities,
        accommodationTypes: accommodationTypes ?? this.accommodationTypes,
        subActivityDetails: subActivityDetails == null
            ? this.subActivityDetails
            : subActivityDetails.value,
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
            : addetionalDetails.value,
        unitCount: unitCount ?? this.unitCount,
        atmFeesPaid: atmFeesPaid ?? this.atmFeesPaid,
        draftLoaded: draftLoaded ?? this.draftLoaded,
        draftStatus: draftStatus ?? this.draftStatus,


      gisResponse: gisResponse ?? this.gisResponse,
      location: location ?? this.location,
      userLocation: userLocation ?? this.userLocation,
      isLocationAllowed: isLocationAllowed ?? this.isLocationAllowed,
      readOnly: readOnly ?? this.readOnly,
      requestNo: requestNo ?? this.requestNo,
      locationResponse: locationResponse ?? this.locationResponse,
      landNo: landNo ?? this.landNo,
      mapNo: mapNo ?? this.mapNo,

    );
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
        selectedSubActivity != null && gisResponse != null &&
        landNo != null &&
        landNo!.trim().isNotEmpty &&
        mapNo != null &&
        mapNo!.trim().isNotEmpty; ;
  }

  bool showHotel() {
    return subActivityDetails?.mainActivity?.id == 24;
  }

  bool showAtm() {
    return selectedIsicActivity?.atmActivity == true;
  }

  double getTotalArea() {
    double total = totalArea ?? 0;

    selectedAddetionalList?.forEach((element) {
      total -= (element.area ?? 0);
    });

    return total;
  }
}

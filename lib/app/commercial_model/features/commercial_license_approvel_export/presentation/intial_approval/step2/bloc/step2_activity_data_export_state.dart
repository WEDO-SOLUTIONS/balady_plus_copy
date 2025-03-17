part of 'step2_activity_data_export_cubit.dart';

class Step2ActivityDataExportState extends Equatable {
  final BlocStatus subActivitiesStatus;
  final BlocStatus accommodationTypesStatus;
  final BlocStatus subActivityDetailsStatus;
  final BlocStatus status;

  final List<SubActivityEntity> subActivities;
  final List<LookupsModel>? accommodationTypes;
  final SubActivityDetailsData? subActivityDetails;
  final IsicsMainActivity? selectedIsicActivity;
  final SubActivityEntity? selectedSubActivity;
  final LookupsModel? selectedAccommodationType;
  final String errorMessage;
  final double? totalArea;
  final int? unitCount;
  final WorkerTypes? selectedWorkerType;
  final List<AllowedActivities>? lstAddetionalActivityItems;

 // final List<AddetionalActivityItemDetails>? addetionalActivityItemDetails;

  final BlocStatus addetionalActivityListStatus;
  final BlocStatus addetionalActivityDetailsListStatus;
  final List<AddetionalActivityRequest>? lstSelectedAddetionalActivity;
  final AllowedActivities? userSelectedAddetionalItem;
 // final AddetionalActivityItemDetails? addetionalDetailsItem;

  //final SubActivityDetailsData? addetionalDetails;
  final bool? atmFeesPaid;
  final bool? isDraft;
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
  final String? splNotification;


   Step2ActivityDataExportState(
      {this.subActivitiesStatus = BlocStatus.initial,
      this.accommodationTypesStatus = BlocStatus.initial,
      this.draftStatus = BlocStatus.initial,
      this.subActivityDetailsStatus = BlocStatus.initial,
      this.addetionalActivityListStatus = BlocStatus.initial,
      this.addetionalActivityDetailsListStatus = BlocStatus.initial,
      this.lstAddetionalActivityItems,
      //this.addetionalActivityItemDetails,
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
      this.selectedWorkerType,
      this.lstSelectedAddetionalActivity,
      this.userSelectedAddetionalItem,
      this.atmFeesPaid,
      this.isDraft,
        this.gisResponse,
        this.location,
        this.userLocation,
        this.isLocationAllowed = true,
        this.readOnly = false,
        this.locationResponse,
        this.requestNo,
        this.landNo,
        this.mapNo,
        this.splNotification

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
        selectedWorkerType,
        status,
        unitCount,
        addetionalActivityListStatus,
        addetionalActivityDetailsListStatus,
        userSelectedAddetionalItem,
        // addetionalDetailsItem,
        // addetionalDetails,
        atmFeesPaid,
        isDraft,
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
    splNotification,
    lstSelectedAddetionalActivity
      ];

  Step2ActivityDataExportState copyWith(
      {BlocStatus? subActivitiesStatus,
      BlocStatus? accommodationTypesStatus,
      BlocStatus? subActivityDetailsStatus,
      BlocStatus? status,
      BlocStatus? draftStatus,
      List<SubActivityEntity>? subActivities,

      Nullable<SubActivityDetailsData?>? subActivityDetails,
        Nullable<IsicsMainActivity?>? selectedIsicActivity,
      List<LookupsModel>? accommodationTypes,
      Nullable<SubActivityEntity?>? selectedSubActivity,
        Nullable<LookupsModel?>?   selectedAccommodationType,
      String? errorMessage,
      double? totalArea,
        Nullable< WorkerTypes?>? selectedWorkerType,
      List<AllowedActivities>? lstAddetionalActivities,

      BlocStatus? additionalActivityListStatus,
      BlocStatus? addetionalActivityDetailsListStatus,
      Nullable<List<AddetionalActivityRequest>?>? lstSelectedAddetionalActivities,
      Nullable<AllowedActivities?>? userSelectedAddetionalItem,


      int? unitCount,
      bool? atmFeesPaid,
      bool? isDraft,
        final GISResponse? gisResponse,
        final GISParams? location,
        final GISParams? userLocation,
        final bool? isLocationAllowed,
        final bool? readOnly,
        final int? requestNo,
        final SaveLocationResponse? locationResponse,
        final String? landNo,
        final String? mapNo,
        final String? splNotification,


      }) {
    return Step2ActivityDataExportState(
        status: status ?? this.status,
        subActivitiesStatus: subActivitiesStatus ?? this.subActivitiesStatus,
        accommodationTypesStatus:
            accommodationTypesStatus ?? this.accommodationTypesStatus,
        subActivityDetailsStatus:
            subActivityDetailsStatus ?? this.subActivityDetailsStatus,
        subActivities: subActivities ?? this.subActivities,
        accommodationTypes: accommodationTypes  ?? this.accommodationTypes,
        subActivityDetails: subActivityDetails == null
            ? this.subActivityDetails
            : subActivityDetails.value,
        selectedIsicActivity: selectedIsicActivity == null ? this.selectedIsicActivity:selectedIsicActivity.value,
        selectedSubActivity: selectedSubActivity == null
            ? this.selectedSubActivity
            : selectedSubActivity.value,
        selectedAccommodationType:
            selectedAccommodationType == null ? this.selectedAccommodationType:selectedAccommodationType.value,
        errorMessage: errorMessage ?? this.errorMessage,
        totalArea: totalArea ?? this.totalArea,
        selectedWorkerType: selectedWorkerType == null? this.selectedWorkerType: selectedWorkerType.value,
        lstAddetionalActivityItems:
            lstAddetionalActivities ?? this.lstAddetionalActivityItems,
        // addetionalActivityItemDetails:
        //     addetionalActivityItemDetails ?? this.addetionalActivityItemDetails,
        addetionalActivityListStatus:
            additionalActivityListStatus ?? this.addetionalActivityListStatus,
        addetionalActivityDetailsListStatus:
            addetionalActivityDetailsListStatus ??
                this.addetionalActivityDetailsListStatus,
        lstSelectedAddetionalActivity: lstSelectedAddetionalActivities == null ? this.lstSelectedAddetionalActivity : lstSelectedAddetionalActivities.value,
        userSelectedAddetionalItem:
            userSelectedAddetionalItem == null ? this.userSelectedAddetionalItem : userSelectedAddetionalItem.value,
        // addetionalDetailsItem: addetionalDetailsItem == null
        //     ? this.addetionalDetailsItem
        //     : addetionalDetailsItem.value,
        // addetionalDetails: addetionalDetails == null
        //     ? this.addetionalDetails
        //     : addetionalDetails.value,
        unitCount: unitCount ?? this.unitCount,
        atmFeesPaid: atmFeesPaid ?? this.atmFeesPaid,
        isDraft: isDraft ?? this.isDraft,
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
        splNotification:splNotification??this.splNotification,


    );
  }

  List<AllowedActivities> getAddetionalActivityItems() {
    List<AllowedActivities> items = [];

    lstAddetionalActivityItems?.forEach((element) {
      var isAdded = false;
      lstSelectedAddetionalActivity?.forEach((e) {
        if (element.id ==  e.item!.isicCode!) {
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

    return (selectedWorkerType != null && selectedIsicActivity != null &&
        selectedSubActivity != null && gisResponse != null &&
        landNo != null &&
        landNo!.trim().isNotEmpty &&
        mapNo != null &&
        mapNo!.trim().isNotEmpty) &&(showArea()==true? totalArea != null && totalArea != 0 && checkMinMaxArea():true); ;
  }

  bool showHotel() {
    return subActivityDetails?.showHotelSection==true;
  }
  bool checkMinMaxArea()
  {
    if(totalArea != null && subActivityDetails != null&& subActivityDetails!.minArea != null)
      {
        if(totalArea! <subActivityDetails!.minArea!)
          return false;
      }
    if(totalArea != null && subActivityDetails != null&& subActivityDetails!.maxArea != null)
    {
      if(totalArea! >subActivityDetails!.maxArea!)
        return false;
    }
    return true;
  }

  bool showArea() {
    return subActivityDetails?.showAreaSection==true;
  }

  bool showAtm() {
    return subActivityDetails?.showAtmSection == true;
  }

  double getTotalArea() {
    double total = totalArea ?? 0;

    lstSelectedAddetionalActivity?.forEach((element) {
      total -= (element.area ?? 0);
    });

    return total;
  }
}

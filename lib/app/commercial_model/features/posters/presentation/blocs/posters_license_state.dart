part of 'posters_license_bloc.dart';

class PostersLicenseState extends Equatable {
  final int? groupId;
  final BlocStatus status;
  final BlocStatus detailsStatus;
  final BlocStatus posterTypesStatus;
  final BlocStatus alertsStatus;

  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;
  final String? error;

  final bool? isDraft;
  final List<PermitsLicensesItem>? permitsLiceses;
  final List<PermitsLicensesItem>? selectedLicenses;
  final List<PosterItem>? posters;

  final PosterViewConfigs? posterViewConfigs;
  final String? startDate;
  final String? duration;
  final List<PermitPosterTypeItem>? posterTypes;
  final PosterRequestDetailsModel? requestDetails;
  final List<PermitGroupItem>? permitGroups;
  final List<PermitAlertItem>? alerts;
  final int? licenseId;
  final bool? agreement;
  final PermitLicenseRequestParams searchedParams;
  const PostersLicenseState({
    this.status = BlocStatus.initial,
    this.detailsStatus = BlocStatus.initial,
    this.posterTypesStatus = BlocStatus.initial,
    this.alertsStatus = BlocStatus.initial,
    required this.searchedParams,
    this.licenseId,
    this.groupId,
    this.posterTypes,
    this.currentPageValue = 0,
    this.posters,
    this.posterViewConfigs,
    this.requestId,
    this.isDraft,
    this.error,
    this.permitsLiceses,
    this.selectedLicenses,
    this.startDate,
    this.duration,
    this.requestDetails,
    this.permitGroups,
    this.alerts,
    this.agreement,
    this.pagesList = const [
      PostersStep1Page(),
      PostersStep2Page(),
      PostersStep3Page(),
    ],
  });

  @override
  List<Object?> get props => [
        status,
        detailsStatus,
        currentPageValue,
        pagesList,
        requestId,
        isDraft,
        error,
        permitsLiceses,
        selectedLicenses,
        startDate,
        duration,
        posterViewConfigs,
        posters,
        posterTypesStatus,
        posterTypes,
        requestDetails,
        permitGroups,
        groupId,
        alertsStatus,
        alerts,
        licenseId,
        agreement,
        searchedParams
      ];

  PostersLicenseState copyWith(
      {BlocStatus? status,
      BlocStatus? posterTypesStatus,
      BlocStatus? detailsStatus,
      BlocStatus? alertsStatus,
      int? currentPageValue,
      List<Widget>? pagesList,
      Nullable<int?>? requestId,
      String? selectedPeriod,
      bool? isDraft,
        PosterViewConfigs? posterViewConfigs,
      List<PermitsLicensesItem>? permitsLiceses,
      List<PermitsLicensesItem>? selectedLicenses,
      List<PosterItem>? posters,
      String? error,
      String? startDate,
      String? duration,
      List<PermitPosterTypeItem>? posterTypes,
      PosterRequestDetailsModel? requestDetails,
      List<PermitGroupItem>? permitGroups,
      List<PermitAlertItem>? alerts,
      int? groupId,
      int? licenseId,
      bool? agreement,
      PermitLicenseRequestParams? searchedParams}) {
    return PostersLicenseState(
        status: status ?? this.status,
        alertsStatus: alertsStatus ?? this.alertsStatus,
        detailsStatus: detailsStatus ?? this.detailsStatus,
        posterTypesStatus: posterTypesStatus ?? this.posterTypesStatus,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        pagesList: pagesList ?? this.pagesList,
        requestId: requestId == null ? this.requestId : requestId.value,
        isDraft: isDraft ?? this.isDraft,
        posterViewConfigs:posterViewConfigs??this.posterViewConfigs,
        permitsLiceses: permitsLiceses ?? this.permitsLiceses,
        selectedLicenses: selectedLicenses ?? this.selectedLicenses,
        error: error ?? this.error,
        startDate: startDate ?? this.startDate,
        duration: duration ?? this.duration,
        posters: posters ?? this.posters,
        posterTypes: posterTypes ?? this.posterTypes,
        requestDetails: requestDetails ?? this.requestDetails,
        permitGroups: permitGroups ?? this.permitGroups,
        groupId: groupId ?? this.groupId,
        alerts: alerts ?? this.alerts,
        licenseId: licenseId ?? this.licenseId,
        agreement: agreement ?? this.agreement,
        searchedParams: searchedParams ?? this.searchedParams);
  }

  String totalPostersArea() {
    double totalArea = 0;
    posters?.forEach((e) {
      totalArea = totalArea + ((e.length ?? 0) * (e.width ?? 0));
    });
    return totalArea.toString();
  }

  String totalPostersCount() {
    return posters?.length.toString() ?? "";
  }

  String? ALERT_CALCULATION_DEPENDS_ON_MUNICIPALITY() => alerts
      ?.firstWhereOrNull((element) =>
          element.id == "ALERT_CALCULATION_DEPENDS_ON_MUNICIPALITY")
      ?.name;

  String? ALERT_SERVICE_USAGE_GUIDANCE() => alerts
      ?.firstWhereOrNull(
          (element) => element.id == "ALERT_SERVICE_USAGE_GUIDANCE")
      ?.name;

  bool isStep2Valid() {
    if (startDate == null ||
        duration == null ||
        (duration?.isEmpty ?? true) ||
        (posters?.length ?? 0) <= 0) {
      return false;
    }
    return true;
  }

 String? getPosterMessaage(PermitPosterTypeItem posterType)
  {
    if(posterViewConfigs?.posterTypes != null ) {
      PosterTypes? poster = posterViewConfigs?.posterTypes!.firstWhereOrNull((item) =>
      item.id == posterType.id);
      if(poster != null) {
        return posterViewConfigs?.message;
      }
      else
        {
          return null;
        }
    }
    return null;

  }
}

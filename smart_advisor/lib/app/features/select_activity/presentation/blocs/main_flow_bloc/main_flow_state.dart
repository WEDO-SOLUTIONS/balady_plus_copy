part of 'main_flow_bloc.dart';

class MainFlowState extends Equatable {
  final LookUpItem? selectedSector;
  final LookUpItem? selectedCategory;
  final LookUpItem? selectedRubric;

  final LookUpItem? selectedIsic;
  final LookUpItem? selectedActivity;

  final GISDataRequest? request;
  final GisDataResponse? gisResponse;

  final BlocStatus activitesStatus;
  final List<LookUpItem>? activites;
  final BlocStatus isicsStatus;
  final List<LookUpItem>? isics;
  final String? errorMessage;

  final BlocStatus addetionalActivitesStatus;
  final BlocStatus status;

  final List<AddetionalActivityItem>? addetionalActivitesResponse;
  final BlocStatus categoriesStatus;
  final List<LookUpItem>? categories;

  final BlocStatus permitsStatus;
  final List<PermitItem>? permits;

  final BlocStatus rubricsStatus;
  final List<LookUpItem>? rubrics;

  final BlocStatus sectorStatus;
  final List<LookUpItem>? sectors;

  final SuggestedAreaModel? selectedArea;
  final int currentPage;

  final LookUpItem? selectedCity;
  final LookUpItem? selectedDistrict;
  final List<LookUpItem>? cities;
  final List<LookUpItem>? districts;

  final BlocStatus citiesStatus;
  final BlocStatus districtsStatus;
  final BlocStatus workFlowStatus;

  final String? locationOption;

  final String? contractType;
  final String? contractOption;
  final String? atmOption;
  final List<WorkFlowModel>? workFlow;
  final BlocStatus detailsStatus;
  final EntityActivityDetailsResponse? details;
  final List<ActivityCount>? isicsCount;
  final List<ActivityCount>? detailedCount;
  final List<ActivityCount>? categoryCount;
  final int? step1Selection;
  final BlocStatus activityDetailsStatus;
  final BlocStatus delegatorsStatus;
  final List<DelegatorEntity>? delegators;
  final DelegatorEntity? selectedDelegator;
  final List<LicensesResponseItem>? licenses;
  final LicensesResponseItem? selectedLicense;
  final BlocStatus licenseStatus;
  final int? raingSelectScenario;
  final BlocStatus licenseDetailsStatus;
  final LicenseDetails? selectedLicenseDetails;
  final int? area;
  final int? shopArea;

  final String? unitCount;
  final LookUpItem? acomodationType;
  final LookUpItem? workerType;

  const MainFlowState(
      {this.step1Selection,
      this.isicsCount,
      this.categoryCount,
      this.detailedCount,
      this.details,
      this.workFlow,
      this.contractOption,
      this.contractType,
      this.locationOption,
      this.citiesStatus = BlocStatus.initial,
      this.districtsStatus = BlocStatus.initial,
      this.workFlowStatus = BlocStatus.initial,
      this.detailsStatus = BlocStatus.initial,
      this.activityDetailsStatus = BlocStatus.initial,
      this.licenseDetailsStatus = BlocStatus.initial,
      this.cities,
      this.districts,
      this.selectedCity,
      this.selectedDistrict,
      this.selectedArea,
      this.selectedSector,
      this.selectedCategory,
      this.selectedRubric,
      this.selectedIsic,
      this.selectedActivity,
      this.isicsStatus = BlocStatus.initial,
      this.isics,
      this.activitesStatus = BlocStatus.initial,
      this.activites,
      this.errorMessage,
      this.addetionalActivitesStatus = BlocStatus.initial,
      this.status = BlocStatus.initial,
      this.addetionalActivitesResponse,
      this.categoriesStatus = BlocStatus.initial,
      this.categories,
      this.permitsStatus = BlocStatus.initial,
      this.permits,
      this.rubricsStatus = BlocStatus.initial,
      this.rubrics,
      this.sectorStatus = BlocStatus.initial,
      this.sectors,
      this.currentPage = 0,
      this.request,
      this.gisResponse,
      this.atmOption,
      this.delegatorsStatus = BlocStatus.initial,
      this.delegators,
      this.selectedDelegator,
      this.licenses,
      this.selectedLicense,
      this.licenseStatus = BlocStatus.initial,
      this.raingSelectScenario,
      this.selectedLicenseDetails,
      this.area,
      this.shopArea,
      this.unitCount,
      this.acomodationType,
      this.workerType});

  @override
  List<Object?> get props => [
        activityDetailsStatus,
        categoryCount,
        step1Selection,
        isicsCount,
        detailedCount,
        details,
        detailsStatus,
        workFlow,
        atmOption,
        workFlowStatus,
        contractType,
        contractOption,
        locationOption,
        citiesStatus,
        districtsStatus,
        cities,
        districts,
        selectedCity,
        selectedDistrict,
        selectedArea,
        isicsStatus,
        isics,
        activitesStatus,
        activites,
        errorMessage,
        addetionalActivitesStatus,
        addetionalActivitesResponse,
        status,
        categoriesStatus,
        categories,
        permitsStatus,
        permits,
        rubricsStatus,
        rubrics,
        sectorStatus,
        sectors,
        currentPage,
        selectedSector,
        selectedCategory,
        selectedRubric,
        selectedActivity,
        selectedIsic,
        gisResponse,
        request,
        citiesStatus,
        districtsStatus,
        delegatorsStatus,
        delegators,
        selectedDelegator,
        licenses,
        selectedLicense,
        licenseStatus,
        raingSelectScenario,
        licenseDetailsStatus,
        selectedLicenseDetails,
        area,
        shopArea,
        unitCount,
        acomodationType,
        workerType
      ];

  MainFlowState copyWith(
      {final BlocStatus? activityDetailsStatus,
      final List<ActivityCount>? categoryCount,
      final int? step1Selection,
      final List<ActivityCount>? isicsCount,
      final List<ActivityCount>? detailedCount,
      final EntityActivityDetailsResponse? details,
      final BlocStatus? detailsStatus,
      final List<WorkFlowModel>? workFlow,
      final BlocStatus? workFlowStatus,
      final String? atmOption,
      final String? contractType,
      final String? contractOption,
      final LookUpItem? selectedSector,
      final LookUpItem? selectedCategory,
      final LookUpItem? selectedRubric,
      final LookUpItem? selectedIsic,
      final LookUpItem? selectedActivity,
      final SuggestedAreaModel? selectedArea,
      final LookUpItem? selectedCity,
      final LookUpItem? selectedDistrict,
      final List<LookUpItem>? cities,
      final List<LookUpItem>? districts,
      BlocStatus? isicsStatus,
      List<LookUpItem>? isics,
      BlocStatus? activitesStatus,
      List<LookUpItem>? activites,
      String? errorMessage,
      BlocStatus? addetionalActivitesStatus,
      List<AddetionalActivityItem>? addetionalActivitesResponse,
      BlocStatus? status,
      BlocStatus? categoriesStatus,
      List<LookUpItem>? categories,
      BlocStatus? permitsStatus,
      List<PermitItem>? permits,
      ActivityDetailsPageParams? args,
      BlocStatus? rubricsStatus,
      List<LookUpItem>? rubrics,
      BlocStatus? sectorStatus,
      List<LookUpItem>? sectors,
      int? currentPage,
      GISDataRequest? request,
      GisDataResponse? gisResponse,
      BlocStatus? citiesStatus,
      BlocStatus? districtsStatus,
      bool? clearDistrict,
      String? locationOption,
      final BlocStatus? delegatorsStatus,
      final List<DelegatorEntity>? delegators,
      final DelegatorEntity? selectedDelegator,
      final List<LicensesResponseItem>? licenses,
      final LicensesResponseItem? selectedLicense,
      final BlocStatus? licenseStatus,
      final int? raingSelectScenario,
      final BlocStatus? licenseDetailsStatus,
      final LicenseDetails? selectedLicenseDetails,
      final int? area,
      final int? shopArea,
      final String? unitCount,
      final LookUpItem? acomodationType,
      final LookUpItem? workerType}) {
    return MainFlowState(
        workerType: workerType ?? this.workerType,
        unitCount: unitCount ?? this.unitCount,
        acomodationType: acomodationType ?? this.acomodationType,
        delegatorsStatus: delegatorsStatus ?? this.delegatorsStatus,
        delegators: delegators ?? this.delegators,
        selectedDelegator: selectedDelegator ?? this.selectedDelegator,
        licenses: licenses ?? this.licenses,
        selectedLicense: selectedLicense ?? this.selectedLicense,
        licenseStatus: licenseStatus ?? this.licenseStatus,
        activityDetailsStatus:
            activityDetailsStatus ?? this.activityDetailsStatus,
        categoryCount: categoryCount ?? this.categoryCount,
        step1Selection: step1Selection ?? this.step1Selection,
        isicsCount: isicsCount ?? this.isicsCount,
        detailedCount: detailedCount ?? this.detailedCount,
        details: details ?? this.details,
        detailsStatus: detailsStatus ?? this.detailsStatus,
        workFlow: workFlow ?? this.workFlow,
        workFlowStatus: workFlowStatus ?? this.workFlowStatus,
        atmOption: atmOption ?? this.atmOption,
        contractType: contractType ?? this.contractType,
        contractOption: contractOption ?? this.contractOption,
        locationOption: locationOption ?? this.locationOption,
        citiesStatus: citiesStatus ?? this.citiesStatus,
        districtsStatus: districtsStatus ?? this.districtsStatus,
        selectedCity: selectedCity ?? this.selectedCity,
        selectedDistrict: clearDistrict == true
            ? null
            : selectedDistrict ?? this.selectedDistrict,
        cities: cities ?? this.cities,
        districts: districts ?? this.districts,
        selectedArea: selectedArea ?? this.selectedArea,
        request: request ?? this.request,
        gisResponse: gisResponse ?? this.gisResponse,
        selectedSector: selectedSector ?? this.selectedSector,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        selectedRubric: selectedRubric ?? this.selectedRubric,
        currentPage: currentPage ?? this.currentPage,
        activitesStatus: activitesStatus ?? this.activitesStatus,
        activites: activites ?? this.activites,
        isicsStatus: isicsStatus ?? this.isicsStatus,
        isics: isics ?? this.isics,
        errorMessage: errorMessage,
        addetionalActivitesStatus:
            addetionalActivitesStatus ?? this.addetionalActivitesStatus,
        addetionalActivitesResponse:
            addetionalActivitesResponse ?? this.addetionalActivitesResponse,
        status: status ?? this.status,
        categoriesStatus: categoriesStatus ?? this.categoriesStatus,
        categories: categories ?? this.categories,
        permitsStatus: permitsStatus ?? this.permitsStatus,
        permits: permits ?? this.permits,
        rubricsStatus: rubricsStatus ?? this.rubricsStatus,
        rubrics: rubrics ?? this.rubrics,
        sectorStatus: sectorStatus ?? this.sectorStatus,
        sectors: sectors ?? this.sectors,
        selectedIsic: selectedIsic ?? this.selectedIsic,
        selectedActivity: selectedActivity ?? this.selectedActivity,
        raingSelectScenario: raingSelectScenario ?? this.raingSelectScenario,
        licenseDetailsStatus: licenseDetailsStatus ?? this.licenseDetailsStatus,
        selectedLicenseDetails:
            selectedLicenseDetails ?? this.selectedLicenseDetails,
        area: area ?? this.area,
        shopArea: shopArea ?? this.shopArea);
  }

  Map<String, List<PermitItem>> getPermits() {
    Map<String, List<PermitItem>> permitsLists = {};

    permits?.forEach((e) {
      if (permitsLists.containsKey(e.detailedActivityId.toString())) {
        permitsLists[e.detailedActivityId.toString()]!.add(e);
      } else {
        permitsLists[e.detailedActivityId!.toString()] = [];
        permitsLists[e.detailedActivityId.toString()]!.add(e);
      }
    });

    return permitsLists;
  }

  bool isNextDisabled() {
    if (workFlowStatus == BlocStatus.loading || status == BlocStatus.loading)
      return true;
    // if (currentPage == 1 && selectedSector == null) return true;
    if (currentPage == 0 &&
        raingSelectScenario == 1 &&
        step1Selection == 1 &&
        selectedDelegator == null) return true;
    if (currentPage == 1 &&
        step1Selection == 1 &&
        raingSelectScenario == 1 &&
        (selectedLicense != null)) return false;

    if (currentPage == 0 && step1Selection == null) return true;
    if (currentPage == 1 && selectedSector == null) return true;
    if (currentPage == 2 && selectedCategory == null) return true;
    // if (currentPage == 3 && selectedIsic == null) return true;
    if (currentPage == 3 && selectedActivity == null) return true;
    if (currentPage == 5 && gisResponse == null) return true;
    if (currentPage == 7 && selectedArea == null) return true;
    if (currentPage == 8 &&
        ((contractOption?.isEmpty ?? true) ||
            (contractOption?.isEmpty ?? true))) return true;
    if (currentPage == 10 && ((atmOption?.isEmpty ?? true))) return true;
    //if (currentPage == 4 && selectedActivity == null) return true;

    return false;
  }

  List<SuggestedAreaModel> suggestedAreas() {
    return [
      SuggestedAreaModel(
        id: 1,
        desc: 'مساحة صغيرة جدًا، مناسبة للأكشاك الصغيرة أو المحلات الصغيرة',
        to: 24,
        isActive: isAnyNumberInRange(
            0,
            23,
            (selectedActivity?.minArea ?? 0).toInt(),
            (selectedActivity?.maxArea ?? 0).toInt()),
      ),
      SuggestedAreaModel(
        id: 2,
        desc: 'مساحة صغيرة إلى متوسطة، مثالية للمحلات التجارية الصغيرة',
        from: 24,
        to: 100,
        isActive: isAnyNumberInRange(
            24,
            100,
            (selectedActivity?.minArea ?? 0).toInt(),
            (selectedActivity?.maxArea ?? 0).toInt()),
      ),
      SuggestedAreaModel(
        id: 3,
        desc: 'مساحة متوسطة إلى كبيرة، مناسبة للمحلات الأكبر حجمًا ',
        from: 101,
        to: 500,
        isActive: isAnyNumberInRange(
            101,
            500,
            (selectedActivity?.minArea ?? 0).toInt(),
            (selectedActivity?.maxArea ?? 0).toInt()),
      ),
      SuggestedAreaModel(
        id: 4,
        desc:
            'مساحة كبيرة، مثالية لمحلات السوبرماركت الكبيرة، متاجر الأجهزة الكهربائية',
        from: 501,
        to: 1000,
        isActive: isAnyNumberInRange(
            501,
            1000,
            (selectedActivity?.minArea ?? 0).toInt(),
            (selectedActivity?.maxArea ?? 0).toInt()),
      ),
      SuggestedAreaModel(
        id: 5,
        desc:
            'مساحة كبيرة جدًا، مناسبة للأسواق المركزية، محلات الأثاث، أو صالات العرض. ',
        from: 1001,
        to: 3000,
        isActive: isAnyNumberInRange(
            1001,
            3000,
            (selectedActivity?.minArea ?? 0).toInt(),
            (selectedActivity?.maxArea ?? 0).toInt()),
      ),
      SuggestedAreaModel(
        id: 6,
        desc:
            'مساحة ضخمة، مثالية للمراكز التجارية، محلات السوبرماركت العملاقة، أو المعارض الكبرى.',
        from: 3000,
        isActive: isAnyNumberInRange(
            3000,
            100000,
            (selectedActivity?.minArea ?? 0).toInt(),
            (selectedActivity?.maxArea ?? 0).toInt()),
      ),
    ].where((e) => e.isActive == true).toList();
  }

  bool isRangeWithin(double start1, double end1, double start2, double end2) {
    // Check if the start and end of the first range are within the second range
    return start1 >= start2 && end1 <= end2;
  }

  bool isAnyNumberInRange(int x, int y, int range1, int range2) {
    // Ensure x is less than y and range1 is less than range2
    int start = x < y ? x : y;
    int end = x > y ? x : y;

    int rangeStart = range1 < range2 ? range1 : range2;
    int rangeEnd = range1 > range2 ? range1 : range2;

    // Check if any number in the range (x, y) falls within (range1, range2)
    return (start >= rangeStart && start <= rangeEnd) ||
        (end >= rangeStart && end <= rangeEnd) ||
        (start <= rangeStart && end >= rangeEnd);
  }

  double getTotalArea() {
    return (addetionalActivitesResponse?.isEmpty ?? true)
        ? (double.tryParse(shopArea.toString() ?? "") ?? 0)
        : (double.tryParse(shopArea.toString() ?? "") ?? 0) -
            (addetionalActivitesResponse
                    ?.map((e) =>
                        (e.area ?? 0).toDouble()) // Convert each area to double
                    .reduce((value, element) => value + element) ??
                0);
  }
}

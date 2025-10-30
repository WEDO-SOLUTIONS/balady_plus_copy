part of 'ekram_requests_bloc.dart';

class EkramRequestsState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPage;
  final int? totalItemCount;
  final List<TransportRequestItem>? deceasedRequestItems;
  final String? searchBy;
  final LookUpItem? filterItem;
  final List<LookUpItem>? transferStatusList;

  final List<LookUpItem>? requestStatusList;
  final List<LookUpItem>? locationsList;
  final LookUpItem? requestStatusFilterItem;
  final LookUpItem? locationFilterItem;
  final LookUpItem? cityFilterItem;

  final bool? isDriver;

  final BlocStatus cemetryListStatus;

  final int cemetryCurrentPage;
  final List<CemetryRequestItem>? cemetryRequestItems;

  EkramRequestsState(
      {this.status = BlocStatus.initial,
      this.currentPage = 0,
      this.cemetryListStatus = BlocStatus.initial,
      this.cemetryCurrentPage = 0,
      this.totalItemCount,
      this.errorMessage,
      this.filterItem,
      this.searchBy,
      this.transferStatusList,
      this.deceasedRequestItems,
      this.isDriver,
      this.requestStatusList,
      this.locationsList,
      this.requestStatusFilterItem,
      this.locationFilterItem,
      this.cityFilterItem,
      this.cemetryRequestItems});

  EkramRequestsState copyWith({
    final BlocStatus? status,
    final String? errorMessage,
    final int? currentPage,
    final int? totalItemCount,
    final List<TransportRequestItem>? deceasedRequestItems,
    final String? searchBy,
    final LookUpItem? filterItem,
    final List<LookUpItem>? transferStatusList,
    final bool? isDriver,
    final List<LookUpItem>? requestStatusList,
    final List<LookUpItem>? locationsList,
    final LookUpItem? requestStatusFilterItem,
    final LookUpItem? locationFilterItem,
    final LookUpItem? cityFilterItem,
    final bool? clearFilters,
    final BlocStatus? cemetryListStatus,
    final int? cemetryCurrentPage,
    final List<CemetryRequestItem>? cemetryRequestItems,
  }) {
    return EkramRequestsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalItemCount: totalItemCount ?? this.totalItemCount,
      deceasedRequestItems: deceasedRequestItems ?? this.deceasedRequestItems,
      filterItem: filterItem ?? this.filterItem,
      transferStatusList: transferStatusList ?? this.transferStatusList,
      searchBy: searchBy ?? this.searchBy,
      isDriver: isDriver ?? this.isDriver,
      requestStatusList: requestStatusList ?? this.requestStatusList,
      locationsList: locationsList ?? this.locationsList,
      requestStatusFilterItem: clearFilters == true
          ? null
          : (requestStatusFilterItem ?? this.requestStatusFilterItem),
      locationFilterItem: clearFilters == true
          ? null
          : (locationFilterItem ?? this.locationFilterItem),
      cityFilterItem:
          clearFilters == true ? null : (cityFilterItem ?? this.cityFilterItem),
      cemetryListStatus: cemetryListStatus ?? this.cemetryListStatus,
      cemetryCurrentPage: cemetryCurrentPage ?? this.cemetryCurrentPage,
      cemetryRequestItems: cemetryRequestItems ?? this.cemetryRequestItems,
    );
  }

  bool? isMultiCity() {
    return cityFilterItem?.id != null
        ? (cityFilterItem?.id == 0 ? false : true)
        : null;
  }

  @override
  List<Object?> get props => [
        status,
        deceasedRequestItems,
        currentPage,
        totalItemCount,
        filterItem,
        searchBy,
        isDriver,
        transferStatusList,
        cityFilterItem,
        locationFilterItem,
        requestStatusFilterItem,
        cemetryListStatus,
        cemetryCurrentPage
      ];
}

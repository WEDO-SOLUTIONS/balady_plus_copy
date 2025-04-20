part of 'main_flow_bloc.dart';

abstract class MainFlowEvent extends Equatable {
  const MainFlowEvent();

  @override
  List<Object?> get props => [];
}

class NextPageEvent extends MainFlowEvent {
  const NextPageEvent();
}

class PrevPageEvent extends MainFlowEvent {
  const PrevPageEvent();
}

class ChangeValuesEvent extends MainFlowEvent {
  final LookUpItem? selectedSector;
  final LookUpItem? selectedCategory;
  final LookUpItem? selectedRubric;
  final LookUpItem? isic;
  final LookUpItem? activity;
  final GisDataResponse? gisDataResponse;
  final GISDataRequest? gisDataRequest;
  final SuggestedAreaModel? selectedArea;
  final LookUpItem? district;
  final String? locationOption;
  final String? contractType;
  final String? contractOption;
  final String? atmOption;
  final int? step1Selection;

  final int? raingSelectScenario;
  const ChangeValuesEvent(
      {this.selectedCategory,
      this.selectedRubric,
      this.selectedSector,
      this.activity,
      this.isic,
      this.gisDataResponse,
      this.gisDataRequest,
      this.selectedArea,
      this.district,
      this.locationOption,
      this.contractOption,
      this.contractType,
      this.atmOption,
      this.step1Selection,
      this.raingSelectScenario});
}

class GetActivityInfoDetails extends MainFlowEvent {
  const GetActivityInfoDetails();
}

class GetActivitesEvent extends MainFlowEvent {
  const GetActivitesEvent();
}

class GetAddetionalActivites extends MainFlowEvent {
  const GetAddetionalActivites();
}

class ToggleAddetionalActivity extends MainFlowEvent {
  final int index;
  const ToggleAddetionalActivity({required this.index});
}

class GetCategoriesEvent extends MainFlowEvent {
  const GetCategoriesEvent();
}

class GetIsicsEvent extends MainFlowEvent {
  const GetIsicsEvent();
}

class GetPermitsEvent extends MainFlowEvent {
  const GetPermitsEvent();
}

class TogglePermitEvent extends MainFlowEvent {
  final int index;
  const TogglePermitEvent({required this.index});
}

class GetRubricsEvent extends MainFlowEvent {
  const GetRubricsEvent();
}

class GetSectorEvent extends MainFlowEvent {
  const GetSectorEvent();
}

class GetCitiesEvent extends MainFlowEvent {
  const GetCitiesEvent();
}

class GetDistricts extends MainFlowEvent {
  final LookUpItem city;
  const GetDistricts({required this.city});
}

class GetWorkFlowEvent extends MainFlowEvent {
  const GetWorkFlowEvent();
}

class GetDetailsEvent extends MainFlowEvent {
  const GetDetailsEvent();
}

class GetGISDataEvent extends MainFlowEvent {
  final double lat;
  final double lon;
  final bool? fromRating;

  const GetGISDataEvent(
      {required this.lat, required this.lon, this.fromRating});
}

class GetDelegatorsEvent extends MainFlowEvent {
  const GetDelegatorsEvent();
}

class GetLicensesEvent extends MainFlowEvent {
  final String licenseType;
  const GetLicensesEvent({required this.licenseType});
}

class SelectDelegatorEvent extends MainFlowEvent {
  final DelegatorEntity delegator;
  const SelectDelegatorEvent({required this.delegator});
}

class SelectLicenseEvent extends MainFlowEvent {
  final LicensesResponseItem license;
  const SelectLicenseEvent({required this.license});
}

class ChangeAddetionalActivityEvent extends MainFlowEvent {
  final String area;
  final int index;
  const ChangeAddetionalActivityEvent(
      {required this.area, required this.index});
}

class ChangeAreaValueEvent extends MainFlowEvent {
  final String data;
  const ChangeAreaValueEvent({required this.data});
}

class ChangeShopAreaValueEvent extends MainFlowEvent {
  final String data;
  const ChangeShopAreaValueEvent({required this.data});
}

class ChangeUnitCountEvent extends MainFlowEvent {
  final String data;
  const ChangeUnitCountEvent({required this.data});
}

class ChangeAccomodationTypeEvent extends MainFlowEvent {
  final LookUpItem item;
  const ChangeAccomodationTypeEvent({required this.item});
}

class ChangeWorkerTypeEvent extends MainFlowEvent {
  final LookUpItem item;
  const ChangeWorkerTypeEvent({required this.item});
}

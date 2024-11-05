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
      this.atmOption, this.step1Selection});
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
 const  GetDetailsEvent(); 
}

class GetGISDataEvent extends MainFlowEvent {
  final double lat;
  final double lon;

  const GetGISDataEvent({required this.lat, required this.lon});
}
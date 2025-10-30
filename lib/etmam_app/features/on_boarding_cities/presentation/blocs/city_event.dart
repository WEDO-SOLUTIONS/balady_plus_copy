part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object> get props => [];
}

class GetCitiesEvent extends CityEvent {
  const GetCitiesEvent();
}

class GetMoreCitiesEvent extends CityEvent {
  const GetMoreCitiesEvent();
}

class SelectCityEvent extends CityEvent {
  final CityItem? item;
  final String? subServiceid;
  const SelectCityEvent({this.item, this.subServiceid});
}

class GetLocalCities extends CityEvent {
  const GetLocalCities();
}

class SearchForCityEvent extends CityEvent {
  String? text;
  SearchForCityEvent({this.text});
}

class GetProvidersForASubServiceEvent extends CityEvent {
  final String? subServiceId;
  GetProvidersForASubServiceEvent({this.subServiceId});
}

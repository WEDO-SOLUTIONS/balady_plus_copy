part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object> get props => [];
}

class GetCitiesEvent extends CityEvent {
  const GetCitiesEvent();
}

class SelectCityEvent extends CityEvent {
  final CityItem? item;
  const SelectCityEvent({this.item});
}

class GetLocalCities extends CityEvent {
  const GetLocalCities();
}

class SearchForCityEvent extends CityEvent {
  String? text;
  SearchForCityEvent({this.text});
}

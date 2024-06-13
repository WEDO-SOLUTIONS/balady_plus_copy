part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

class GetServiceDetailsEvent extends ServicesEvent {
  ServiceDetailsParams params;
  GetServiceDetailsEvent({required this.params});
}

class GetRelationsEvent extends ServicesEvent {
  RelationParams params;
  GetRelationsEvent({required this.params});
}

class LoadMoreServices extends ServicesEvent {
  LoadMoreServices();
}

class GetServicesEvent extends ServicesEvent {
  String? name;

  GetServicesEvent({this.name});
}

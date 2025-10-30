part of 'sub_services_bloc.dart';

abstract class SubServicesEvent extends Equatable {
  const SubServicesEvent();

  @override
  List<Object> get props => [];
}

class GetProvidersEvent extends SubServicesEvent {
  ServiceParams params;
  GetProvidersEvent({required this.params});
}

class GetSubServiceEvent_ extends SubServicesEvent {
  SubServiceParams params;
  GetSubServiceEvent_({required this.params});
}

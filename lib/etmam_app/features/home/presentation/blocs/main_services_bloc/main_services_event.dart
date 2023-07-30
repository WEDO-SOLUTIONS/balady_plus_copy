part of 'main_services_bloc.dart';

abstract class MainServicesEvent extends Equatable {
  const MainServicesEvent();

  @override
  List<Object> get props => [];
}

class GetSubServiceEvent extends MainServicesEvent {
  SubServiceParams params;
  GetSubServiceEvent({required this.params});
}

class GetMainServiceEvent extends MainServicesEvent {
  MainServiceParams params;
  GetMainServiceEvent({required this.params});
}

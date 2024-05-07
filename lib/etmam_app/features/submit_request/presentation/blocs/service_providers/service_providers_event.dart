part of 'service_providers_bloc.dart';

abstract class ServiceProvidersEvent extends Equatable {
  const ServiceProvidersEvent();

  @override
  List<Object> get props => [];
}

class SelectServiceProviderinitialEvent extends ServiceProvidersEvent {
  SelectServiceProviderinitialEvent();
}

class SelectServiceProviderEvent extends ServiceProvidersEvent {
  int index;
  SelectServiceProviderEvent({required this.index});
}

class LoadMoreServices extends ServiceProvidersEvent {
  LoadMoreServices();
}

class GetServicesReleationsEvent extends ServiceProvidersEvent {
  String? name;
  GetServicesReleationsEvent({this.name});
}

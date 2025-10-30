part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetMainServicesEvent extends HomeEvent {
  MainServiceParams params;
  GetMainServicesEvent({required this.params});
}

class GetTopRatedProvidersEvent extends HomeEvent {
  TopRatedProviderParams params;
  GetTopRatedProvidersEvent({required this.params});
}

class GetTopOrderedSubServicesEvent extends HomeEvent {
  TopOrderedSubServiceParams params;
  GetTopOrderedSubServicesEvent({required this.params});
}

class GetSubServicesEvent extends HomeEvent {
  SubServiceParams params;
  GetSubServicesEvent({required this.params});
}

class GetProviders extends HomeEvent {
  ServiceParams params;
  GetProviders({required this.params});
}

class ChangeCityEvent extends HomeEvent {
  ChangeCityEvent();
}

class GetProviderDetailsEvent extends HomeEvent {
  ProviderDetailsParams params;
  GetProviderDetailsEvent({required this.params});
}

class GetAdsEvent extends HomeEvent {
  GetAdsEvent();
}

class FindByRequestTypeEvent extends HomeEvent {
  const FindByRequestTypeEvent();
}

class FindByRequestTypeEventChangedCity extends HomeEvent {
  const FindByRequestTypeEventChangedCity();
}

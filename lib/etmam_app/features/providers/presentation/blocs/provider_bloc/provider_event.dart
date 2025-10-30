part of 'provider_bloc.dart';

abstract class ProvidersEvent extends Equatable {
  const ProvidersEvent();

  @override
  List<Object> get props => [];
}

class GetTopProvidersEvent extends ProvidersEvent {
  TopRatedProviderParams params;
  GetTopProvidersEvent({required this.params});
}

class GetPRoviderDetailsEvent extends ProvidersEvent {
  ProviderDetailsParams params;
  GetPRoviderDetailsEvent({required this.params});
}

class LoadMoreProviders extends ProvidersEvent {
  const LoadMoreProviders();
}

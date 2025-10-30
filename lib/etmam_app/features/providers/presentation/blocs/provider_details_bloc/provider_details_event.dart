part of 'provider_details_bloc.dart';

abstract class ProviderDetailsEvent extends Equatable {
  const ProviderDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetServiceDetailsEvent extends ProviderDetailsEvent {
  ServiceDetailsParams params;
  GetServiceDetailsEvent({required this.params});
}

part of 'service_details_bloc.dart';

abstract class ServiceDetailsEvent extends Equatable {
  const ServiceDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetRelationsForDetailsEvent extends ServiceDetailsEvent {
  RelationParams params;
  GetRelationsForDetailsEvent({required this.params});
}

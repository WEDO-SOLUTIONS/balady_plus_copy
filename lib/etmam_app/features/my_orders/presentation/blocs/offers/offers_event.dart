part of 'offers_bloc.dart';

abstract class OffersEvent extends Equatable {
  const OffersEvent();

  @override
  List<Object> get props => [];
}

class GetOffersEvent extends OffersEvent {
  final RequestRepliesModel? request;
  final String? type;
  GetOffersEvent({this.request, this.type});
}

class AcceptOfferEvent extends OffersEvent {
  final String? id;
  AcceptOfferEvent({this.id});
}

class RejectOfferEvent extends OffersEvent {
  final String? id;
  RejectOfferEvent({this.id});
}

class ChangeOfferServiceEvent extends OffersEvent {
  final RequestRepliesModel? request;
  ChangeOfferServiceEvent({this.request});
}

class GetPRoviderDetailsEvent extends OffersEvent {
  ProviderDetailsParams params;
  GetPRoviderDetailsEvent({required this.params});
}

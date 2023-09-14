part of 'request_details_bloc.dart';

abstract class RequestDetailsEvent extends Equatable {
  const RequestDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetProvidersEvent extends RequestDetailsEvent {
  String? orderId;
  ServiceParams params;
  GetProvidersEvent({required this.params, required this.orderId});
}

class ShowActionsEvent extends RequestDetailsEvent {
  ActionParams params;

  ShowActionsEvent({required this.params});
}

class GetFormViewEvent extends RequestDetailsEvent {
  GetFormViewEvent();
}

class RefreshPageHandlerEvent extends RequestDetailsEvent {
  RefreshPageHandlerEvent();
}

class SubmitOrderEvent extends RequestDetailsEvent {
  SubmitOrderEvent();
}

class CancelRequestEvent extends RequestDetailsEvent {
  CancelRequestEvent();
}

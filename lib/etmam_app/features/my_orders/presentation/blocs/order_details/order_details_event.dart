part of 'order_details_bloc.dart';

abstract class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetProvidersEvent extends OrderDetailsEvent {
  String? orderId;
  ServiceParams params;
  GetProvidersEvent({required this.params, required this.orderId});
}

class ShowActionsEvent extends OrderDetailsEvent {
  ActionParams params;

  ShowActionsEvent({required this.params});
}

class RefreshPageHandlerEvent extends OrderDetailsEvent {
  RefreshPageHandlerEvent();
}

class GetFormViewEvent extends OrderDetailsEvent {
  GetFormViewEvent();
}

part of 'my_requests_bloc.dart';

abstract class MyRequestsEvent extends Equatable {
  const MyRequestsEvent();

  @override
  List<Object> get props => [];
}

class GetMyRequestsEvent extends MyRequestsEvent {
  GetOrdersParams params;
  GetMyRequestsEvent({required this.params});
}

class LoadMoreOrders extends MyRequestsEvent {
  LoadMoreOrders();
}

class GetProvidersEvent extends MyRequestsEvent {
  String? orderId;
  ServiceParams params;
  Function callBack;
  GetProvidersEvent(
      {required this.params, required this.orderId, required this.callBack});
}

class GetRequestDetailsEvent extends MyRequestsEvent {
  final OrderDetailsParams params;
  final String? requestTypeName;
  GetRequestDetailsEvent({required this.params, this.requestTypeName});
}

class ClearEvent extends MyRequestsEvent {
  ClearEvent();
}

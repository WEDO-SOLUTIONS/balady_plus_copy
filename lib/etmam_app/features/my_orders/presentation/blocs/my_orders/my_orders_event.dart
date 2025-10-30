part of 'my_orders_bloc.dart';

abstract class MyOrdersEvent extends Equatable {
  const MyOrdersEvent();

  @override
  List<Object> get props => [];
}

class GetMyOrdersEvent extends MyOrdersEvent {
  GetOrdersParams params;
  GetMyOrdersEvent({required this.params});
}

class LoadMoreOrders extends MyOrdersEvent {
  LoadMoreOrders();
}

class GetProvidersEvent extends MyOrdersEvent {
  String? orderId;
  ServiceParams params;
  Function callBack;
  GetProvidersEvent(
      {required this.params, required this.orderId, required this.callBack});
}

class GetOrderDetailsEvent extends MyOrdersEvent {
  OrderDetailsParams params;
  GetOrderDetailsEvent({required this.params});
}

class ClearEvent extends MyOrdersEvent {
  ClearEvent();
}

import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show OrderItem;

class OrdersResponse extends Equatable {
  OrdersResponse({
    this.totalPageCount,
    this.totalItemCount,
    this.items,
  });

  int? totalPageCount;
  int? totalItemCount;
  List<OrderItem>? items;

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

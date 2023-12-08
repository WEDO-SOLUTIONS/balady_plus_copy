import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show OrdersResponse, OrderItemModel;

class OrdersResponseModel extends OrdersResponse {
  OrdersResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory OrdersResponseModel.fromMap(Map<String, dynamic> json) =>
      OrdersResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<OrderItemModel>.from(
                  json["items"].map((x) => OrderItemModel.fromMap(x)))
              : []);
}

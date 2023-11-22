import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show OrdersResponse, RequestItemModel, RequestsResponse;

class RequestResponseModel extends RequestsResponse {
  RequestResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory RequestResponseModel.fromMap(Map<String, dynamic> json) =>
      RequestResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<RequestItemModel>.from(
                  json["items"].map((x) => RequestItemModel.fromMap(x)))
              : []);
}

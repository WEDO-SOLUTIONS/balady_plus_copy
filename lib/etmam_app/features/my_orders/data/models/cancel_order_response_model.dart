import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/cancel_order_response.dart';

class CancelOrderResponseModel extends CancelOrderResponse {
  CancelOrderResponseModel({super.id, super.successMessage, super.number});

  factory CancelOrderResponseModel.fromMap(Map<String, dynamic> json) =>
      CancelOrderResponseModel(
          id: json["id"],
          successMessage: json["successMessage"],
          number: json["number"]);
}

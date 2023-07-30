import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';

class RatingItemModel extends RatingItem {
  RatingItemModel({super.active, super.id, super.name});

  factory RatingItemModel.fromMap(Map<String, dynamic> json) => RatingItemModel(
      active: json["active"], id: json["id"], name: json["name"]);
}

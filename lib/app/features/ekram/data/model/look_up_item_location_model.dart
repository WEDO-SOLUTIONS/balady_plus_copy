import 'package:balady_plus/app/features/ekram/domain/entities/lookup_item_location.dart';

class LookUpItemLocationModel extends LookUpItemLocation {
  LookUpItemLocationModel(
      {super.id,
      super.name,
      super.laundryName,
      super.mosqueName,
      super.x,
      super.y});

  factory LookUpItemLocationModel.fromJson(Map<String, dynamic> json) =>
      LookUpItemLocationModel(
        id: json["id"],
        name: json["laundryName"] ?? json["mosqueName"],
        laundryName: json["laundryName"],
        mosqueName: json["mosqueName"],
        x: json["x"],
        y: json["y"],
      );
}

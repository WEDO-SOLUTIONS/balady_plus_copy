import 'package:balady_plus/etmam_app/features/home/home_exports.dart';

class SubServiceItemModel extends SubServiceItems {
  SubServiceItemModel({super.id, super.name, super.imageUrl, super.logoUrl});

  factory SubServiceItemModel.fromMap(Map<String, dynamic> json) =>
      SubServiceItemModel(
          id: json["id"],
          name: json["name"],
          imageUrl: json["imageUrl"],
          logoUrl: json["logoUrl"]);
}

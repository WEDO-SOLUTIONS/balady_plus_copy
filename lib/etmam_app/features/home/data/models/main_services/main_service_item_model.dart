import 'package:balady_plus/etmam_app/features/home/home_exports.dart';

class MainServiceItemModel extends MainServiceItems {
  MainServiceItemModel({super.id, super.name, super.logoUrl});

  factory MainServiceItemModel.fromMap(Map<String, dynamic> json) =>
      MainServiceItemModel(
        id: json["id"],
        name: json["name"],
        logoUrl: json["logoUrl"],
      );
}

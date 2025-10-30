import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CityItem;

class CityItemModel extends CityItem {
  CityItemModel({super.id, super.name, super.imageUrl});

  factory CityItemModel.fromMap(Map<String, dynamic> json) {
    return CityItemModel(
        id: json["id"], name: json["name"], imageUrl: json["imageUrl"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "imageUrl": imageUrl};
  }
}

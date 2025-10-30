import 'package:balady_plus/app/features/vd/vd_exports.dart' show SplItem;

class SplItemModel extends SplItem {
  SplItemModel({super.categoryId, super.id, super.image, super.name});

  factory SplItemModel.fromMap(Map<String, dynamic> json) => SplItemModel(
        categoryId: json["categoryId"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
      );
}

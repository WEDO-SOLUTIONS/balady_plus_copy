import 'package:balady_plus/app/features/vd/vd_exports.dart' show CategoryItem;

class CategoryItemModel extends CategoryItem {
  CategoryItemModel(
      {super.categoryId,
      super.categoryName,
      super.description,
      super.icon,
      super.isPromoted,
      super.mainImage,
      super.type});

  factory CategoryItemModel.fromMap(Map<String, dynamic> json) =>
      CategoryItemModel(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        description: json["description"],
        icon: json["icon"],
        isPromoted: json["isPromoted"],
        mainImage: json["mainImage"],
        type: json["type"],
      );
}

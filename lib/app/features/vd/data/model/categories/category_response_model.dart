import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show CategoriesResponse, CategoryItem, CategoryItemModel;

class CategoryResponseModel extends CategoriesResponse {
  CategoryResponseModel({super.items});

  factory CategoryResponseModel.fromMap(Map<String, dynamic> json) =>
      CategoryResponseModel(
          //totalItemCount: json["totalItemCount"],
          // totalPageCount: json["totalPageCount"],
          items: json["categoryList"] != null
              ? List<CategoryItem>.from(
                  json["categoryList"].map((x) => CategoryItemModel.fromMap(x)))
              : null);
}

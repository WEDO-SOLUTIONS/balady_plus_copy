import 'package:balady_plus/app/features/vd/vd_exports.dart' show CategoryItem;

class CategoriesResponse {
  CategoriesResponse({
    // this.totalPageCount,
    // this.totalItemCount,
    this.items,
  });

  //int? totalPageCount;
  //int? totalItemCount;
  List<CategoryItem>? items;

  List<CategoryItem>? getVDCategories() {
    return items?.where((element) => element.type == "VD").toList();
  }

  List<CategoryItem>? getIsPromotedategories() {
    return items?.where((element) => element.isPromoted == true).toList();
  }

  List<CategoryItem>? getAllCategories() {
    return items;
  }
}

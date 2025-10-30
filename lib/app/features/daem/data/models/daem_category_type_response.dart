import '../../../transaction_inquiry/presentation/core/models/error_result.dart';
import 'daem_item.dart';

class DaemCategoryTypeResponse {
  DaemCategoryTypeResponse({
    this.categoryTypeList,
    this.errors,
  });

  List<CategoryTypeList>? categoryTypeList;
  List<ErrorResult>? errors;

  factory DaemCategoryTypeResponse.fromJson(Map<String, dynamic> json) =>
      DaemCategoryTypeResponse(
        categoryTypeList: json["CategoryTypeList"] != null
            ? List<CategoryTypeList>.from(json["CategoryTypeList"]
                .map((x) => CategoryTypeList.fromJson(x)))
            : null,
        errors: json["errors"] != null
            ? List<ErrorResult>.from(
                json["errors"].map((x) => ErrorResult.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "CategoryTypeList":
            List<dynamic>.from(categoryTypeList!.map((x) => x.toJson())),
        "errors": List<dynamic>.from(errors!.map((x) => x)),
      };

  List<DaemItem>? getList() {
    return categoryTypeList
        ?.map((e) => DaemItem(id: e.category ?? "", name: e.categoryAR ?? ""))
        .toList();
  }
}

class CategoryTypeList {
  CategoryTypeList({this.category, this.categoryAR});

  String? category;
  String? categoryAR;
  factory CategoryTypeList.fromJson(Map<String, dynamic> json) =>
      CategoryTypeList(
          category: json["Category"], categoryAR: json["CategoryAR"]);

  Map<String, dynamic> toJson() =>
      {"Category": category, "CategoryAR": categoryAR};
}

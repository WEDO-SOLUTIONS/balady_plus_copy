import '../../../transaction_inquiry/presentation/core/models/error_result.dart';
import 'daem_item.dart';

class DaemSubCategoryTypeResponse {
  DaemSubCategoryTypeResponse({
    this.categoryTypeList,
    this.errors,
  });

  List<SubCategoryTypeList>? categoryTypeList;
  List<ErrorResult>? errors;

  factory DaemSubCategoryTypeResponse.fromJson(Map<String, dynamic> json) =>
      DaemSubCategoryTypeResponse(
        categoryTypeList: json["SubCategoryTypeList"] != null
            ? List<SubCategoryTypeList>.from(json["SubCategoryTypeList"]
                .map((x) => SubCategoryTypeList.fromJson(x)))
            : null,
        errors: json["errors"] != null
            ? List<ErrorResult>.from(
                json["errors"].map((x) => ErrorResult.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "SubCategoryTypeList":
            List<dynamic>.from(categoryTypeList!.map((x) => x.toJson())),
        "errors": List<dynamic>.from(errors!.map((x) => x)),
      };

  List<DaemItem>? getList() {
    return categoryTypeList
        ?.map(
            (e) => DaemItem(id: e.subCategory ?? "", name: e.subCategory ?? ""))
        .toList();
  }
}

class SubCategoryTypeList {
  SubCategoryTypeList({
    this.subCategory,
  });

  String? subCategory;

  factory SubCategoryTypeList.fromJson(Map<String, dynamic> json) =>
      SubCategoryTypeList(
        subCategory: json["SubCategory"],
      );

  Map<String, dynamic> toJson() => {
        "SubCategory": subCategory,
      };

  /*@override
  String? getName() {
    return subCategory;
  }*/

  @override
  List<Object> get props => subCategory != null ? [subCategory!] : [];
}

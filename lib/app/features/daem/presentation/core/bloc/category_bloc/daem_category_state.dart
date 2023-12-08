part of 'daem_category_bloc.dart';

class DaemCategoryState extends Equatable {
  BlocStatus status;
  DaemItem? category;
  DaemItem? subCategory;
  DaemItem? area;
  DaemItem? issueType;
  List<DaemItem>? categoryTypeList;
  List<DaemItem>? subCategoryTypeList;
  List<DaemItem>? municipalities;
  List<DaemItem>? areaList;
  List<DaemItem>? issuesList;
  String? error;

  DaemCategoryState(
      {this.status = BlocStatus.initial,
      this.categoryTypeList,
      this.category,
      this.subCategoryTypeList,
      this.municipalities,
      this.area,
      this.issuesList,
      this.areaList,
      this.issueType,
      this.subCategory,
      this.error});

  DaemCategoryState copyWith(
      {BlocStatus? status,
      List<DaemItem>? categoryTypeList,
      List<DaemItem>? subCategoryTypeList,
      List<DaemItem>? municipalities,
      DaemItem? category,
      DaemItem? subCategory,
      DaemItem? area,
      DaemItem? issueType,
      List<DaemItem>? areaList,
      List<DaemItem>? issuesList,
      String? error}) {
    return DaemCategoryState(
        status: status ?? this.status,
        categoryTypeList: categoryTypeList ?? this.categoryTypeList,
        subCategoryTypeList: subCategoryTypeList ?? this.subCategoryTypeList,
        municipalities: municipalities ?? this.municipalities,
        category: category ?? this.category,
        area: area ?? this.area,
        issuesList: issuesList ?? this.issuesList,
        areaList: areaList ?? this.areaList,
        issueType: issueType ?? this.issueType,
        subCategory: subCategory ?? this.subCategory,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [status, category, subCategory, issueType, area];
}

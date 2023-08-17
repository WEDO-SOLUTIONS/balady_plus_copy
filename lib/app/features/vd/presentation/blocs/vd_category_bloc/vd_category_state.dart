part of 'vd_category_bloc.dart';

class VDCategoryState extends Equatable {
  // BlocStatus status;
  BlocStatus allCategorystatus;
  BlocStatus vdCategorystatus;
  BlocStatus promotedCategorystatus;

  String? errorMessage;
  CategoriesResponse? categories;
  final List<CategoryItem>? allCategories;
  final List<CategoryItem>? vdCategories;
  final List<CategoryItem>? promotedCategories;
  final List<CategoryItem>? qrCategory;

  VDCategoryState(
      {
      //this.status = BlocStatus.initial,
      this.allCategorystatus = BlocStatus.initial,
      this.vdCategorystatus = BlocStatus.initial,
      this.promotedCategorystatus = BlocStatus.initial,
      this.qrCategory,
      this.categories,
      this.errorMessage,
      this.allCategories,
      this.vdCategories,
      this.promotedCategories});

  VDCategoryState copyWith({
    //final BlocStatus? status,
    final BlocStatus? allCategorystatus,
    final BlocStatus? vdCategorystatus,
    final BlocStatus? promotedCategorystatus,
    final List<CategoryItem>? qrCategory,
    final String? errorMessage,
    final CategoriesResponse? categories,
    final List<CategoryItem>? allCategories,
    final List<CategoryItem>? vdCategories,
    final List<CategoryItem>? promotedCategories,
  }) {
    return VDCategoryState(
        // status: status ?? this.status,
        allCategorystatus: allCategorystatus ?? this.allCategorystatus,
        vdCategorystatus: vdCategorystatus ?? this.vdCategorystatus,
        promotedCategorystatus:
            promotedCategorystatus ?? this.promotedCategorystatus,
        errorMessage: errorMessage ?? this.errorMessage,
        categories: categories ?? this.categories,
        allCategories: allCategories ?? this.allCategories,
        promotedCategories: promotedCategories ?? this.promotedCategories,
        vdCategories: vdCategories ?? this.vdCategories,
        qrCategory: qrCategory ?? this.qrCategory);
  }

  @override
  List<Object> get props => [
        //  status,
        allCategorystatus, vdCategorystatus, promotedCategorystatus,
      ];
}

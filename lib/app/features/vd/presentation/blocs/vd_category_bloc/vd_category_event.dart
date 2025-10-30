part of 'vd_category_bloc.dart';

abstract class VDCategoryEvent extends Equatable {
  const VDCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetVDCategories extends VDCategoryEvent {
  final CategoryParams params = CategoryParams(type: ["VD"]);
  final bool? showLoading;
  GetVDCategories({this.showLoading = true});
}

class GetPromotedCategories extends VDCategoryEvent {
  final CategoryParams params = CategoryParams(type: [], isPromoted: true);
  final bool? showLoading;
  GetPromotedCategories({this.showLoading = true});
}

class GetAllCategories extends VDCategoryEvent {
  final CategoryParams params = CategoryParams(type: []);
  final bool? showLoading;

  GetAllCategories({this.showLoading = true});
}

class RefreshCategoriesEvent extends VDCategoryEvent {
  RefreshCategoriesEvent();
}

/*part of 'promoted_category_bloc.dart';

class PromotedCategoryState extends Equatable {
  BlocStatus status;
  String? errorMessage;
  CategoriesResponse? categories;
  PromotedCategoryState({
    this.status = BlocStatus.initial,
    this.categories,
    this.errorMessage,
  });

  PromotedCategoryState copyWith({
    final BlocStatus? status,
    final String? errorMessage,
    final CategoriesResponse? categories,
  }) {
    return PromotedCategoryState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object> get props => [
        status,
      ];
}
*/

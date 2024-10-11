part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  final BlocStatus categoriesStatus;
  final List<LookUpItem>? categories;
  final String? errorMessage;

  const CategoriesState({
    this.categoriesStatus = BlocStatus.initial,
    this.categories,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        categoriesStatus,
        categories,
        errorMessage,
      ];

  CategoriesState copyWith({
    BlocStatus? categoriesStatus,
    List<LookUpItem>? categories,
    String? errorMessage,
  }) {
    return CategoriesState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }
}

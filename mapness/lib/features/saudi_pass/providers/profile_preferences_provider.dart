import 'package:collection/collection.dart';
import 'package:mapness/features/saudi_pass/providers/get_all_lookups_provider.dart';
import 'package:mapness/features/saudi_pass/providers/get_all_subcategories_provider.dart';
import 'package:mapness/features/saudi_pass/providers/get_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/shared/entities/selection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_preferences_provider.g.dart';

class ProfilePreferencesState {
  final City? city;
  final List<Selection<SubCategory>> subCategories;
  final List<Selection<RecommendedType>> recommendedTypes;
  final Iterable<Category> allCategories;

  ProfilePreferencesState({
    required this.city,
    required this.subCategories,
    required this.recommendedTypes,
    required this.allCategories,
  });

  ProfilePreferencesState copyWith({
    City? city,
    List<Selection<SubCategory>>? subCategories,
    List<Selection<RecommendedType>>? recommendedTypes,
    Iterable<Category>? allCategories,
  }) =>
      ProfilePreferencesState(
        city: city ?? this.city,
        subCategories: subCategories ?? this.subCategories,
        recommendedTypes: recommendedTypes ?? this.recommendedTypes,
        allCategories: allCategories ?? this.allCategories,
      );
}

@riverpod
class ProfilePreferences extends _$ProfilePreferences {
  @override
  Future<ProfilePreferencesState> build() async {
    final (lookups, preferences) = await (
      ref.watch(getAllLookupsProvider.future),
      ref.watch(getProfilePreferencesProvider.future),
    ).wait;

    final allCategories = lookups.categories;
    final subCategoriesInPreferences = preferences.subCategoriesOnly.toSet();

    final typesInPreferences = preferences.recommendedTypes.toSet();

    final categoryIds = allCategories.map((cat) => cat.id);

    final subCategories =
        await ref.watch(getAllSubCategoriesProvider.call(categoryIds).future);

    final city = lookups.cities
        .firstWhereOrNull((e) => e == preferences.cities.firstOrNull);

    final selectionSubCategories = subCategories
        .map(
          (e) => Selection<SubCategory>(
              value: e, selected: subCategoriesInPreferences.contains(e)),
        )
        .toList();
    final selectionTypes = lookups.recommendedTypes
        .map(
          (e) => Selection<RecommendedType>(
              value: e, selected: typesInPreferences.contains(e)),
        )
        .toList();

    return ProfilePreferencesState(
        city: city,
        subCategories: selectionSubCategories,
        recommendedTypes: selectionTypes,
        allCategories: allCategories);
  }

  void changeSubCategory(Selection<SubCategory> subCategory) {
    update(
      (state) => state.copyWith(
        subCategories: state.subCategories
            .map(
              (e) => e == subCategory ? e.copyWith(selected: !e.selected) : e,
            )
            .toList(),
      ),
    );
  }

  void toggleCategory(String categoryId) {
    update((state) {
      final subcategoriesForCategory = state.subCategories
          .where((sub) => sub.value.categoryId == categoryId);
      final allSelected = subcategoriesForCategory.every((sub) => sub.selected);

      return state.copyWith(
        subCategories: state.subCategories
            .map(
              (e) => e.value.categoryId == categoryId
                  ? e.copyWith(selected: !allSelected)
                  : e,
            )
            .toList(),
      );
    });
  }

  void applySubCategories(Set<SubCategory> selected) {
    final selections = selected.map(
      (it) => Selection<SubCategory>(value: it, selected: true),
    );

    update(
      (state) => state.copyWith(
        subCategories: state.subCategories
            .map(
              (e) => e.copyWith(
                  selected: selections.any((it) => it.value.id == e.value.id)),
            )
            .toList(),
      ),
    );
  }

  void changeRecommendedType(Selection<RecommendedType> type) {
    update(
      (state) => state.copyWith(
        recommendedTypes: state.recommendedTypes
            .map((e) => e == type ? e.copyWith(selected: !e.selected) : e)
            .toList(),
      ),
    );
  }

  void setCity(City city) {
    update((state) => state.copyWith(city: city));
  }
}

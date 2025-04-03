import 'package:collection/collection.dart';
import 'package:mapness/features/saudi_pass/providers/get_all_lookups_provider.dart';
import 'package:mapness/features/saudi_pass/providers/get_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/shared/entities/selection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_preferences_provider.g.dart';

class ProfilePreferencesState {
  final City? city;
  final List<Selection<Category>> categories;
  final List<Selection<RecommendedType>> recommendedTypes;
  final Preferences preferences;

  ProfilePreferencesState({
    required this.city,
    required this.categories,
    required this.recommendedTypes,
    required this.preferences,
  });

  ProfilePreferencesState copyWith({
    City? city,
    List<Selection<Category>>? categories,
    List<Selection<RecommendedType>>? recommendedTypes,
    Preferences? preferences,
  }) =>
      ProfilePreferencesState(
        city: city ?? this.city,
        categories: categories ?? this.categories,
        recommendedTypes: recommendedTypes ?? this.recommendedTypes,
        preferences: preferences ?? this.preferences,
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

    final categoriesInPreferences = preferences.categories.toSet();
    final typesInPreferences = preferences.recommendedTypes.toSet();

    final city = lookups.cities.firstWhereOrNull((e) => e == preferences.cities.firstOrNull);
    final selectionCategories = lookups.categories
        .map(
          (e) => Selection<Category>(value: e, selected: categoriesInPreferences.contains(e)),
        )
        .toList();
    final selectionTypes = lookups.recommendedTypes
        .map(
          (e) => Selection<RecommendedType>(value: e, selected: typesInPreferences.contains(e)),
        )
        .toList();

    return ProfilePreferencesState(
      city: city,
      categories: selectionCategories,
      recommendedTypes: selectionTypes,
      preferences: preferences,
    );
  }

  void changeCategory(Selection<Category> category) {
    update(
      (state) => state.copyWith(
        categories: state.categories.map((e) => e == category ? e.copyWith(selected: !e.selected) : e).toList(),
      ),
    );
  }

  void changeRecommendedType(Selection<RecommendedType> type) {
    update(
      (state) => state.copyWith(
        recommendedTypes: state.recommendedTypes.map((e) => e == type ? e.copyWith(selected: !e.selected) : e).toList(),
      ),
    );
  }

  void setCity(City city) {
    update((state) => state.copyWith(city: city));
  }
}

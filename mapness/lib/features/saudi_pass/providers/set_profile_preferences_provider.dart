import 'package:mapness/features/saudi_pass/providers/get_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/set_preferences_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_profile_preferences_provider.g.dart';

enum SetProfilePreferencesState {
  initial,
  loading,
  setError,
  resetError,
  setSuccess,
  resetSuccess
}

@riverpod
class SetProfilePreferences extends _$SetProfilePreferences {
  @override
  SetProfilePreferencesState build() => SetProfilePreferencesState.initial;

  Future<void> set() async {
    state = SetProfilePreferencesState.loading;

    try {
      final currentPreferences =
          await ref.read(getProfilePreferencesProvider.future);
      final newPreferences = await ref.read(profilePreferencesProvider.future);
      final city = newPreferences.city;

      final categories = _getCategoriesWithSubCategories(newPreferences);
      final recommendedTypeIds = newPreferences.recommendedTypes
          .where((e) => e.selected)
          .map((e) => e.value.id)
          .toList();

      final request = SetPreferencesRequest(
        mobile: currentPreferences.mobile,
        birthDate: currentPreferences.birthDate,
        genderId: currentPreferences.gender?.id,
        cities: city != null ? [city.id] : null,
        categories: categories.isNotEmpty ? categories.toList() : null,
        recommendedTypes:
            recommendedTypeIds.isNotEmpty ? recommendedTypeIds : null,
        receiveNearbyDeals: currentPreferences.receiveNearbyDeals,
        receiveNewOpeningDeals: currentPreferences.receiveNewOpeningDeals,
      );

      await _sendRequest(request);
      state = SetProfilePreferencesState.setSuccess;
    } catch (_) {
      state = SetProfilePreferencesState.setError;
    }
  }

  Future<void> reset() async {
    state = SetProfilePreferencesState.loading;

    try {
      final currentPreferences =
          await ref.read(getProfilePreferencesProvider.future);

      final request = SetPreferencesRequest(
        mobile: currentPreferences.mobile,
        birthDate: currentPreferences.birthDate,
        genderId: currentPreferences.gender?.id,
        receiveNearbyDeals: currentPreferences.receiveNearbyDeals,
        receiveNewOpeningDeals: currentPreferences.receiveNewOpeningDeals,
      );

      await _sendRequest(request);
      state = SetProfilePreferencesState.resetSuccess;
    } catch (_) {
      state = SetProfilePreferencesState.resetError;
    }
  }

  void retry() {
    switch (state) {
      case SetProfilePreferencesState.setError:
        set();
      case SetProfilePreferencesState.resetError:
        reset();
      // ignore: no_default_cases
      default:
    }
  }

  Future<void> _sendRequest(SetPreferencesRequest request) async {
    final repository = await ref.read(saudiPassRepositoryProvider.future);
    await repository.setPreferences(request);
    ref.invalidate(getProfilePreferencesProvider);
  }

  Iterable<CategoryRequest> _getCategoriesWithSubCategories(
    ProfilePreferencesState prefs,
  ) {
    final cats = prefs.allCategories;
    final selectedSubs = prefs.subCategories.where((it) => it.selected);
    // Group all selected subcategories by category
    final Map<String, List<SubCategory>> grouped = {};

    for (final sub in selectedSubs) {
      grouped
          .putIfAbsent(
            cats.firstWhere((it) => it.id == sub.value.categoryId).id,
            () => [],
          )
          .add(sub.value);
    }

    // Return categories where at least one of their subcategories are selected
    return grouped.entries.map((it) => CategoryRequest(
        id: it.key, subCategories: it.value.map((s) => s.id).toList()));
  }
}

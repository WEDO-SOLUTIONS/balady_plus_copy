import 'package:mapness/features/saudi_pass/providers/get_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/set_preferences_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_profile_preferences_provider.g.dart';

enum SetProfilePreferencesState { initial, loading, setError, resetError, setSuccess, resetSuccess }

@riverpod
class SetProfilePreferences extends _$SetProfilePreferences {
  @override
  SetProfilePreferencesState build() => SetProfilePreferencesState.initial;

  Future<void> set() async {
    state = SetProfilePreferencesState.loading;

    try {
      final currentPreferences = await ref.read(getProfilePreferencesProvider.future);
      final newPreferences = await ref.read(profilePreferencesProvider.future);
      final city = newPreferences.city;
      final categoryIds = newPreferences.categories.where((e) => e.selected).map((e) => e.value.id).toList();
      final recommendedTypeIds =
          newPreferences.recommendedTypes.where((e) => e.selected).map((e) => e.value.id).toList();

      final request = SetPreferencesRequest(
        mobile: currentPreferences.mobile,
        birthDate: currentPreferences.birthDate,
        genderId: currentPreferences.gender?.id,
        cities: city != null ? [city.id] : null,
        categories: categoryIds.isNotEmpty ? categoryIds : null,
        recommendedTypes: recommendedTypeIds.isNotEmpty ? recommendedTypeIds : null,
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
      final currentPreferences = await ref.read(getProfilePreferencesProvider.future);

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
}

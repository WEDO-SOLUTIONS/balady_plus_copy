import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPrefs extends Mock implements SharedPreferences {
  bool? isOnboardingShown;

  @override
  Future<bool> setBool(String key, bool value) {
    isOnboardingShown = value;
    return Future<bool>.value(true);
  }

  @override
  bool? getBool(String key){
    return isOnboardingShown;
  }
}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  ProviderContainer makeProviderContainer(MockSharedPrefs sharedPrefs) {
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(sharedPrefs),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('onboarding provider test',() async{
    final prefs = MockSharedPrefs();

    final container = makeProviderContainer(prefs);

    final listener = Listener<bool>();

    container.listen(
      onboardingProvider,
      listener,
      fireImmediately: true,
    );

    verify(
          () => listener(null, false),
    );

    container.read(onboardingProvider.notifier).setIsOnboardingShown(isOnboardingShown: true);

    verify(
          () => listener(false, true),
    );
  });

}

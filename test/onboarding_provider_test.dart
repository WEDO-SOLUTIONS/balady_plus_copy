import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/onboarding.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mapness/shared/test_utils/mock_shared_prefs.dart';

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  ProviderContainer makeProviderContainer(MockSharedPrefs sharedPrefs) {
    final container = ProviderContainer(overrides: [sharedPrefsProvider.overrideWithValue(sharedPrefs)]);
    addTearDown(container.dispose);
    return container;
  }

  test('onboarding provider test', () async {
    final prefs = MockSharedPrefs();

    final container = makeProviderContainer(prefs);

    final listener = Listener<bool>();

    container.listen(onboardingProvider, listener.call, fireImmediately: true);

    verify(() => listener(null, false));
    final notifier = container.read(onboardingProvider.notifier);

    notifier.setIsOnboardingShown(isOnboardingShown: true);

    verify(() => listener(false, true));

    expect(() => notifier.setIsOnboardingShown(isOnboardingShown: true), isA<void>());

    verifyNoMoreInteractions(listener);
  });
}

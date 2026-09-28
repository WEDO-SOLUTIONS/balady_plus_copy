import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/test_utils/mock_shared_prefs.dart';
import 'package:mocktail/mocktail.dart';

/// Lets the test resolve/reject `fetchSuggest` for a given query on demand,
/// instead of racing real network timing.
class _MockDgisMapController extends Mock implements DgisMapController {}

/// Skips the real `build()` (native map controller, `onMapCreated`, ...) and
/// just hands back the controllable [DgisMapController] mock.
class _FakeDgisController extends DgisController {
  _FakeDgisController(this._controller);

  final DgisMapController _controller;

  @override
  Future<DgisMapController> build() async => _controller;
}

SuggestResultMessage _suggestResult(String title) => SuggestResultMessage(
  suggests: [
    SuggestMessage(
      handler: SuggestHandlerMessage(),
      suggestedType: SuggestedTypeMessage.branch,
      title: MarkedUpTextMessage(text: title, matchedParts: const []),
      subtitle: MarkedUpTextMessage(text: '', matchedParts: const []),
    ),
  ],
);

void main() {
  late _MockDgisMapController mockController;
  late ProviderContainer container;
  const scope = 'MapSearch';

  setUpAll(() {
    registerFallbackValue(
      GeoRectMessage(
        northEast: GeoPointMessage(latitude: 0, longitude: 0),
        southWest: GeoPointMessage(latitude: 0, longitude: 0),
      ),
    );
  });

  setUp(() {
    mockController = _MockDgisMapController();
    container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(MockSharedPrefs()),
        dgisControllerProvider.overrideWith(() => _FakeDgisController(mockController)),
      ],
    );
    addTearDown(container.dispose);
    // Keeps the (autoDispose) searchProvider alive for the test's duration.
    container.listen(searchProvider(scope), (_, _) {});
  });

  /// Stubs `fetchSuggest` to resolve from a per-query completer, so the test
  /// controls exactly when each in-flight call "answers".
  Map<String, Completer<SuggestResultMessage>> _stubFetchSuggest(List<String> queries) {
    final completers = {for (final q in queries) q: Completer<SuggestResultMessage>()};
    when(
      () => mockController.fetchSuggest(
        any(),
        searchRect: any(named: 'searchRect'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((invocation) {
      final query = invocation.positionalArguments[0] as String;
      return completers[query]!.future;
    });
    return completers;
  }

  test('a stale suggest response does not overwrite state after further typing', () async {
    final completers = _stubFetchSuggest(['abc']);
    final notifier = container.read(searchProvider(scope).notifier);

    final fetchAbc = notifier.fetchSuggest('abc');
    // Let fetchSuggest run up to the (still-pending) network await.
    await Future<void>.delayed(Duration.zero);

    final stateBeforeStaleAnswer = container.read(searchProvider(scope));

    // User keeps typing past "abc" before the suggest for it arrives.
    notifier.searchQueryChanged('abcd');

    completers['abc']!.complete(_suggestResult('Stale abc result'));
    await fetchAbc;

    final stateAfterStaleAnswer = container.read(searchProvider(scope));
    expect(identical(stateBeforeStaleAnswer, stateAfterStaleAnswer), isTrue);
    expect(stateAfterStaleAnswer, isNot(isA<SearchStateSuggest>()));

    notifier.clear();
  });

  test('a stale suggest response for a since-deleted query does not reappear', () async {
    final completers = _stubFetchSuggest(['abcd']);
    final notifier = container.read(searchProvider(scope).notifier);

    final fetchAbcd = notifier.fetchSuggest('abcd');
    await Future<void>.delayed(Duration.zero);

    final stateBeforeStaleAnswer = container.read(searchProvider(scope));

    // User deletes the last character before the suggest for "abcd" arrives.
    notifier.searchQueryChanged('abc');

    completers['abcd']!.complete(_suggestResult('Stale abcd result'));
    await fetchAbcd;

    final stateAfterStaleAnswer = container.read(searchProvider(scope));
    expect(identical(stateBeforeStaleAnswer, stateAfterStaleAnswer), isTrue);
    expect(stateAfterStaleAnswer, isNot(isA<SearchStateSuggest>()));

    notifier.clear();
  });
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/ai_summary/data/ai_summary_cache.dart';
import 'package:mapness/features/ai_summary/data/ai_summary_repository.dart';
import 'package:mapness/features/ai_summary/data/ai_summary_repository_provider.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/features/ai_summary/state/ai_summary_notifier.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// Repository whose `fetchSummary` returns only when the test pulls the
/// trigger via [completer]. Used to assert behaviour while a fetch is
/// still in flight.
class _ControllableRepo implements AiSummaryRepository {
  Completer<AiSummary?> completer = Completer<AiSummary?>();
  CancelToken? lastToken;
  int calls = 0;

  @override
  Future<AiSummary?> fetchSummary(String poiId, Language locale, {CancelToken? cancelToken}) async {
    calls++;
    lastToken = cancelToken;
    return completer.future;
  }
}

/// Cache stub that never finds anything and silently accepts writes —
/// the production `AiSummaryCache` requires Hive bindings we don't want
/// in this unit test.
class _NoopCache implements AiSummaryCache {
  @override
  AiSummary? get(String poiId, Language locale) => null;

  @override
  Future<void> put(String poiId, Language locale, AiSummary summary) async {}

  @override
  Future<void> invalidate(String poiId, Language locale) async {}

  @override
  Future<void> clear() async {}

  @override
  Duration get ttl => Duration.zero;
}

ProviderContainer _makeContainer(_ControllableRepo repo) => ProviderContainer(
  overrides: [
    aiSummaryRepositoryProvider.overrideWith((ref) async => repo),
    aiSummaryCacheProvider.overrideWith((ref) async => _NoopCache()),
  ],
);

void main() {
  group('AiSummaryNotifier.cancel()', () {
    test('cancels an in-flight fetch and resets state to data(null)', () async {
      final repo = _ControllableRepo();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      const poiId = '123';
      const locale = Language.english;
      final notifier = container.read(aiSummaryProvider(poiId, locale).notifier);

      final loadFuture = notifier.load();
      // Let the notifier reach the `state = loading` step.
      await Future<void>.delayed(Duration.zero);
      expect(container.read(aiSummaryProvider(poiId, locale)).isLoading, isTrue);
      expect(repo.lastToken, isNotNull);
      expect(repo.lastToken!.isCancelled, isFalse);

      notifier.cancel();

      expect(repo.lastToken!.isCancelled, isTrue);
      expect(container.read(aiSummaryProvider(poiId, locale)).isLoading, isFalse);
      expect(container.read(aiSummaryProvider(poiId, locale)).value, isNull);

      // Repository eventually completes — must not overwrite the cancelled
      // state. (The notifier checks `token.isCancelled` after `await`.)
      repo.completer.complete(AiSummary(description: 'late arrival'));
      await loadFuture;

      expect(container.read(aiSummaryProvider(poiId, locale)).value, isNull);
    });

    test('keeps an already-loaded summary on cancel', () async {
      final repo = _ControllableRepo();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      const poiId = '456';
      const locale = Language.english;
      final notifier = container.read(aiSummaryProvider(poiId, locale).notifier);

      final loadFuture = notifier.load();
      repo.completer.complete(AiSummary(description: 'loaded'));
      await loadFuture;

      final loaded = container.read(aiSummaryProvider(poiId, locale)).value;
      expect(loaded?.description, 'loaded');

      notifier.cancel();

      expect(container.read(aiSummaryProvider(poiId, locale)).value?.description, 'loaded');
    });

    test('is a no-op when never loaded', () {
      final repo = _ControllableRepo();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      const poiId = '789';
      const locale = Language.english;
      final notifier = container.read(aiSummaryProvider(poiId, locale).notifier);

      expect(() => notifier.cancel(), returnsNormally);
      expect(container.read(aiSummaryProvider(poiId, locale)).value, isNull);
    });
  });
}

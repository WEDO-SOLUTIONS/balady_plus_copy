import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/ai_summary/data/ai_summary_cache.dart';
import 'package:mapness/features/ai_summary/data/ai_summary_repository_provider.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_summary_notifier.g.dart';

/// Per-POI, per-locale state holder for the AI Summary card.
///
/// The notifier intentionally does **not** auto-fetch on mount.
/// Data is loaded only when the consumer calls [load] — this
/// mirrors the spec's rule that the network request fires
/// exactly once when the POI card transitions to its fully
/// expanded state for the first time, not on every marker tap.
///
/// `keepAlive: true` because the section is unmounted whenever
/// the user switches the POI card to the Images tab and back —
/// auto-disposing here lost the loaded summary on re-mount, with
/// no trigger left to re-fetch (the bottom sheet is still in
/// `expanded`, so `_maybeTriggerAiSummary` has already fired and
/// won't fire again). The footprint is bounded — one
/// `AsyncValue<AiSummary?>` per `(poiId, locale)` for the lifetime
/// of the app — and mirrors the cache's own keepAlive lifetime.
///
/// State semantics:
/// * `AsyncData(null)` — either initial (not loaded yet) or
///   "insufficient data" result. The UI hides the section.
/// * `AsyncLoading` — request in flight, UI shows the skeleton.
/// * `AsyncData(summary)` — loaded successfully.
/// * Errors never reach the UI: failures fall back to any
///   existing cached value or `AsyncData(null)` (section hidden).
@Riverpod(keepAlive: true)
class AiSummaryNotifier extends _$AiSummaryNotifier {
  CancelToken? _cancelToken;

  @override
  AsyncValue<AiSummary?> build(String poiId, Language locale) {
    debugPrint('[AiSummaryDebug] notifier.build poi=$poiId locale=${locale.languageCode}');
    ref.onDispose(() => _cancelToken?.cancel('AiSummaryNotifier disposed'));
    return const AsyncValue.data(null);
  }

  /// Cancel any in-flight fetch for this notifier without disposing it.
  ///
  /// Called by POI-card widgets in their `dispose()` so a switch to another
  /// POI (or closing the card) doesn't leave the previous request running
  /// to completion. `keepAlive: true` means `onDispose` wouldn't fire here
  /// even though no widget is watching us any more, so we need explicit
  /// cancellation.
  ///
  /// State is reset to `data(null)` only if the request was still in flight;
  /// a successfully loaded summary stays in `state` so a fast re-open of the
  /// same POI can show it immediately from this notifier without re-asking
  /// the cache.
  void cancel({String reason = 'Cancelled by caller'}) {
    _cancelToken?.cancel(reason);
    _cancelToken = null;
    if (state.isLoading) {
      state = const AsyncValue.data(null);
    }
  }

  /// Trigger the fetch. Safe to call multiple times — a cache
  /// hit returns immediately without a network round-trip.
  Future<void> load() async {
    debugPrint('[AiSummaryDebug] notifier.load() called poi=$poiId locale=${locale.languageCode}');
    final cache = await ref.read(aiSummaryCacheProvider.future);

    final cached = cache.get(poiId, locale);
    if (cached != null) {
      debugPrint('[AiSummaryDebug] cache HIT poi=$poiId locale=${locale.languageCode} — no network');
      _cancelToken?.cancel('Superseded by cache hit');
      _cancelToken = null;
      state = AsyncValue.data(cached);
      return;
    }

    debugPrint('[AiSummaryDebug] cache MISS poi=$poiId locale=${locale.languageCode} — fetching');
    _cancelToken?.cancel('Superseded by new load() call');
    final token = CancelToken();
    _cancelToken = token;
    state = const AsyncValue.loading();
    try {
      final repo = await ref.read(aiSummaryRepositoryProvider.future);
      final summary = await repo.fetchSummary(poiId, locale, cancelToken: token);
      if (token.isCancelled) {
        return;
      }
      if (summary != null) {
        await cache.put(poiId, locale, summary);
      }
      state = AsyncValue.data(summary);
    } catch (e, _) {
      if (token.isCancelled || (e is DioException && CancelToken.isCancel(e))) {
        return;
      }
      logger.log('AI Summary fetch failed: $e', logLevel: MapnessLogLevel.error);
      // Fall back to any stored cached value (offline scenario);
      // otherwise surface as "no data" so the section is hidden.
      //
      // Covers 429 (rate-limit) and 5xx the same way: a previously
      // cached summary keeps showing on transient failure, and a
      // first-time POI silently hides the section. There is no
      // auto-retry — the next load fires only when the consumer
      // re-triggers (POI reopened) or the cache TTL flushes, so
      // under sustained backend pressure expect a "section absent"
      // UX rather than a spinner-forever.
      final fallback = cache.get(poiId, locale);
      state = AsyncValue.data(fallback);
    } finally {
      if (identical(_cancelToken, token)) {
        _cancelToken = null;
      }
    }
  }
}

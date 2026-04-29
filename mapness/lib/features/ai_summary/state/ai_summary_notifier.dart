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
/// State semantics:
/// * `AsyncData(null)` — either initial (not loaded yet) or
///   "insufficient data" result. The UI hides the section.
/// * `AsyncLoading` — request in flight, UI shows the skeleton.
/// * `AsyncData(summary)` — loaded successfully.
/// * Errors never reach the UI: failures fall back to any
///   existing cached value or `AsyncData(null)` (section hidden).
@riverpod
class AiSummaryNotifier extends _$AiSummaryNotifier {
  @override
  AsyncValue<AiSummary?> build(String poiId, Language locale) => const AsyncValue.data(null);

  /// Trigger the fetch. Safe to call multiple times — a cache
  /// hit returns immediately without a network round-trip.
  Future<void> load() async {
    final cache = await ref.read(aiSummaryCacheProvider.future);

    final cached = cache.get(poiId, locale);
    if (cached != null) {
      state = AsyncValue.data(cached);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final repo = await ref.read(aiSummaryRepositoryProvider.future);
      final summary = await repo.fetchSummary(poiId, locale);
      if (summary != null) {
        await cache.put(poiId, locale, summary);
      }
      state = AsyncValue.data(summary);
    } catch (e, _) {
      logger.log('AI Summary fetch failed: $e', logLevel: MapnessLogLevel.error);
      // Fall back to any stored cached value (offline scenario);
      // otherwise surface as "no data" so the section is hidden.
      final fallback = cache.get(poiId, locale);
      state = AsyncValue.data(fallback);
    }
  }
}

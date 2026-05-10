import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/ai_summary/state/ai_summary_notifier.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_card.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// The wiring between the [AiSummaryCard] presentation component
/// and the [AiSummaryNotifier] state source.
///
/// Renders based on the notifier's [AsyncValue] state:
/// * `AsyncData(null)` — initial or "insufficient data". Section
///   is hidden entirely.
/// * `AsyncLoading` — skeleton shimmer.
/// * `AsyncData(summary)` — full [AiSummaryCard].
/// * `AsyncError` — hidden (errors don't surface in UI per spec).
///
/// This widget deliberately does **not** trigger the fetch on
/// mount. Loading is initiated by whoever controls the bottom
/// sheet state — the consumer must call
/// `ref.read(aiSummaryProvider((poiId, locale)).notifier).load()`
/// at the appropriate moment (typically when the sheet first
/// transitions to its fully expanded state).
class AiSummarySection extends ConsumerWidget {
  final String poiId;

  const AiSummarySection({required this.poiId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final state = ref.watch(aiSummaryProvider(poiId, language));

    final stateLabel = state.when(
      data: (summary) => summary == null ? 'data(null)' : 'data(${summary.description.length}ch)',
      loading: () => 'loading',
      error: (e, _) => 'error($e)',
    );
    debugPrint('[AiSummaryDebug] section.build poi=$poiId locale=${language.languageCode} state=$stateLabel');

    return state.when(
      data: (summary) => summary == null
          ? const SizedBox.shrink()
          : AiSummaryCard(summary: summary, language: language),
      loading: () => AiSummaryCard.skeleton(language: language),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

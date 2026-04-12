import 'package:flutter/material.dart';
import 'package:mapness/features/ai_summary/data/mock_ai_summary_repository.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/features/ai_summary/ui/_preview_fixtures.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_card.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// Debug-only visual and behavioural gallery for the AI Summary
/// feature.
///
/// Two sections:
/// * **Mock scenarios** — buttons that run
///   [MockAiSummaryRepository] with different flag configurations
///   and render the resulting state (loading → data / hidden).
///   Use this to smoke-test the data-layer end-to-end without
///   needing a real POI on the map.
/// * **Static fixtures** — every card variant rendered side by
///   side for pure visual iteration.
///
/// This page is NOT wired into the production navigation
/// graph. It is pushed manually from the debug overlay and
/// should be deleted (or at least gated behind `kDebugMode`)
/// before merging to master.
///
/// TODO(pre-merge): remove this file or gate its entry point
/// behind `kDebugMode` / a debug flag before the feature branch
/// is merged.
class AiSummaryPreviewPage extends StatefulWidget {
  const AiSummaryPreviewPage({super.key});

  @override
  State<AiSummaryPreviewPage> createState() => _AiSummaryPreviewPageState();
}

class _AiSummaryPreviewPageState extends State<AiSummaryPreviewPage> {
  Language _language = Language.english;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: _language.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('AI Summary — preview'),
            actions: [
              IconButton(
                icon: const Icon(Icons.translate),
                tooltip: 'Toggle EN / AR',
                onPressed: () {
                  setState(() {
                    _language = _language.isEnglish ? Language.arabic : Language.english;
                  });
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              _Section(
                title: 'Mock scenarios',
                child: _MockScenarioRunner(language: _language),
              ),
              _Section(
                title: 'Regular POI with rating',
                child: AiSummaryCard(
                  summary: _language.isEnglish ? previewEnRegularWithRating : previewArRegularWithRating,
                  language: _language,
                ),
              ),
              _Section(
                title: 'Regular POI without rating',
                child: AiSummaryCard(
                  summary: previewEnRegularNoRating,
                  language: _language,
                ),
              ),
              _Section(
                title: 'Short description, half-star rating',
                child: AiSummaryCard(
                  summary: previewEnShort,
                  language: _language,
                ),
              ),
              _Section(
                title: 'Long description',
                child: AiSummaryCard(
                  summary: previewEnLong,
                  language: _language,
                ),
              ),
              _Section(
                title: 'Transit bus station',
                child: AiSummaryCard(
                  summary: _language.isEnglish ? previewEnTransitBusStation : previewArTransitBusStation,
                  language: _language,
                ),
              ),
              _Section(
                title: 'Skeleton (loading state)',
                child: AiSummaryCard.skeleton(language: _language),
              ),
            ],
          ),
        ),
      );
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
                letterSpacing: 0.6,
              ),
            ),
          ),
          child,
        ],
      );
}

/// One mock repository scenario the user can run from the debug
/// preview. Each value configures the flags passed to
/// [MockAiSummaryRepository].
enum _Scenario {
  success(
    label: 'Success',
    description: 'Returns a fixture after ~1.5s',
  ),
  fastSuccess(
    label: 'Fast success',
    description: 'Returns a fixture after 300ms',
    latencyMs: 300,
  ),
  offline(
    label: 'Offline',
    description: 'Throws SocketException',
    simulateOffline: true,
  ),
  error(
    label: 'Upstream error',
    description: 'Throws generic exception',
    simulateError: true,
  ),
  insufficient(
    label: 'Insufficient data',
    description: 'Returns null — UI hides the section',
    simulateInsufficient: true,
  );

  final String label;
  final String description;
  final int latencyMs;
  final bool simulateOffline;
  final bool simulateError;
  final bool simulateInsufficient;

  const _Scenario({
    required this.label,
    required this.description,
    this.latencyMs = 1500,
    this.simulateOffline = false,
    this.simulateError = false,
    this.simulateInsufficient = false,
  });

  MockAiSummaryRepository build() => MockAiSummaryRepository(
        latency: Duration(milliseconds: latencyMs),
        simulateOffline: simulateOffline,
        simulateError: simulateError,
        simulateInsufficient: simulateInsufficient,
      );
}

/// Result shown under the scenario buttons.
sealed class _RunResult {
  const _RunResult();
}

class _RunIdle extends _RunResult {
  const _RunIdle();
}

class _RunLoading extends _RunResult {
  const _RunLoading();
}

class _RunData extends _RunResult {
  final AiSummary? summary;
  const _RunData(this.summary);
}

class _RunError extends _RunResult {
  final Object error;
  const _RunError(this.error);
}

/// Interactive section: scenario buttons + current render.
///
/// Uses the real [MockAiSummaryRepository] directly (no Riverpod
/// provider overrides) so the exercise is fully contained and
/// doesn't interfere with the rest of the app's provider graph.
class _MockScenarioRunner extends StatefulWidget {
  final Language language;

  const _MockScenarioRunner({required this.language});

  @override
  State<_MockScenarioRunner> createState() => _MockScenarioRunnerState();
}

class _MockScenarioRunnerState extends State<_MockScenarioRunner> {
  _RunResult _result = const _RunIdle();
  _Scenario? _currentScenario;
  int _counter = 0;
  int _activeRun = 0;

  Future<void> _run(_Scenario scenario) async {
    final runId = ++_activeRun;
    setState(() {
      _currentScenario = scenario;
      _result = const _RunLoading();
    });

    final repo = scenario.build();
    // Unique POI id per run so repeated taps always re-exercise
    // the scenario without accidentally hitting any cache that
    // might be introduced later.
    final poiId = 'preview-${scenario.name}-${_counter++}';

    try {
      final summary = await repo.fetchSummary(poiId, widget.language);
      if (!mounted || runId != _activeRun) {
        return;
      }
      setState(() {
        _result = _RunData(summary);
      });
    } catch (e, _) {
      if (!mounted || runId != _activeRun) {
        return;
      }
      setState(() {
        _result = _RunError(e);
      });
    }
  }

  void _reset() {
    _activeRun++;
    setState(() {
      _currentScenario = null;
      _result = const _RunIdle();
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final scenario in _Scenario.values)
                  _ScenarioChip(
                    label: scenario.label,
                    selected: _currentScenario == scenario,
                    onPressed: () => _run(scenario),
                  ),
                _ScenarioChip(
                  label: 'Reset',
                  selected: false,
                  onPressed: _reset,
                ),
              ],
            ),
            if (_currentScenario != null) ...[
              const SizedBox(height: 8),
              Text(
                _currentScenario!.description,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),
            ],
            const SizedBox(height: 12),
            _renderResult(),
          ],
        ),
      );

  Widget _renderResult() {
    final result = _result;
    return switch (result) {
      _RunIdle() => const _EmptyState(
          text: 'Pick a scenario above to see the card react.',
        ),
      _RunLoading() => AiSummaryCard.skeleton(language: widget.language),
      _RunData(:final summary) => summary == null
          ? const _EmptyState(
              text: 'Repository returned null → section is hidden by the UI layer.',
            )
          : AiSummaryCard(summary: summary, language: widget.language),
      _RunError(:final error) => _EmptyState(
          text: 'Repository threw: $error → UI would fall back to cache or hide.',
        ),
    };
  }
}

class _ScenarioChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _ScenarioChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onPressed(),
      );
}

class _EmptyState extends StatelessWidget {
  final String text;

  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      );
}

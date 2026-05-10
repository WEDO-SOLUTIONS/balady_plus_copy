import 'dart:io';
import 'dart:math';

import 'package:mapness/features/ai_summary/data/ai_summary_repository.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/features/ai_summary/ui/_preview_fixtures.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// In-memory [AiSummaryRepository] used during development.
///
/// Picks a fixture from [_preview_fixtures] based on a hash of
/// the POI id and returns it after a simulated network delay.
/// Behaviour flags let us exercise edge cases (offline, upstream
/// error, insufficient data) without touching a real backend.
///
/// This class will be replaced by `HttpAiSummaryRepository` once
/// the backend endpoint is live — the swap is a single line in
/// `ai_summary_repository_provider.dart`.
class MockAiSummaryRepository implements AiSummaryRepository {
  final Duration latency;
  final bool simulateOffline;
  final bool simulateError;
  final bool simulateInsufficient;

  const MockAiSummaryRepository({
    this.latency = const Duration(milliseconds: 1500),
    this.simulateOffline = false,
    this.simulateError = false,
    this.simulateInsufficient = false,
  });

  @override
  Future<AiSummary?> fetchSummary(String poiId, Language locale) async {
    await Future<void>.delayed(latency);

    if (simulateOffline) {
      throw const SocketException('Mock: simulated offline');
    }
    if (simulateError) {
      throw Exception('Mock: simulated upstream error');
    }
    if (simulateInsufficient) {
      return null;
    }

    return _pickFixture(poiId, locale);
  }

  AiSummary _pickFixture(String poiId, Language locale) {
    final fixtures = locale.isArabic ? _arFixtures : _enFixtures;
    // Stable-per-POI selection so repeat calls for the same id
    // always return the same fixture (simulates backend caching).
    final index = Random(poiId.hashCode).nextInt(fixtures.length);
    return fixtures[index];
  }

  static final List<AiSummary> _enFixtures = [
    previewEnRegularWithRating,
    previewEnRegularNoRating,
    previewEnShort,
    previewEnLong,
    previewEnTransitBusStation,
  ];

  static final List<AiSummary> _arFixtures = [
    previewArRegularWithRating,
    previewArTransitBusStation,
  ];
}

import 'package:mapness/features/ai_summary/data/ai_summary_repository.dart';
import 'package:mapness/features/ai_summary/data/mock_ai_summary_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_summary_repository_provider.g.dart';

/// Dependency-injection seam for the [AiSummaryRepository].
///
/// Currently returns [MockAiSummaryRepository] so the rest of
/// the feature (notifier, UI) can be built and smoke-tested
/// against deterministic fixtures while the backend endpoint
/// is still being specified.
///
/// When the real endpoint is live, swap the return statement
/// to `HttpAiSummaryRepository()` (see the
/// `http_ai_summary_repository.dart` docstring for the list of
/// backend answers needed before that swap is safe).
@Riverpod(keepAlive: true)
AiSummaryRepository aiSummaryRepository(Ref ref) => const MockAiSummaryRepository();

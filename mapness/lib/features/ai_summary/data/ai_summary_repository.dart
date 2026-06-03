import 'package:dio/dio.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// Abstraction over the AI Summary data source.
///
/// Two implementations live alongside this interface:
/// * [MockAiSummaryRepository] — v1 in-memory fixture-based
///   implementation used during development while the backend
///   endpoint is still unspecified.
/// * [HttpAiSummaryRepository] — skeleton for the future real
///   network-backed implementation. Currently throws
///   `UnimplementedError`; will be filled in once the backend
///   team confirms host/method/response shape.
///
/// A `null` result from [fetchSummary] means the backend (or,
/// in the mock case, the fixture map) determined there was
/// insufficient data to generate a summary for this POI. The
/// UI layer hides the section entirely in that case.
///
/// Implementations should throw on network / upstream errors
/// rather than returning `null` — the notifier layer is
/// responsible for distinguishing "no data" from "load failed"
/// and rendering accordingly (both end up hidden from the user,
/// but failures may retry / fall back to cache).
abstract class AiSummaryRepository {
  Future<AiSummary?> fetchSummary(String poiId, Language locale, {CancelToken? cancelToken});
}

import 'package:mapness/features/ai_summary/data/ai_summary_repository.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// Real network-backed [AiSummaryRepository] — **skeleton only**.
///
/// Currently throws [UnimplementedError] on every call. To be
/// filled in once the backend team confirms the following open
/// questions (see Slack thread in #balady-mobile):
///
/// 1. **Host & path**: confirmed Apigee host? Full path?
/// 2. **HTTP method**: spec says `POST`, confirm? Body shape?
/// 3. **Response shape**: JSON envelope? Streaming (SSE, NDJSON)
///    or regular `application/json`? If streaming, how is the
///    end signalled?
/// 4. **Auth**: same SSO bearer as the rest of the balady API,
///    or separate flow?
/// 5. **Locale header**: `Accept-Language: ar-SA` per the spec,
///    or reuse `X-Locale` / `X-Language` that `dgis_http_network`
///    already sets?
/// 6. **Rating & transit lines**: included in the AI Summary
///    response alongside the description, or do we pull them
///    from the existing POI detail endpoint?
/// 7. **"Insufficient data" signal**: 204 No Content, empty body,
///    JSON flag like `{"available": false}`, or error code?
/// 8. **Error shape**: how are upstream LLM timeouts / rate
///    limits / POI-not-found surfaced?
///
/// Until answered, the swap from [MockAiSummaryRepository] stays
/// blocked at the DI provider. Once unblocked, replace the body
/// of [fetchSummary] with a Dio call and map the response to
/// [AiSummary.fromJson].
class HttpAiSummaryRepository implements AiSummaryRepository {
  const HttpAiSummaryRepository();

  @override
  Future<AiSummary?> fetchSummary(String poiId, Language locale) {
    throw UnimplementedError(
      'HttpAiSummaryRepository is not yet implemented. '
      'Waiting on backend team for endpoint confirmation '
      '(host, method, response shape, auth). '
      'See Slack thread in #balady-mobile and the docstring '
      'in this class for the list of open questions.',
    );
  }
}

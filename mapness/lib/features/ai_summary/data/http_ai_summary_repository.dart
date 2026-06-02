import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/ai_summary/data/ai_summary_repository.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Network-backed [AiSummaryRepository] hitting the Momrah AI
/// Summary endpoint.
///
/// The endpoint sits on a sibling path (`/1.0/`) instead of the
/// usual `/api/1.0/`, so [dio] is expected to be pre-configured
/// with the correct base URL by the DI provider.
///
/// Response shape (200 OK):
///
/// ```json
/// {
///   "description": "...",
///   "rating": 4.8,
///   "ratingTotal": 5,
///   "ratingCount": 62426,
///   "sources": { ... },
///   "cached": false
/// }
/// ```
///
/// `rating` and `ratingCount` are siblings of `description` — there
/// is no `metadata` envelope. Both are optional; the rating row is
/// rendered only when both are present.
///
/// `transitLines` is intentionally never populated — the upstream
/// response does not include any transit data, so the field stays
/// `null` and the UI renders without the badges row.
///
/// Behaviour:
/// * 200 → mapped to [AiSummary] (description + optional rating).
/// * 404 → treated as "insufficient data" → returns `null` so the
///   section is hidden.
/// * any other failure → rethrown for the notifier layer to catch.
class HttpAiSummaryRepository implements AiSummaryRepository {
  final Dio _dio;

  const HttpAiSummaryRepository(this._dio);

  @override
  Future<AiSummary?> fetchSummary(String poiId, Language locale, {CancelToken? cancelToken}) async {
    final body = <String, dynamic>{
      'syncode': poiId,
      'locale': locale.languageCode,
      'stream': false,
    };

    if (kDebugMode) {
      debugPrint('[AiSummaryDebug] POST ai-summary/$poiId locale=${locale.languageCode}');
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'ai-summary/$poiId',
        data: body,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'Accept-Language': locale == Language.arabic ? 'ar-SA' : 'en-SA',
          },
        ),
      );

      final data = response.data;
      if (data == null) {
        if (kDebugMode) {
          debugPrint('[AiSummaryDebug] empty body for $poiId — treating as null');
        }
        return null;
      }
      final summary = _mapResponse(data);
      if (kDebugMode) {
        debugPrint(
          '[AiSummaryDebug] ok $poiId — desc=${summary.description.length}ch '
          'rating=${summary.rating} count=${summary.reviewCount}',
        );
      }
      return summary;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        rethrow;
      }
      if (e.response?.statusCode == 404) {
        if (kDebugMode) {
          debugPrint('[AiSummaryDebug] 404 for $poiId — insufficient data');
        }
        return null;
      }
      logger.log(
        'AI Summary HTTP error for $poiId: ${e.response?.statusCode} ${e.message}',
        logLevel: MapnessLogLevel.error,
      );
      rethrow;
    }
  }

  AiSummary _mapResponse(Map<String, dynamic> json) {
    final description = (json['description'] as String?)?.trim() ?? '';

    double? rating;
    final r = json['rating'];
    if (r is num) {
      rating = r.toDouble();
    }

    int? reviewCount;
    final c = json['ratingCount'];
    if (c is num) {
      reviewCount = c.toInt();
    }

    return AiSummary(
      description: description,
      rating: rating,
      reviewCount: reviewCount,
    );
  }
}

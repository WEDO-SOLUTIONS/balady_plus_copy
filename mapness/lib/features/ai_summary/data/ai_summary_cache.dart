import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_summary_cache.g.dart';

/// Default time-to-live for cached AI summaries.
///
/// Matches the 60-minute TTL used by the surrounding POI card
/// cache in `poi_card_provider.dart` — if that ever changes for
/// a good reason, this should follow suit.
const Duration _defaultAiSummaryCacheTtl = Duration(minutes: 60);

/// On-device cache for AI summaries.
///
/// Backed by a dedicated Hive box keyed by `"$poiId $locale"` so
/// that switching app language automatically misses the cache
/// and triggers a re-fetch in the new locale.
///
/// Each entry stores the [AiSummary] JSON wrapped in a small
/// envelope that also carries the insertion timestamp. Entries
/// older than [ttl] are treated as absent.
class AiSummaryCache {
  final Box<dynamic> _box;
  final Duration ttl;

  AiSummaryCache(this._box, {this.ttl = _defaultAiSummaryCacheTtl});

  AiSummary? get(String poiId, Language locale) {
    final raw = _box.get(_key(poiId, locale));
    if (raw is! String) {
      return null;
    }
    try {
      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      final ts = envelope['timestamp'] as int?;
      final data = envelope['data'] as Map<String, dynamic>?;
      if (ts == null || data == null) {
        return null;
      }
      final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(ts));
      if (age > ttl) {
        return null;
      }
      return AiSummary.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> put(String poiId, Language locale, AiSummary summary) async {
    final envelope = <String, dynamic>{
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': summary.toJson(),
    };
    await _box.put(_key(poiId, locale), jsonEncode(envelope));
  }

  Future<void> invalidate(String poiId, Language locale) async {
    await _box.delete(_key(poiId, locale));
  }

  Future<void> clear() async {
    await _box.clear();
  }

  String _key(String poiId, Language locale) => '$poiId ${locale.name}';
}

@Riverpod(keepAlive: true)
Future<AiSummaryCache> aiSummaryCache(Ref ref) async {
  final box = await ref.watch(hiveProvider(MapnessConstants.aiSummaryCacheBoxName).future);
  return AiSummaryCache(box);
}

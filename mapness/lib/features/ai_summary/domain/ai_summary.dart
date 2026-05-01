import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/ai_summary/domain/transit_line.dart';

part 'ai_summary.freezed.dart';
part 'ai_summary.g.dart';

/// A single AI-generated summary of a POI, as displayed inside
/// the expanded POI bottom sheet.
///
/// A `null` result from the repository indicates "insufficient
/// data" — the UI hides the section entirely in that case.
///
/// [rating] and [reviewCount] are optional. When either is
/// absent the rating bar is omitted from the card.
///
/// [transitLines] is only non-empty for bus/metro station POIs.
/// When present, a row of colour-coded line badges is rendered
/// underneath the description (and rating, if any).
@freezed
abstract class AiSummary with _$AiSummary {
  factory AiSummary({
    required final String description,
    final double? rating,
    final int? reviewCount,
    final List<TransitLine>? transitLines,
  }) = _AiSummary;

  factory AiSummary.fromJson(Map<String, dynamic> json) => _$AiSummaryFromJson(json);
}

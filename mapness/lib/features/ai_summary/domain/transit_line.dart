import 'package:freezed_annotation/freezed_annotation.dart';

part 'transit_line.freezed.dart';
part 'transit_line.g.dart';

/// A single bus / metro line that serves a transit POI.
///
/// Rendered as a coloured pill badge underneath the AI summary
/// description for station POIs. [headsign] is shown on the
/// badge in English locale only — it is hidden in Arabic mode
/// because the upstream data source returns headsigns in
/// English regardless of the requested locale.
@freezed
abstract class TransitLine with _$TransitLine {
  factory TransitLine({
    required final String shortName,
    required final int colorArgb,
    final String? headsign,
  }) = _TransitLine;

  factory TransitLine.fromJson(Map<String, dynamic> json) => _$TransitLineFromJson(json);
}

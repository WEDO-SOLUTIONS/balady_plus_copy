part of 'bss_payload.dart';

class BssSearchResultList {
  const BssSearchResultList({
    required this.size,
    this.searchType,
    this.firstResultClass,
    this.contextRubrics,
    this.contextAttributes,
    this.searchSegmentId,
    this.building,
  });

  /// Number of elements in the list. Can be 0, because we agreed to register the event "showing empty results".
  final int size;

  /// User interest class.
  /// Set by search:
  /// 1. UniSearch::Results::GetDGisSearchType()
  /// 2. Sapphire dgis_search_type
  /// May not match the class of the first result
  /// of the search query. For example, the user requested
  /// "Vatutina 107", and the search responded with a hybrid Mega card.
  final ResultClassEnum? searchType;

  /// The class of the first result of a search query.
  /// Set by search:
  /// 1. UniSearch::Results::GetDGisOutputType()
  /// 2. Sapphiredgis_output_type
  /// Cannot be determined for queries with no results.
  ///
  /// IMPORTANT: We have decided to put here [searchType] value because SDK do not return this value for values from search result
  final ResultClassEnum? firstResultClass;

  /// Array of short identifiers of contextual headings. If there are no contextual headings (for example, in case of unsuccessful queries),
  /// the attribute does not need to be sent.
  ///
  /// IMPORTANT: Response from BSS team: if not exists, we should not send this field.
  final List<BssStringId>? contextRubrics;

  /// Array of contextual attribute identifiers in the text of the search query. Specified by the search. For example, for the query "Italian cuisine cafe with live music",
  /// the contextAttributes should include the attribute ids7 0000201006748040 "Italian cuisine" and 70000201006747993 "live music".
  /// If there are no contextual attributes (for example, for unsuccessful queries), the attribute does not need to be sent.
  ///
  /// IMPORTANT: Response from BSS team: if not exists, we should not send this field.
  final List<BssStringId>? contextAttributes;

  /// Segment defined by search
  ///
  /// IMPORTANT: Response from BSS team: if not exists, we should not send this field.
  final BssStringId? searchSegmentId;

  /// Building identifier.
  final BssStringId? building;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'size': size,
    };
    if (searchType != null) {
      data['searchType'] = searchType!.value;
    }
    if (firstResultClass != null) {
      data['firstResultClass'] = firstResultClass!.value;
    }
    if (contextRubrics != null) {
      data['contextRubrics'] = contextRubrics!.map((e) => e.toString()).toList();
    }
    if (contextAttributes != null) {
      data['contextAttributes'] = contextAttributes!.map((e) => e.toString()).toList();
    }
    if (searchSegmentId != null) {
      data['searchSegmentId'] = searchSegmentId;
    }
    if (building != null) {
      data['building'] = building;
    }
    return data;
  }
}

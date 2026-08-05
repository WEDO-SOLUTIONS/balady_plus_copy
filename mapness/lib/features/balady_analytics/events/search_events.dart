import 'package:dgis_map/library.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';

/// Phase-1 search events for the Balady analytics pipeline (PostHog) — see
/// docs/analytics-tracking-plan.md, "Search" section. Event names are immutable
/// once shipped, so both names and enumerated property values live in this file
/// only as string literals.

/// `source` of `search_performed` — the surface the search ran on.
enum SearchEventSource {
  map('map'),
  landing('landing'),
  navi('navi');

  const SearchEventSource(this.value);

  final String value;
}

/// `result_type` of `search_result_selected`.
enum SearchResultType {
  poi('poi'),
  address('address'),
  category('category'),
  history('history');

  const SearchResultType(this.value);

  final String value;
}

const _queryMaxLength = 100;

/// Canonical form of a search query for analytics: lowercase, trimmed, inner
/// whitespace collapsed to single spaces, capped at 100 chars — so "Mecca",
/// "mecca " and "MECCA" count as one query (tracking plan, PII section).
String canonicalizeQuery(String query) {
  final canonical = query.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  return canonical.length <= _queryMaxLength ? canonical : canonical.substring(0, _queryMaxLength);
}

/// `search_performed` — a query was executed and results arrived (fired once
/// per executed search, after debounce, never per keystroke).
void trackSearchPerformed({required String query, required SearchEventSource source, required int resultsCount}) {
  BaladyAnalytics.instance.track(
    'search_performed',
    properties: {
      'query': canonicalizeQuery(query),
      'source': source.value,
      'results_count': resultsCount,
    },
  );
}

/// `search_result_selected` — a search result (or history record) was tapped.
/// [rank] is the 1-based position of the tapped row in its list.
void trackSearchResultSelected({required String query, required int rank, required SearchResultType resultType}) {
  BaladyAnalytics.instance.track(
    'search_result_selected',
    properties: {
      'query': canonicalizeQuery(query),
      'rank': rank,
      'result_type': resultType.value,
    },
  );
}

/// `result_type` of a tapped directory object: address/road-network objects →
/// [SearchResultType.address]; everything else (branches, attractions,
/// stations, `unknown`/place) → [SearchResultType.poi].
SearchResultType searchResultTypeOf(DirectoryObjectMessage item) => switch (item.types.firstOrNull?.type) {
  ObjectTypeMessage.admDiv ||
  ObjectTypeMessage.admDivCity ||
  ObjectTypeMessage.admDivCountry ||
  ObjectTypeMessage.admDivDistrict ||
  ObjectTypeMessage.admDivDistrictArea ||
  ObjectTypeMessage.admDivDivision ||
  ObjectTypeMessage.admDivLivingArea ||
  ObjectTypeMessage.admDivPlace ||
  ObjectTypeMessage.admDivRegion ||
  ObjectTypeMessage.admDivSettlement ||
  ObjectTypeMessage.building ||
  ObjectTypeMessage.coordinates ||
  ObjectTypeMessage.crossroad ||
  ObjectTypeMessage.gate ||
  ObjectTypeMessage.kilometerRoadSign ||
  ObjectTypeMessage.road ||
  ObjectTypeMessage.street => SearchResultType.address,
  _ => SearchResultType.poi,
};

/// `result_type` of a tapped suggestion, or null when the tap is not a result
/// selection (incomplete-text suggestions only refine the typed query).
/// Object suggestions map like directory objects; the rest map by the SDK
/// suggestion type — rubric/brand/attribute suggestions run a category-style
/// search → [SearchResultType.category].
SearchResultType? suggestResultTypeOf(SuggestMessage suggest) {
  if (suggest.handler.incompleteTextHandler != null) {
    return null;
  }
  final object = suggest.handler.objectHandler?.item;
  if (object != null) {
    return searchResultTypeOf(object);
  }
  return switch (suggest.suggestedType) {
    SuggestedTypeMessage.admDivCity ||
    SuggestedTypeMessage.admDivCountry ||
    SuggestedTypeMessage.admDivDistrict ||
    SuggestedTypeMessage.admDivDistrictArea ||
    SuggestedTypeMessage.admDivDivision ||
    SuggestedTypeMessage.admDivLivingArea ||
    SuggestedTypeMessage.admDivPlace ||
    SuggestedTypeMessage.admDivRegion ||
    SuggestedTypeMessage.admDivSettlement ||
    SuggestedTypeMessage.building ||
    SuggestedTypeMessage.coordinates ||
    SuggestedTypeMessage.crossroad ||
    SuggestedTypeMessage.kilometerRoadSign ||
    SuggestedTypeMessage.road ||
    SuggestedTypeMessage.street => SearchResultType.address,
    SuggestedTypeMessage.attraction ||
    SuggestedTypeMessage.branch ||
    SuggestedTypeMessage.org ||
    SuggestedTypeMessage.parking ||
    SuggestedTypeMessage.route ||
    SuggestedTypeMessage.station ||
    SuggestedTypeMessage.stationEntrance ||
    SuggestedTypeMessage.stationMetro => SearchResultType.poi,
    _ => SearchResultType.category,
  };
}

import 'dart:math';

/// Shared payload models for the DataFinder (BytePlus) Phase-1 search events.
///
/// Feature code builds these objects once at the call site; the analytics
/// service decides where each event is sent (BytePlus / BSS / both). Feature
/// code never imports an SDK directly.
///
/// Field names/values follow the authoritative
/// "Balady User Behavior Tracking Metrics" spec (CSV) + ByteDance (Jian) chat:
///  * `request_id`  — client-generated UUID per SDK call (no server correlation).
///  * `search_param`— a flat query string (q, viewpoint1/2, suggest_type,
///                    page_size, location), per the CSV format.
///  * `poi_type`    — the API `type` string (e.g. "street", "branch"), NOT rubric id.
///  * `poi_distance`— kilometres rounded to 2 decimals, min 0.01 km.
///  * exposure      — list-level, only items actually rendered are reported.

/// The page/entry point where an event originated — the `event_source`
/// attribute. Values are the exact enumerated strings from the spec.
enum DataFinderSourcePage {
  mapMainPage('Map-Main Page'),
  mapDirectionPathChanging('Map-Direction-Path Changing'),
  exploreMainPage('Explore-Main Page'),
  exploreFreeRoam('Explore-Free Roam'),
  exploreDirection('Explore-Direction'),
  exploreDirectionPathChanging('Explore-Direction-Path Changing'),
  routesMainPage('Routes-Main Page'),
  routesPathChanging('Routes-Path Changing');

  const DataFinderSourcePage(this.value);

  /// The exact string the spec expects in the `event_source` field.
  final String value;
}

/// The surface where a user **journey started** — the "controller" the user
/// first interacted with on the single map screen. Balady is one map screen
/// with overlay controllers, so `event_source` is not a route: it is decided by
/// the entry control the user touched (a map POI, the Explore tab UI, the Routes
/// flow, or Free Roam) and then carried through navigation + search + favorite.
///
/// The final `event_source` is [resolve]d by combining this origin with the
/// current navigation state (in-navigation → "Direction", editing a drawn route
/// → "Path Changing").
enum DataFinderOrigin {
  /// A POI tapped directly on the map → `Map-*`.
  map,

  /// The Explore tab UI (Quick Filters, Explore search bar) → `Explore-*`.
  /// This is the default before any other origin is stamped.
  explore,

  /// The Routes (route-planning) flow → `Routes-*`.
  routes,

  /// Free Roam mode → `Explore-Free Roam`.
  freeRoam;

  /// Combines this origin with the live navigation state into the final
  /// `event_source`. [inNavigation] is true while turn-by-turn navigation is
  /// active (`PathNavRoute`); [pathChanging] is true while a drawn route is
  /// being edited (`RoutingRoutesRoute`/`RouteDetailsRoute`).
  DataFinderSourcePage resolve({required bool inNavigation, required bool pathChanging}) {
    switch (this) {
      case DataFinderOrigin.freeRoam:
        // Free Roam has a single surface value regardless of nav state.
        return DataFinderSourcePage.exploreFreeRoam;
      case DataFinderOrigin.routes:
        return pathChanging ? DataFinderSourcePage.routesPathChanging : DataFinderSourcePage.routesMainPage;
      case DataFinderOrigin.map:
        if (pathChanging) {
          return DataFinderSourcePage.mapDirectionPathChanging;
        }
        // Map journeys stay "Map-Main Page" through Directions → Go → Search,
        // per the BRD's Map-Main flows 2–5.
        return DataFinderSourcePage.mapMainPage;
      case DataFinderOrigin.explore:
        if (pathChanging) {
          return DataFinderSourcePage.exploreDirectionPathChanging;
        }
        if (inNavigation) {
          return DataFinderSourcePage.exploreDirection;
        }
        return DataFinderSourcePage.exploreMainPage;
    }
  }
}

/// `favorite_type` for the `favorite_add` event. All POIs other than Home/Work
/// are "Not Specified".
enum DataFinderFavoriteType {
  home('Home'),
  work('Work'),
  notSpecified('Not Specified');

  const DataFinderFavoriteType(this.value);

  final String value;
}

/// `operation_type` for `search_box_input`.
enum DataFinderInputOperation {
  /// Clicked directly from search history.
  history('History'),

  /// Entered manually.
  manual('Manual');

  const DataFinderInputOperation(this.value);

  final String value;
}

/// `search_type` for `search_results_exposure`.
enum DataFinderSearchType {
  quickSearch('Quick search'),
  history('History'),
  clickSuggestion('Click suggestion'),
  manual('Manual'),
  searchInThisArea('Search in this area');

  const DataFinderSearchType(this.value);

  final String value;
}

/// `click_action` for `search_results_click`.
enum DataFinderClickAction {
  viewPoiDetails('View POI Details'),
  initiateNavigation('Initiate Navigation'),
  sharePoi('Share POI'),
  addToFavorites('Add to Favorites');

  const DataFinderClickAction(this.value);

  final String value;
}

/// Builds the `search_param` flat string the spec requires, e.g.
/// `q=mall&viewpoint1=24.7,46.5&viewpoint2=24.8,46.7&suggest_type=org&page_size=20&location=24.75,46.6`.
/// Only the available parts are included.
class DataFinderSearchParam {
  const DataFinderSearchParam({
    this.q,
    this.viewpoint1,
    this.viewpoint2,
    this.suggestType,
    this.pageSize,
    this.location,
  });

  /// The user's query text.
  final String? q;

  /// Viewport corner 1 as (lat, lon).
  final (double, double)? viewpoint1;

  /// Viewport corner 2 as (lat, lon).
  final (double, double)? viewpoint2;

  /// Suggestor type (suggest only).
  final String? suggestType;

  /// Page size (default 20 on full search).
  final int? pageSize;

  /// User's current location as (lat, lon).
  final (double, double)? location;

  /// The flat `key=value&...` string. Returns an empty string when nothing is
  /// available.
  String toQueryString() {
    final parts = <String>[];
    if (q != null && q!.isNotEmpty) {
      parts.add('q=$q');
    }
    if (viewpoint1 != null) {
      parts.add('viewpoint1=${viewpoint1!.$1},${viewpoint1!.$2}');
    }
    if (viewpoint2 != null) {
      parts.add('viewpoint2=${viewpoint2!.$1},${viewpoint2!.$2}');
    }
    if (suggestType != null && suggestType!.isNotEmpty) {
      parts.add('suggest_type=$suggestType');
    }
    if (pageSize != null) {
      parts.add('page_size=$pageSize');
    }
    if (location != null) {
      parts.add('location=${location!.$1},${location!.$2}');
    }
    return parts.join('&');
  }
}

/// POI fields shared by suggestion/result/favorite events.
///
/// [type] is the 2GIS API object-type **string** (e.g. "street", "branch",
/// "building", "adm_div"), not the numeric rubric id — per ByteDance.
class DataFinderPoi {
  const DataFinderPoi({
    this.id,
    this.name,
    this.address,
    this.type,
    this.distanceKm,
    this.rank,
    this.suggestionType,
  });

  /// 2GIS object id (`DirectoryObjectMessage.id.objectId`). Null for anonymous
  /// geo-objects and non-object suggestions.
  final String? id;

  final String? name;

  final String? address;

  /// API `type` string (NOT rubric id). May be null.
  final String? type;

  /// Distance from the user in **kilometres**, rounded to 2 decimals (min 0.01).
  /// Null when POI position or user location is unavailable.
  final double? distanceKm;

  /// 1-based rank within the list (suggestion_rank / poi_rank).
  final int? rank;

  /// The SDK suggestion type (`branch`, `rubric`, `street`, …) for
  /// `suggestion_*` events. Distinct from [type] (the object type / `poi_type`).
  /// Null for non-suggestion POIs.
  final String? suggestionType;

  /// Returns a copy with the given fields replaced.
  DataFinderPoi copyWith({
    String? id,
    String? name,
    String? address,
    String? type,
    double? distanceKm,
    int? rank,
    String? suggestionType,
  }) =>
      DataFinderPoi(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        type: type ?? this.type,
        distanceKm: distanceKm ?? this.distanceKm,
        rank: rank ?? this.rank,
        suggestionType: suggestionType ?? this.suggestionType,
      );

  /// Distance from the user, in km rounded to 2 decimals with a 0.01 km floor.
  static double? formatDistanceKm(double? meters) {
    if (meters == null) {
      return null;
    }
    final km = meters / 1000;
    final rounded = (km * 100).round() / 100;
    return rounded < 0.01 ? 0.01 : rounded;
  }

  /// `poi_*` keys — for favorite / search-results events.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['poi_id'] = id;
    }
    if (name != null) {
      data['poi_name'] = name;
    }
    if (address != null) {
      data['poi_addr'] = address;
    }
    if (type != null) {
      data['poi_type'] = type;
    }
    if (distanceKm != null) {
      data['poi_distance'] = distanceKm;
    }
    if (rank != null) {
      data['poi_rank'] = rank;
    }
    return data;
  }

  /// `suggestion_*` keys — for the `suggestion_exposure` event (per the BRD,
  /// which uses suggestion_poi_id / suggestion_poi_addr / suggestion_distance /
  /// suggestion_name / suggestion_rank, and has no `poi_*` keys).
  Map<String, dynamic> toSuggestionJson() {
    final data = <String, dynamic>{};
    if (name != null) {
      data['suggestion_name'] = name;
    }
    if (suggestionType != null) {
      data['suggestion_type'] = suggestionType;
    }
    if (id != null) {
      data['suggestion_poi_id'] = id;
    }
    if (address != null) {
      data['suggestion_poi_addr'] = address;
    }
    if (distanceKm != null) {
      data['suggestion_distance'] = distanceKm;
    }
    if (rank != null) {
      data['suggestion_rank'] = rank;
    }
    return data;
  }
}

/// Generates client-side correlators (UUID v4) for `request_id` and the
/// per-flow session ids. These are app-scoped and cannot be matched to 2GIS
/// server logs — confirmed acceptable by ByteDance.
class DataFinderIds {
  DataFinderIds._();

  static final Random _rnd = Random.secure();

  /// RFC-4122 version-4 UUID, e.g. `3f2504e0-4f89-41d3-9a0c-0305e82c3301`.
  static String uuid() {
    final bytes = List<int>.generate(16, (_) => _rnd.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 10
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).toList();
    return '${hex.sublist(0, 4).join()}-${hex.sublist(4, 6).join()}-'
        '${hex.sublist(6, 8).join()}-${hex.sublist(8, 10).join()}-'
        '${hex.sublist(10, 16).join()}';
  }
}

part of 'metrics_event.dart';

enum MetricsFavouriteType {
  home,
  work,
  notSpecified;

  static MetricsFavouriteType fromFavouriteItemMarkerType(FavouriteItemMarkerType value) => switch (value) {
    FavouriteItemMarkerType.home => MetricsFavouriteType.home,
    FavouriteItemMarkerType.work => MetricsFavouriteType.work,
    FavouriteItemMarkerType.place || FavouriteItemMarkerType.unknown => MetricsFavouriteType.notSpecified,
  };

  FavouriteItemMarkerType toFavouriteItemMarkerType() => switch (this) {
    MetricsFavouriteType.home => FavouriteItemMarkerType.home,
    MetricsFavouriteType.work => FavouriteItemMarkerType.work,
    MetricsFavouriteType.notSpecified => FavouriteItemMarkerType.place,
  };
}

enum MetricsSearchBoxInputOperationType {
  history('History'),
  manual('Manual');

  final String value;

  const MetricsSearchBoxInputOperationType(this.value);
}

enum MetricsSuggestionExposureSuggestionType { poiGroup, poi }

// TODO(metrics): strange that only one value available. Check bytedance metrics doc once again
enum MetricsSearchButtonClickTriggerMethod { keyboard }

enum MetricsSearchResultsExposureSearchType {
  quickSearch,
  history,
  clickSuggestion,
  manual,
  searchInThis,
  area,
}

enum MetricsSearchResultsClickActionType {
  viewPoiDetails('View POI Details'),
  initiateNavigation('Initiate Navigation'),
  sharePoi('Share POI'),
  addToFavorites('Add to Favorites');

  final String value;

  const MetricsSearchResultsClickActionType(this.value);
}

enum MetricsByteDanceEventSource {
  // Main Page -> select POI -> tap 'Directions' -> start navigation -> open Search -> click Quick Search button
  mapMainPage('Map-Main Page'),
  // Main Page -> select POI -> tap 'Directions' -> open Path Changing -> select point -> click on Quick Search
  mapDirectionPathChanging('Map-Direction-Path Changing'),
  exploreMainPage('Explore-Main Page'),
  exploreFreeRoam('Explore-Free Roam'),
  exploreDirection('Explore-Direction'),
  exploreDirectionPathChanging('Explore-Direction-Path Changing'),
  routesMainPage('Routes-Main Page'),
  routesPathChanging('Routes-Path Changing');

  final String value;

  const MetricsByteDanceEventSource(this.value);
}

part of 'metrics_event.dart';

enum MetricsFavouriteType { home, work, notSpecified }

enum MetricsSearchBoxInputOperationType { history, manual }

enum MetricsSuggestionExposureSuggestionType { poiGroup, poi }

// todo strange that only one value available. Check bytedance metrics doc once again
enum MetricsSearchButtonClickTriggerMethod { keyboard }

enum MetricsSearchResultsExposureSearchType {
  quickSearch,
  history,
  clickSuggestion,
  manual,
  searchInThis,
  area,
}

enum MetricsFavouriteQuickSearchClickEventSource {
  // Main Page -> select POI -> start navigation -> open Search -> click Quick Search button
  mapMainPage('Map-Main Page'),
  mapDirectionPathChanging('Map-Direction-Path Changing'),
  exploreMainPage('Explore-Main Page'),
  exploreFreeRoam('Explore-Free Roam'),
  exploreDirection('Explore-Direction'),
  routesMainPage('Routes-Main Page'),
  routesPathChanging('Routes-Path Changing');

  final String value;

  const MetricsFavouriteQuickSearchClickEventSource(this.value);
}

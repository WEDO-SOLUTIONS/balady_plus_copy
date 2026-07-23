import 'package:mapness/features/app_analytics/models/datafinder_models.dart';

abstract interface class AppAnalyticsRepository {
  void onboardingFlowStarted();

  void onboardingFlowSkipped();

  void onboardingFlowCompleted();
  void navigationSearch({
    required String destinationCity,
    required String keyword,
    required String originCity,
    required bool isResultsFound,
    required int resultCount,
  });

  void navigationStarted({
    required String originLocation,
    required String destinationLocation,
    required String destinationCity,
    required String originCity,
    required int estimateTime,
    required double estimateDistance,
  });

  void userMovementDetected({
    required String destinationCity,
    required String originCity,
  });

  void navigationHalfWay({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
    required Duration spentTime,
    required String midPoint,
  });

  void navigationCompleted({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
    required Duration spentTime,
  });

  void setUserInfo({
    String? email,
    String? locale,
    String? deviceId,
    String? deviceOs,
    String? appVersion,
    String? userId,
    String? phone,
    String? firstName,
    String? lastName,
  });

  void categorySelected(String category);

  void serviceSectionVisited();

  void quickActionSelected(String action);

  void appIconQuickActionSelected({
    required String action,
    required String outcome,
    String? reason,
  });

  void carPlayConnected();

  void poiContributionUsed({required String type});

  void isNavigationUser({bool isNavUser});

  Future<void> deviceTypeDetected();

  void networkConnectionType({required String type});

  void transportModeSelected({required String type});
}

/// Optional analytics capability for the DataFinder (ByteDance) search events.
///
/// A backend implements this **only if it should receive these events**. The
/// composite checks `impl is DataFinderAnalyticsRepository` and routes the
/// event only to backends that opted in. Today only BytePlus implements it;
/// Insider does not, so Insider never receives these events.
///
/// To send a future event to another tool (e.g. BSS) with a different key or
/// shape, have that tool's impl also implement this interface — no caller and
/// no other backend changes.
abstract interface class DataFinderAnalyticsRepository {
  /// `search_box_click` — search box gains focus. [isFirstClick] marks the
  /// first search after opening the app (or after 5 min inactivity).
  void searchBoxClick({
    required DataFinderSourcePage eventSource,
    required bool isFirstClick,
  });

  /// `search_box_input` — text entered in the search box.
  void searchBoxInput({
    required DataFinderInputOperation operationType,
    required String inputText,
  });

  /// `search_button_click` — user taps the keyboard search button.
  void searchButtonClick({
    required DataFinderSourcePage eventSource,
    required String searchText,
    String triggerMethod = 'Keyboard',
  });

  /// `quick_search_click` — quick search button, or Favorite/Home/Work selected.
  void quickSearchClick({
    required DataFinderSourcePage eventSource,
    required String searchText,
  });

  /// `favorite_add` — user adds a POI to favorites.
  void favoriteAdd({
    required DataFinderSourcePage eventSource,
    required DataFinderFavoriteType favoriteType,
    required DataFinderPoi poi,
  });

  /// `suggestion_exposure` — the suggestion list is shown (list-level).
  /// [pois] must contain ONLY the items actually rendered.
  void suggestionExposure({
    required String requestId,
    required String sessionId,
    required String searchText,
    required DataFinderSearchParam searchParam,
    required List<DataFinderPoi> pois,
  });

  /// `suggestion_click` — user taps a suggestion.
  void suggestionClick({
    required DataFinderSourcePage eventSource,
    required String requestId,
    required String sessionId,
    required String searchText,
    required String suggestionType,
    required DataFinderPoi poi,
  });

  /// `search_results_exposure` — the results list is shown (list-level).
  /// [pois] must contain ONLY the items actually rendered.
  void searchResultsExposure({
    required DataFinderSourcePage eventSource,
    required String requestId,
    required String sessionId,
    required String searchText,
    required DataFinderSearchType searchType,
    required DataFinderSearchParam searchParam,
    required List<DataFinderPoi> pois,
  });

  /// `search_results_click` — user taps a search result.
  void searchResultsClick({
    required DataFinderSourcePage eventSource,
    required String requestId,
    required String sessionId,
    required String searchText,
    required DataFinderClickAction clickAction,
    required DataFinderPoi poi,
  });
}

/// The full analytics surface callers see via the provider: the base events
/// plus the DataFinder capability. The composite routes each event only to the
/// backends that support it, so depending on this combined type does not force
/// every backend to implement everything.
abstract interface class AppAnalyticsApi implements AppAnalyticsRepository, DataFinderAnalyticsRepository {}

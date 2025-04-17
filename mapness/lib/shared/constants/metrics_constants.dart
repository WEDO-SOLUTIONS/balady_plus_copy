class MetricsConstants {
  static const String favoriteTag = 'Favorite';
  static const String searchTag = 'Search';
  static const String routesTag = 'Routes';
  static const String navigationTag = 'Navigation';
  static const String exploreTag = 'Explore';
  static const String poiTag = 'Poi';
  static const String loginTag = 'Login';
  static const String layersTag = 'Layers';
  static const String baladyAppTag = 'BaladyApp';

  static const Favorites favoritesKeys = Favorites();
  static const Explore exploreKeys = Explore();
  static const Routes routesKeys = Routes();
  static const POI poiKeys = POI();
  static const Navigation navigationKeys = Navigation();
  static const Search searchKeys = Search();
  static const Login loginKeys = Login();
  static const Layers layersKeys = Layers();
  static const BaladyApp baladyAppKeys = BaladyApp();
}

class Favorites {
  const Favorites();

  String get edit => 'Edit';
  String get reload => 'Reload';
  String get close => 'Close';
  String get retry => 'Retry';
  String get deleteAll => 'Delete all';
  String get openHomeSearch => 'Open home search';
  String get openHome => 'Open home';
  String get openWorkSearch => 'Open work search';
  String get openWork => 'Open work';
  String get deleteItem => 'Delete item';
  String get openFavoriteItem => 'Open favorite item';
  String get addItems => 'Add items';
  String get deleteItems => 'Delete items';
  String get toggleShowOnMap => 'Toggle show on map';
}

class Explore {
  const Explore();

  String get happinessMapSubmitFeedback => 'Happiness_map/submitFeedback';
  String get placesToVisitBanner => 'Places to visit banner';
  String get trafficLightButton => 'Traffic light button';
  String get navbarExplore => 'Navbar/explore';
  String get navbarRoute => 'Navbar/route';
  String get navbarServices => 'Navbar/services';
  String get navbarProfile => 'Navbar/profile';
  String get qibla => 'Qibla';
  String get weatherIcon => 'Weather icon';
  String get thumbsUpIcon => 'Thumbs Up icon';
  String get layersIcon => 'Layers icon';
  String get compass => 'Compass';
  String get locateMeIcon => 'Locate me icon';
  String get storiesRefresh => 'Stories - Refresh';
  String get storyBanner => 'Story banner';
  String get enhanceUrbanSceneBannerButton => 'Enhance Urban Scene banner button';
  String get placesToShopBanner => 'Places to shop banner';
  String get bookmarkIcon => 'Bookmark icon';
  String get quickFilter => 'Quick filter';
  String get eventsCalendarBanner => 'Events Calendar banner';
  String get eventsCalendarViewAll => 'Events Calendar - View all';
  String get searchField => 'Search field';
  String get storiesClose => 'Stories - close';
  String get prayerTimesBannerBellIcon => 'Prayer Times banner bell icon';
  String get prayerTimesBannerButton => 'Prayer Times banner button';
  String get kingdomCalendarViewAll => 'Kingdom Calendar - View all';
  String get driveBackHome => 'Drive back home - Show routes';
  String navbarClick(String value) => 'Navbar/$value';
}

class Routes {
  const Routes();
  String get searchSuggestion => 'Search/Suggestion from the list';
  String get searchElement => 'Search/Element from the Result list';
  String get searchBackButton => 'Search/Back btn';
  String get searchSubmit => 'Search/Submit';
  String get routeSelectionChangeNavType => 'Route-selection/Change nav type';
  String get routeSelectionGoButton => 'Route-selection/Go btn';
  String get searchHistoryItem => 'Search/History item';
  String get searchOnDelete => 'Search/On delete';
  String get searchClearButton => 'Search/Clear search btn';
  String get startRouteFromFavorite => 'Start route from favorite';
  String get onReorder => 'On reorder';
  String get changeLocation => 'Change location';
  String get routeSelectionReverseRouteDirectionIcon => 'Route-selection/Reverse Route Direction icon';
  String get routeSelectionBack => 'Route-selection/Back';
  String get searchQuery => 'Search/Query';
  String get specifyOnMapDone => 'Specify on map/Done';
  String get specifyOnMapExit => 'Specify on map/Exit';
  String get favoriteBack => 'Favorite/Back';
}

class POI {
  const POI();
  String get object => 'Object';
  String get roadEvent => 'Road event';
  String get map => 'Map';
  String get myLocation => 'My Location';
  String get addToFavorite => 'Add to favorite';
  String get makeRoute => 'Make route';
  String get call => 'Call';
  String get marker => 'Marker';
  String get exitButton => 'Exit button';
  String get favorites => 'Favorites';
  String get share => 'Share';
  String get photo => 'Photo';
  String get entrances => 'Entrances';
  String get tab => 'Tab';
}

class Navigation {
  const Navigation();
  String get soundMode => 'Sound mode';
  String get burgerToggle => 'Burger/toggle';
  String get darkMode => 'Dark mode';
  String get continueTrip => 'Continue trip';
  String get showRoute => 'Show route';
  String get endTripAndShowHome => 'End trip and show home';
  String get endTripAndBuildAnother => 'End trip and build another';
}

class Search {
  const Search();
  String get suggestion => 'Suggestion';
  String get searchResult => 'Search result';
  String get searchField => 'Search field';
  String get exitIcon => 'Exit icon';
  String get searchInThisArea => 'Search in this area';
  // BSA-2161
  String get uniqueSearchInitialized => 'unique_search_initialized';
  String get suggestionPressed => 'suggestion_pressed';
  // search more or by keyboard "search"
  String get searchButtonPressed => 'search_button_pressed';
  // When we pressed on POI from search result
  String get fullSearchResultPressed => 'full_search_result_pressed';
  String get emptySearchResult => 'empty_search_result';
  String get searchResult_ => 'search_result';
  String get emptySuggestResult => 'empty_suggest_result';
  String get suggestResult => 'suggest_result';
}

class Login {
  const Login();
  String get close => 'Close';
  String get signIn => 'Sign-in';
}

class Layers {
  const Layers();
  String get layerSelect => 'Layer select';
  String get exitIcon => 'Exit icon';
  String get complianceOpenRatingBuilding => 'Compliance/open_rating_building';
  String get complianceOpenCreateCompliance => 'Compliance/open_create_compliance';
  String get complianceOpenCompliance => 'Compliance/open_compliance';
}

class BaladyApp {
  const BaladyApp();
  // Load Time
  String get loadTime => 'Load Time';
  String get loadType => 'Load Type';

  // Battery
  String get batteryUsage => 'Battery Usage';
  String get appRuntime => 'App Runtime';
  String get activeProcesses => 'Active Processes';
  String get deviceState => 'Device State';

  // Navi: Lost GPS
  String get lostGpsCount => 'Lost Signal Count';
  String get lostGpsDuration => 'Lost Signal Duration';

  // General
  String get deviceType => 'Device Type';
  String get appVersion => 'App Version';
  String get timestamp => 'Timestamp';
  String get networkType => 'Network Type';
  String get sessionId => 'Session ID';
  String get location => 'Location';
}

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
  static const String themesTag = 'Themes';
  static const String kaabaTourTag = 'KaabaTour';
  static const String makkahPlacesTag = 'MakkahPlaces';

  static const Favorites favoritesKeys = Favorites();
  static const Explore exploreKeys = Explore();
  static const Routes routesKeys = Routes();
  static const POI poiKeys = POI();
  static const Navigation navigationKeys = Navigation();
  static const Search searchKeys = Search();
  static const Login loginKeys = Login();
  static const Layers layersKeys = Layers();
  static const BaladyApp baladyAppKeys = BaladyApp();
  static const Themes themesKeys = Themes();
  static const KaabaTour kaabaTourKeys = KaabaTour();
  static const MakkahPlaces makkahPlacesKeys = MakkahPlaces();
  static const AppIconQuickActions appIconQuickActionsKeys = AppIconQuickActions();

  static const String appIconQuickActionsTag = 'AppIconQuickActions';
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

/// Metrics for special themes (Makkah, Ramadan, Hajj, Foundation Day, National Day)
class Themes {
  const Themes();

  // Theme activation
  String get themeActivated => 'Theme activated';
  String get themeDeactivated => 'Theme deactivated';
  String get themeSessionStart => 'Theme session start';
  String get themeSessionEnd => 'Theme session end';

  // Theme splash
  String get splashShown => 'Splash shown';
  String get splashClosed => 'Splash closed';
  String get splashSkipped => 'Splash skipped';
  String get splashAutoSkipped => 'Splash auto skipped';
  String get splashCompleted => 'Splash completed';

  // Theme dashboard
  String get dashboardLoaded => 'Dashboard loaded';
  String get dashboardScrolled => 'Dashboard scrolled';
  String get dashboardRefreshed => 'Dashboard refreshed';

  // Theme header
  String get headerShown => 'Header shown';
  String get headerTapped => 'Header tapped';
  String get headerIconTapped => 'Header icon tapped';
  String get headerAnimationPlayed => 'Header animation played';

  // Quick actions (themed)
  String get quickActionTapped => 'Quick action tapped';
  String get quickActionRoadEvent => 'Quick action road event';
  String get quickActionSendLocation => 'Quick action send location';
  String get quickActionFreeRoam => 'Quick action free roam';
  String get quickActionParking => 'Quick action parking';
  String get quickActionSnapAndSend => 'Quick action snap and send';
  String get quickActionQibla => 'Quick action qibla';
  String get quickActionQuran => 'Quick action quran';
  String get quickActionAthkar => 'Quick action athkar';

  // Stories in theme context
  String get storiesShown => 'Stories shown';
  String get storyTapped => 'Story tapped';
  String get storiesRefreshed => 'Stories refreshed';

  // Remote config
  String get configFetchStarted => 'Config fetch started';
  String get configFetchSuccess => 'Config fetch success';
  String get configFetchFailed => 'Config fetch failed';
  String get configCacheUsed => 'Config cache used';
  String get configAssetFallback => 'Config asset fallback';

  // Location tracking for themes
  String get locationEnterMakkahArea => 'Location enter Makkah area';
  String get locationExitMakkahArea => 'Location exit Makkah area';
  String get locationCheckPerformed => 'Location check performed';

  // Debug panel
  String get debugPanelOpened => 'Debug panel opened';
  String get debugPanelClosed => 'Debug panel closed';
  String get debugOverrideEnabled => 'Debug override enabled';
  String get debugOverrideDisabled => 'Debug override disabled';
  String get debugThemeSelected => 'Debug theme selected';
  String get debugSplashTriggered => 'Debug splash triggered';
  String get debugConfigRefreshed => 'Debug config refreshed';
  String get debugLocationRefreshed => 'Debug location refreshed';

  // Theme-specific
  String get makkahThemeActive => 'Makkah theme active';
  String get ramadanThemeActive => 'Ramadan theme active';
  String get hajjThemeActive => 'Hajj theme active';
  String get foundationDayThemeActive => 'Foundation Day theme active';
  String get nationalDayThemeActive => 'National Day theme active';

  // Offers and banners
  String get offersBannerShown => 'Offers banner shown';
  String get offersBannerTapped => 'Offers banner tapped';
  String get feedbackBannerShown => 'Feedback banner shown';
  String get feedbackBannerTapped => 'Feedback banner tapped';

  // Explore nearby (themed)
  String get exploreNearbyShown => 'Explore nearby shown';
  String get exploreNearbyTapped => 'Explore nearby tapped';
}

/// Metrics for Kaaba Virtual Tour feature
class KaabaTour {
  const KaabaTour();

  // Card interactions
  String get cardShown => 'Card shown';
  String get cardTapped => 'Card tapped';
  String get cardDismissed => 'Card dismissed';

  // Page interactions
  String get pageOpened => 'Page opened';
  String get pageClosed => 'Page closed';
  String get pageLoadStarted => 'Page load started';
  String get pageLoadCompleted => 'Page load completed';
  String get pageLoadFailed => 'Page load failed';

  // User interactions in tour
  String get tourStarted => 'Tour started';
  String get tourCompleted => 'Tour completed';
  String get tourAbandoned => 'Tour abandoned';
  String get tourInteraction => 'Tour interaction';

  // Feature availability
  String get featureEnabled => 'Feature enabled';
  String get featureDisabled => 'Feature disabled';
  String get featureLocationCheck => 'Feature location check';
  String get featureConfigCheck => 'Feature config check';

  // WebView metrics
  String get webViewError => 'WebView error';
  String get webViewTimeout => 'WebView timeout';
}

/// Metrics for Makkah Places feature
class MakkahPlaces {
  const MakkahPlaces();

  // Place list
  String get placesLoaded => 'Places loaded';
  String get placesLoadFailed => 'Places load failed';
  String get placesRefreshed => 'Places refreshed';
  String get placesScrolled => 'Places scrolled';

  // Place card interactions
  String get placeCardShown => 'Place card shown';
  String get placeCardTapped => 'Place card tapped';
  String get placeCardScrolledIntoView => 'Place card scrolled into view';

  // Place POI interactions
  String get placePoiOpened => 'Place POI opened';
  String get placePoiClosed => 'Place POI closed';
  String get placePoiExpanded => 'Place POI expanded';
  String get placePoiCollapsed => 'Place POI collapsed';
  String get placePoiPhotosViewed => 'Place POI photos viewed';
  String get placePoiPhotoSwiped => 'Place POI photo swiped';

  // Place actions
  String get placeDirections => 'Place directions';
  String get placeShare => 'Place share';
  String get placeCall => 'Place call';
  String get placeFavorite => 'Place favorite';
  String get placeWebsite => 'Place website';
  String get placeInstagram => 'Place instagram';
  String get placeParking => 'Place parking';

  // Travel info
  String get travelTimeShown => 'Travel time shown';
  String get travelTimeCalculated => 'Travel time calculated';
  String get walkModeShown => 'Walk mode shown';
  String get carModeShown => 'Car mode shown';

  // Map interactions
  String get mapMarkerTapped => 'Map marker tapped';
  String get mapCameraAnimated => 'Map camera animated';
}

class AppIconQuickActions {
  const AppIconQuickActions();

  String get shortcutHandled => 'App icon quick action handled';
  String get configFetchStarted => 'App icon quick actions config fetch started';
  String get configFetchSuccess => 'App icon quick actions config fetch success';
  String get configFetchFailed => 'App icon quick actions config fetch failed';
  String get configCacheUsed => 'App icon quick actions config cache used';
  String get configAssetFallback => 'App icon quick actions config asset fallback';
}

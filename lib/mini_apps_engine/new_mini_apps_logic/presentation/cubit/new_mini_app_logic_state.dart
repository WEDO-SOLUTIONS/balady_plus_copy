part of 'new_mini_app_logic_cubit.dart';

class NewMiniAppLogicState {
  //! Loading
  final bool isFavLoading;
  final bool isUnFavLoading;
  final bool isSearching;
  final bool isEntryPointsLoading;
  final bool isAppsGroupLoading;

  final bool isRefreshing;
  // bool isReachLimit;
  final int reachLimitNumber;

  //! Result
  final Map<String, MiniApp> parentMiniApp;
  final List<CategoryGroup> appGroups;
  final List<MiniApp> favoriteApps;
  final List<MiniApp> unFavoriteApps;
  final List<MiniApp> searchResults;
  final List<MiniApp> allMiniApps;
  final List<EntryPoints> entryPoints;

  //! Error
  final String? favError;
  final String? unFavError;
  final String? searchError;
  final String? entryPointsError;

  //! Sort
  final FilterOptionType? selectedSortType;

  NewMiniAppLogicState({
    required this.isFavLoading,
    required this.favError,
    required this.isUnFavLoading,
    required this.unFavError,
    required this.favoriteApps,
    required this.parentMiniApp,
    required this.unFavoriteApps,
    required this.isAppsGroupLoading,
    required this.appGroups,
    required this.allMiniApps,
    required this.searchResults,
    required this.isSearching,
    required this.searchError,
    required this.isEntryPointsLoading,
    required this.entryPointsError,
    required this.entryPoints,
    required this.isRefreshing,
    required this.reachLimitNumber,
    this.selectedSortType,
  });

  factory NewMiniAppLogicState.initial() {
    return NewMiniAppLogicState(
      isFavLoading: false,
      favError: null,
      isUnFavLoading: false,
      unFavError: null,
      allMiniApps: const [],
      favoriteApps: const [],
      unFavoriteApps: const [],
      parentMiniApp: const {},
      isAppsGroupLoading: false,
      appGroups: const [],
      searchResults: const [],
      isSearching: false,
      searchError: null,
      isEntryPointsLoading: false,
      entryPointsError: null,
      entryPoints: const [],
      isRefreshing: false,
      reachLimitNumber: 0,
      selectedSortType: FilterOptionType.serviceDateAscending,
    );
  }

  /// True when the cubit is in its very first state — [loadMiniApps] has not
  /// been called yet. Treat this the same as [isFavLoading] in the UI so
  /// shimmer widgets are shown on first open.
  bool get isInitial =>
      !isFavLoading &&
      !isAppsGroupLoading &&
      !isEntryPointsLoading &&
      allMiniApps.isEmpty &&
      appGroups.isEmpty &&
      entryPoints.isEmpty &&
      favError == null &&
      entryPointsError == null;

  NewMiniAppLogicState copyWith({
    bool? isFavLoading,
    Nullable<String?>? favError,
    bool? isUnFavLoading,
    Nullable<String?>? unFavError,
    List<MiniApp>? favoriteApps,
    List<MiniApp>? unFavoriteApps,
    List<MiniApp>? allMiniApps,
    bool? isAppsGroupLoading,
    List<CategoryGroup>? appGroups,
    List<MiniApp>? searchResults,
    Map<String, MiniApp>? parentMiniApp,
    bool? isSearching,
    Nullable<String?>? searchError,
    bool? isEntryPointsLoading,
    Nullable<String?>? entryPointsError,
    List<EntryPoints>? entryPoints,
    MiniApp? miniApp,
    bool? isRefreshing,
    int? reachLimitNumber,
    FilterOptionType? selectedSortType,
  }) {
    return NewMiniAppLogicState(
      isFavLoading: isFavLoading ?? this.isFavLoading,
      parentMiniApp: parentMiniApp ?? this.parentMiniApp,
      allMiniApps: allMiniApps ?? this.allMiniApps,
      favError: favError == null ? this.favError : favError.value,
      favoriteApps: favoriteApps ?? this.favoriteApps,
      unFavoriteApps: unFavoriteApps ?? this.unFavoriteApps,
      isUnFavLoading: isUnFavLoading ?? this.isUnFavLoading,
      unFavError: unFavError == null ? this.unFavError : unFavError.value,
      isAppsGroupLoading: isAppsGroupLoading ?? this.isAppsGroupLoading,
      appGroups: appGroups ?? this.appGroups,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchError: searchError == null ? this.searchError : searchError.value,
      isEntryPointsLoading: isEntryPointsLoading ?? this.isEntryPointsLoading,
      entryPointsError: entryPointsError == null ? this.entryPointsError : entryPointsError.value,
      entryPoints: entryPoints ?? this.entryPoints,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      reachLimitNumber: reachLimitNumber ?? this.reachLimitNumber,
      selectedSortType: selectedSortType ?? this.selectedSortType,
    );
  }

  // @override
  // // TODO: implement props
  // List<Object?> get props => [
  //       allMiniApps,
  //       appGroups,
  //       isFavLoading,
  //       isAppsGroupLoading,
  //       isEntryPointsLoading,
  //     ];
}

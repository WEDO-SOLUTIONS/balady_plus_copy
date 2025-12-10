part of 'new_mini_app_logic_cubit.dart';

class NewMiniAppLogicState {
  //! Loading
  final bool isFavLoading;
  final bool isUnFavLoading;
  final bool isSearching;
  final bool isEntryPointsLoading;
  final bool isAppsGroupLoading;

  final bool isRefreshing;

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
    );
  }

  NewMiniAppLogicState copyWith({
    bool? isFavLoading,
    String? favError,
    bool? isUnFavLoading,
    String? unFavError,
    List<MiniApp>? favoriteApps,
    List<MiniApp>? unFavoriteApps,
    List<MiniApp>? allMiniApps,
    bool? isAppsGroupLoading,
    List<CategoryGroup>? appGroups,
    List<MiniApp>? searchResults,
    Map<String, MiniApp>? parentMiniApp,
    bool? isSearching,
    String? searchError,
    bool? isEntryPointsLoading,
    String? entryPointsError,
    List<EntryPoints>? entryPoints,
    MiniApp? miniApp,
    bool? isRefreshing,
  }) {
    return NewMiniAppLogicState(
      isFavLoading: isFavLoading ?? this.isFavLoading,
      parentMiniApp: parentMiniApp ?? this.parentMiniApp,
      allMiniApps: allMiniApps ?? this.allMiniApps,
      favError: this.favError,
      favoriteApps: favoriteApps ?? this.favoriteApps,
      unFavoriteApps: unFavoriteApps ?? this.unFavoriteApps,
      isUnFavLoading: isUnFavLoading ?? this.isUnFavLoading,
      unFavError: unFavError ?? this.unFavError,
      isAppsGroupLoading: isAppsGroupLoading ?? this.isAppsGroupLoading,
      appGroups: appGroups ?? this.appGroups,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchError: searchError ?? this.searchError,
      isEntryPointsLoading: isEntryPointsLoading ?? this.isEntryPointsLoading,
      entryPointsError: this.entryPointsError,
      entryPoints: entryPoints ?? this.entryPoints,
      isRefreshing: isRefreshing ?? this.isRefreshing,
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

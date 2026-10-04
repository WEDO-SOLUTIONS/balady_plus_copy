import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/nullable.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_bottom_sheet.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/mini_apps_engine/data/repositories/mini_apps_repository.dart';
import 'package:balady_plus/mini_apps_engine/helper/app_launch_service.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/use_cases/get_new_mini_apps_logic_usecase.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/filter_buttom_sheet.dart';
import 'package:balady_plus/super_app_js_bridge/model/access_token_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

part 'new_mini_app_logic_state.dart';

class NewMiniAppLogicCubit extends Cubit<NewMiniAppLogicState> {
  final GetNewMiniAppsLogicUseCase getMiniAppsUseCase;
  final FlutterSecureStorage secureStorage;
  MiniAppsRepository homeServicesUseCases;

  static const _favoritesKey = 'mini_apps_favorite_ids';

  NewMiniAppLogicCubit(
      this.getMiniAppsUseCase,
      this.secureStorage,
      this.homeServicesUseCases,
      ) : super(NewMiniAppLogicState.initial());

  Timer? _searchDebounce;

  //! Get mini apps ...
  Future<void> loadMiniApps({
    bool showLoading = true,
    bool forceRefresh = false,
  }) async {
    //! Always block concurrent calls — even forceRefresh must wait until the
    //! current load finishes. This prevents the double-load that happens when
    //! `authenticated` and `unAuthenticatedState` both fire on first open.
    if (state.isAppsGroupLoading == true ||
        state.isFavLoading == true ||
        state.isUnFavLoading == true ||
        state.isSearching == true ||
        state.isEntryPointsLoading == true) {
      return;
    }

    if (!forceRefresh && state.allMiniApps.isNotEmpty) {
      return;
    }

    emit(
      state.copyWith(
        isFavLoading: true,
        isAppsGroupLoading: true,
        isEntryPointsLoading: true,
        favError: Nullable(null),
        entryPointsError: Nullable(null),
        isSearching: false,
        searchResults: const [],
        searchError: Nullable(null),
      ),
    );

    final isLoggedInLifestyle = CommonProperties.isLoggedIn;
    final isLoggedInMunicipality = CommonProperties.isLoggedInMunicipality;
    final result = await getMiniAppsUseCase(
      isLoggedInLifestyle,
      isLoggedInMunicipality,
    );

    result.fold(
          (e) {
        emit(
          state.copyWith(
            isFavLoading: false,
            isAppsGroupLoading: false,
            isEntryPointsLoading: false,
            favError: Nullable(e.toString()),
            entryPointsError: Nullable(e.toString()),
          ),
        );
      },
          (final data) async {
        final delegatorsCubit = sl<DelegatorsCubit>();

        if (isLoggedInMunicipality) {
          // Trigger load only if not already loaded or in progress
          if (delegatorsCubit.state.accountStatus == DelegatorsAccountStatus.initial) {
            await delegatorsCubit.loadData();
          }
        }

        final userAccountBusiness = delegatorsCubit.state.isUserAccountBusiness;
        // ---------------------------
        // ✅ 1) Filter apps (business rules)
        // ---------------------------
        final filteredApps = _filterMiniApps(
          allApps: data.miniApps,
          isLoggedInLifestyle: isLoggedInLifestyle,
          isLoggedInMunicipality: isLoggedInMunicipality,
          isUserAccountBusiness: userAccountBusiness,
        );

        final allowedIds = filteredApps.map((e) => e.id).toSet();

        // ---------------------------
        // ✅ 2) Filter groups recursively by allowed apps
        // (fixes subCategoryGroup + "Other Services" leaking)
        // ---------------------------
        final filteredGroups = _filterAppGroups(
          groups: _filterGroupsRecursivelyByAllowedIds(
            data.appGroups,
            allowedIds,
          ),
          isLoggedInMunicipality: isLoggedInMunicipality,
          isUserAccountBusiness: userAccountBusiness,
        );

        // ---------------------------
        // ✅ 3) Filter entry points apps by allowed apps
        // (fixes business apps appearing in Most Used section)
        // ---------------------------
        final filteredEntryPoints = _filterEntryPointsByAllowedIds(
          data.entryPoints,
          allowedIds,
        );

        // ---------------------------
        // ✅ 4) Favorites should be computed from the filtered list
        // ---------------------------
        final savedFavIds = await loadFavoriteIds();
        final appsById = {for (final app in filteredApps) app.id: app};

        final favoriteApps = savedFavIds
            .map((id) => appsById[id])
            .whereType<MiniApp>()
            .toList();

        final favoriteIdSet = favoriteApps.map((e) => e.id).toSet();
        final unFavoriteApps = filteredApps
            .where((app) => !favoriteIdSet.contains(app.id))
            .toList();

        // ---------------------------
        // ✅ 5) Emit ONE consistent state
        // ---------------------------
        emit(
          state.copyWith(
            allMiniApps: filteredApps,
            isFavLoading: false,
            isAppsGroupLoading: false,
            isEntryPointsLoading: false,
            favoriteApps: favoriteApps,
            unFavoriteApps: unFavoriteApps,
            parentMiniApp: data.parentMiniApp,
            appGroups: filteredGroups,
            entryPoints: filteredEntryPoints,
            favError: Nullable(null),
            entryPointsError: Nullable(null),
          ),
        );
      },
    );
  }

  //! pull to refresh mini apps UI.
  Future<void> refreshMiniApps() async {
    if (state.isRefreshing) return;

    emit(
      state.copyWith(
        isRefreshing: true,
        favError: Nullable(null),
        entryPointsError: Nullable(null),
        searchError: Nullable(null),
      ),
    );

    await loadMiniApps(showLoading: false, forceRefresh: true);

    emit(state.copyWith(isRefreshing: false));
  }

  //! Toggle fav apps ...
  Future<void> toggleFavoriteLocal(String id) async {
    final favoriteApps = List<MiniApp>.from(state.favoriteApps);
    final unFavoriteApps = List<MiniApp>.from(state.unFavoriteApps);
    final favIndex = favoriteApps.indexWhere((e) => e.id == id);
    if (favIndex != -1) {
      final app = favoriteApps.removeAt(favIndex);
      unFavoriteApps.insert(0, app);
      emit(
        state.copyWith(
          favoriteApps: favoriteApps,
          unFavoriteApps: unFavoriteApps,
        ),
      );
      await saveFavoriteIds(favoriteApps);
      return;
    }

    final unFavIndex = unFavoriteApps.indexWhere((e) => e.id == id);
    if (unFavIndex != -1) {
      if (favoriteApps.length >= 10) {
        state.reachLimitNumber + 1;
        emit(state.copyWith(reachLimitNumber: state.reachLimitNumber + 1));
        return;
      }
      final app = unFavoriteApps.removeAt(unFavIndex);
      favoriteApps.add(app);
      emit(
        state.copyWith(
          favoriteApps: favoriteApps,
          unFavoriteApps: unFavoriteApps,
        ),
      );

      await saveFavoriteIds(favoriteApps);
    }
  }

  Future<void> reorderFavoriteApps(int oldIndex, int newIndex) async {
    final favoriteApps = List<MiniApp>.from(state.favoriteApps);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final app = favoriteApps.removeAt(oldIndex);
    favoriteApps.insert(newIndex, app);

    emit(state.copyWith(favoriteApps: favoriteApps));

    await saveFavoriteIds(favoriteApps);
  }

  void searchMiniApp(String query, {List<MiniApp>? source}) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      final trimmed = query.trim();

      if (trimmed.isEmpty) {
        emit(
          state.copyWith(
            searchResults: [],
            isSearching: false,
            searchError: Nullable(null),
          ),
        );
        return;
      }

      final baseList =
          source ?? [...state.favoriteApps, ...state.unFavoriteApps];

      final q = _normalizeForSearch(trimmed.toLowerCase());

      final results = baseList.where((app) {
        final name = _normalizeForSearch(app.name.toLowerCase());
        final description = _normalizeForSearch(app.description.toLowerCase());

        // Fast path: keep existing exact / substring behaviour
        if (name.contains(q) || description.contains(q)) {
          return true;
        }

        // Fuzzy path: allow for small spelling mistakes
        return _isFuzzyMatch(name, q) || _isFuzzyMatch(description, q);
      }).toList();

      emit(
        state.copyWith(
          isSearching: false,
          searchResults: results,
          searchError: Nullable(null),
        ),
      );
    });

    emit(
      state.copyWith(
        isSearching: true,
        searchError: Nullable(null),
        searchResults: [],
      ),
    );
  }

  String _normalizeForSearch(String input) {
    // Basic Arabic text normalization so visually similar words match:
    // - Remove tatweel
    // - Strip common diacritics
    // - Unify alef forms, taa marbuta, and alif maqsura / yaa
    var s = input;

    // Remove tatweel (kashida)
    s = s.replaceAll('\u0640', '');

    // Remove Arabic diacritics
    s = s.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');

    // Character-level normalizations
    const Map<String, String> charMap = {
      'أ': 'ا',
      'إ': 'ا',
      'آ': 'ا',
      'ٱ': 'ا',
      'ى': 'ي', // alif maqsura -> yaa
      'ة': 'ه', // taa marbuta -> ha
    };

    charMap.forEach((from, to) {
      s = s.replaceAll(from, to);
    });

    return s;
  }

  bool _isFuzzyMatch(String text, String query) {
    // Split into tokens so we compare against individual words as well
    final tokens = text
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    for (final token in tokens) {
      final distance = _levenshteinDistance(token, query);
      final maxLen = math.max(token.length, query.length);

      // Allow 1 typo for very short words, 2 for longer ones
      final allowedTypos = maxLen <= 4 ? 1 : 2;

      if (distance <= allowedTypos) {
        return true;
      }
    }

    // As a fallback, compare the whole text for very short labels
    if (tokens.length <= 2) {
      final distance = _levenshteinDistance(text, query);
      final maxLen = math.max(text.length, query.length);
      final allowedTypos = maxLen <= 4 ? 1 : 2;
      if (distance <= allowedTypos) {
        return true;
      }
    }

    return false;
  }

  int _levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    final m = s.length;
    final n = t.length;

    // 2-row dynamic programming table to keep memory small
    List<int> prev = List<int>.generate(n + 1, (j) => j);
    List<int> curr = List<int>.filled(n + 1, 0);

    for (int i = 1; i <= m; i++) {
      curr[0] = i;
      final sChar = s.codeUnitAt(i - 1);

      for (int j = 1; j <= n; j++) {
        final tChar = t.codeUnitAt(j - 1);
        final cost = sChar == tChar ? 0 : 1;

        curr[j] = math.min(
          math.min(
            prev[j] + 1, // deletion
            curr[j - 1] + 1, // insertion
          ),
          prev[j - 1] + cost, // substitution
        );
      }

      // swap rows
      final temp = prev;
      prev = curr;
      curr = temp;
    }

    return prev[n];
  }

  Future<List<String>> loadFavoriteIds() async {
    try {
      final jsonString = await secureStorage.read(key: _favoritesKey);
      if (jsonString == null || jsonString.isEmpty) return [];

      final decoded = json.decode(jsonString);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavoriteIds(List<MiniApp> favorites) async {
    final ids = favorites.map((e) => e.id).toList();
    final jsonString = json.encode(ids);
    await secureStorage.write(key: _favoritesKey, value: jsonString);
  }

  void openMiniApp(MiniApp miniApp) async {
    /// if mini app needs login
    if (miniApp.nafathLogin && !CommonProperties.isLoggedInMunicipality) {
      /// check if we already logged in
      ///
      if (!CommonProperties.isLoggedIn) {
        await showModalBottomSheet(
          context: NavigationService.navigatorKey.currentState!.context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return NeedLoginBottomSheet(
              onSuccessLogin: (bool? isSuccess) async {
                if (isSuccess ?? false) {
                  Navigator.pop(context);
                  openMiniApp(miniApp);
                }
              },
            );
          },
        );
        return;
      } else {
        await CommonFunctions.onLogin(
          isMunicipality: true,
          mainPage: RouteName.bottomNavigation,
          miniAppKey: miniApp.serviceKey,
        );
      }
      return;
    }

    /// continue flow

    if (miniApp.otpLogin == true && !CommonProperties.isLoggedIn) {
      CommonFunctions.onLogin();
    } else {
      if (miniApp.latestVersion?.deepLinkDto != null) {
        try {
          final deepLinkDto = miniApp.latestVersion!.deepLinkDto!;
          final sessionKey = '';

          String? replaceSessionKey(String? url) {
            if (url == null) return null;
            if (sessionKey.isNotEmpty) {
              return url
                  .replaceAll(r'$sessionKey', sessionKey)
                  .replaceAll(r'${sessionKey}', sessionKey)
                  .replaceAll('{sessionKey}', sessionKey);
            }
            return url;
          }

          // final updatedDeepLinkDto = deepLinkDto.copyWith(
          //   deepLinkAndroid: replaceSessionKey(deepLinkDto.deepLinkAndroid),
          //   deepLinkIos: replaceSessionKey(deepLinkDto.deepLinkIos),
          // );

          debugPrint(
            'openMiniApp launching deep link: Android=${deepLinkDto.deepLinkAndroid}, iOS=${deepLinkDto.deepLinkIos}',
          );

          await AppLaunchService.launchApp(deepLinkInfo: deepLinkDto);
        } catch (e) {
          CommonFunctions.showError('launch_failed'.tr());
        }
      } else {
        if (miniApp.childDeepLinkUrl != null) {
          MiniApp? parentMAiniApp =
          state.parentMiniApp[miniApp.parentServiceKey];

          if (parentMAiniApp != null) {
            NavigationService.pushNamed(
              routeName: RouteName.miniAppsMainScreen,
              args: miniApp.copyWith(
                latestVersion: parentMAiniApp.latestVersion,
                serviceKey: miniApp.parentServiceKey,
                path: miniApp.childDeepLinkUrl,
              ),
            );
          } else {
            CommonFunctions.showError(
              'Show errors Not Fund The Parent Maini App'.tr(),
            );
          }
        } else {
          NavigationService.pushNamed(
            routeName: RouteName.miniAppsMainScreen,
            args: miniApp,
          );
        }
      }
    }
  }

  StreamSubscription? _deepLinkSubscription;

  Future<void> openMiniAppByServiceKey({
    required String serviceKey,
    String? path,
  }) async {
    // 1. Check if data is ALREADY there
    final existingApp = state.allMiniApps.firstWhereOrNull(
          (s) => s.serviceKey == serviceKey,
    );

    if (existingApp != null) {
      openMiniApp(existingApp.copyWith(path: path));
      return;
    }

    // 2. Initiate loading if allMiniApps is empty and not already loading
    if (state.allMiniApps.isEmpty && !state.isAppsGroupLoading) {
      loadMiniApps();
    }

    await _deepLinkSubscription?.cancel();

    _deepLinkSubscription = stream.listen((state) {
      final miniApp = state.allMiniApps.firstWhereOrNull(
            (s) => s.serviceKey == serviceKey,
      );

      if (miniApp != null) {
        openMiniApp(miniApp.copyWith(path: path));

        // 3. STOP listening once we've succeeded
        _deepLinkSubscription?.cancel();
        _deepLinkSubscription = null;
      }
    });
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    // The state class has no value equality, so an emit here always rebuilds
    // every watcher. This runs from PopScope during a page's own pop; emitting
    // when there is nothing to clear feeds a rebuild -> pop -> clearSearch
    // loop on AppsGroupPage.
    final alreadyClear =
        state.searchResults.isEmpty &&
        !state.isSearching &&
        state.searchError == null &&
        !state.isAppsGroupLoading &&
        !state.isEntryPointsLoading &&
        !state.isFavLoading &&
        !state.isUnFavLoading &&
        !state.isRefreshing;
    if (alreadyClear) {
      return;
    }
    emit(
      state.copyWith(
        searchResults: [],
        isSearching: false,
        searchError: Nullable(null),
        isAppsGroupLoading: false,
        isEntryPointsLoading: false,
        isFavLoading: false,
        isUnFavLoading: false,
        isRefreshing: false,
      ),
    );
  }

  void setSortType(FilterOptionType? sortType) {
    emit(state.copyWith(selectedSortType: sortType));
  }

  List<MiniApp> sortApps(List<MiniApp> apps, FilterOptionType? sortType) {
    if (sortType == null) return apps;

    final sortedApps = List<MiniApp>.from(apps);

    switch (sortType) {
      case FilterOptionType.ServiceDateAscending:
        sortedApps.sort((a, b) {
          if (a.serviceOrder == null && b.serviceOrder == null) return 0;
          if (a.serviceOrder == null) return 1;
          if (b.serviceOrder == null) return -1;
          return a.serviceOrder!.compareTo(b.serviceOrder!);
        });
        break;

      case FilterOptionType.ServiceDateDescending:
        sortedApps.sort((a, b) {
          if (a.serviceOrder == null && b.serviceOrder == null) return 0;
          if (a.serviceOrder == null) return 1;
          if (b.serviceOrder == null) return -1;
          return b.serviceOrder!.compareTo(a.serviceOrder!);
        });
        break;

      case FilterOptionType.AlphabeticalAscending:
        sortedApps.sort((a, b) => a.name.compareTo(b.name));
        break;

      case FilterOptionType.AlphabeticalDescending:
        sortedApps.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    return sortedApps;
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<BaseResponse?> getMiniAppAcessToken(MiniApp miniApp) async {
    MiniApp model = miniApp;

    try {
      final response = await homeServicesUseCases.getMiniAppAcessToken(
        model.id,
      );

      return response.fold(
            (error) {
          if (error is ServerFailure) {
            return BaseResponse(
              code: 500,
              message: error.errorMessage,
              eventName: "getAccessToken",
              data: null,
            );
          } else {
            return BaseResponse(
              code: 500,
              message: 'An unknown error occurred',
              eventName: "getAccessToken",
              data: null,
            );
          }
        },
            (res) {
          return BaseResponse(
            code: 200,
            message: "success",
            eventName: "getAccessToken",
            data: AccessTokenModel(accessToken: res.toString()),
          );
        },
      );
    } catch (e) {
      return BaseResponse(
        code: 500,
        message: 'Failed to get access token: ${e.toString()}',
        eventName: "getAccessToken",
        data: null,
      );
    }
  }

  // Business logic filtering methods moved from repository layer
  List<MiniApp> _filterMiniApps({
    required List<MiniApp> allApps,
    required bool isLoggedInLifestyle,
    required bool isLoggedInMunicipality,
    required bool isUserAccountBusiness,
  }) {
    //! Not logged in = show all
    if (!isLoggedInLifestyle && !isLoggedInMunicipality) {
      return allApps;
    }

    //! Lifestyle login = show all
    if (isLoggedInLifestyle && !isLoggedInMunicipality) {
      return allApps;
    }

    //! Municipality login
    if (isLoggedInMunicipality && !isLoggedInLifestyle ||
        isLoggedInMunicipality && isLoggedInLifestyle) {
      //! Business account = show all
      if (isLoggedInMunicipality == true && isUserAccountBusiness == true) {
        return allApps;
      }
      //! Individual account = hide business-only apps
      if (isLoggedInMunicipality == true && isUserAccountBusiness == false) {
        return allApps.where((app) => !_isBusinessOnlyApp(app)).toList();
      }
    }

    return allApps;
  }

  bool _isBusinessOnlyApp(MiniApp app) {
    final categories = app.categories;
    final isBusiness = categories.any(
          (c) =>
      c.id == '6f736c81-c998-4c3e-09ea-08de2cce6088' ||
          c.name == 'تطبيقات بلدية للأعمال' ||
          c.name == 'Business Municipal Apps',
    );
    final isIndividual = categories.any(
          (c) =>
      c.id == '124a4dd1-7a7b-47f1-09eb-08de2cce6088' ||
          c.name == 'تطبيقات بلدية للأفراد' ||
          c.name == 'Individual Municipal Apps',
    );
    return isBusiness && !isIndividual;
  }

  List<CategoryGroup> _filterAppGroups({
    required List<CategoryGroup> groups,
    required bool isLoggedInMunicipality,
    required bool isUserAccountBusiness,
  }) {
    final List<CategoryGroup> filteredGroups = [];

    for (final group in groups) {
      // Check if this is the business category
      final isBusinessCategory =
          group.id == '6f736c81-c998-4c3e-09ea-08de2cce6088' ||
              group.nameAr == 'تطبيقات بلدية للأعمال' ||
              group.nameEn == 'Business Municipal Apps';

      // Skip business category for individual municipality accounts
      if (isBusinessCategory &&
          isLoggedInMunicipality == true &&
          isUserAccountBusiness == false) {
        continue; // Don't add it at all
      }

      filteredGroups.add(group);
    }

    return filteredGroups;
  }

  List<CategoryGroup> _filterGroupsRecursivelyByAllowedIds(
      List<CategoryGroup> groups,
      Set<String> allowedIds,
      ) {
    CategoryGroup? filterOne(CategoryGroup g) {
      // Filter apps in this group
      final filteredApps = g.apps
          .where((a) => allowedIds.contains(a.id))
          .toList();

      // Filter subcategories recursively (Map -> entries -> where -> Map)
      final Map<String, CategoryGroup>? filteredSubs =
      g.subCategoryGroup == null
          ? null
          : Map<String, CategoryGroup>.fromEntries(
        g.subCategoryGroup!.entries.map((e) {
          final filteredChild = filterOne(e.value);
          if (filteredChild == null) return null;
          return MapEntry(e.key, filteredChild);
        }).whereType<MapEntry<String, CategoryGroup>>(),
      );

      final hasSubs = filteredSubs != null && filteredSubs.isNotEmpty;

      // If group has no apps and no subs after filtering -> drop it
      if (filteredApps.isEmpty && !hasSubs) return null;

      return g.copyWith(apps: filteredApps, subCategoryGroup: filteredSubs);
    }

    return groups.map(filterOne).whereType<CategoryGroup>().toList();
  }

  List<EntryPoints> _filterEntryPointsByAllowedIds(
      List<EntryPoints> entryPoints,
      Set<String> allowedIds,
      ) {
    return entryPoints
        .map((ep) {
      final filteredApps = ep.apps
          .where((a) => allowedIds.contains(a.id))
          .toList();

      if (filteredApps.isEmpty) return null;

      return EntryPoints(
        entryPointKey: ep.entryPointKey,
        arName: ep.arName,
        enName: ep.enName,
        isActive: ep.isActive,
        apps: filteredApps,
      );
    })
        .whereType<EntryPoints>()
        .toList();
  }

  MiniApp? getMiniAppByServiceId(String serviceKey) {
    try {
      return state.allMiniApps.firstWhere(
            (miniApp) => miniApp.serviceKey == serviceKey,
      );
    } catch (e) {
      return null;
    }
  }
}

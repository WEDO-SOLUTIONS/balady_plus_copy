import 'dart:async';
import 'dart:convert';

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_bottom_sheet.dart';
import 'package:balady_plus/mini_apps_engine/data/repositories/mini_apps_repository.dart';
import 'package:balady_plus/mini_apps_engine/helper/app_launch_service.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/use_cases/get_new_mini_apps_logic_usecase.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/filter_buttom_sheet.dart';
import 'package:balady_plus/super_app_js_bridge/model/access_token_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:bloc/bloc.dart';
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
    bool? isUserLoggedInLifeStyle,
    bool? isUserLoggedInMunicipality,
    bool? isUserAccountBusiness,
  }) async {
    emit(
      state.copyWith(
        isFavLoading: true,
        isAppsGroupLoading: true,
        isEntryPointsLoading: true,
        favError: null,
        entryPointsError: null,
        isSearching: false,
        searchResults: const [],
        searchError: null,
      ),
    );

    // Get login status from CommonProperties if not provided
    final isLoggedInLifestyle =
        isUserLoggedInLifeStyle ?? CommonProperties.isLoggedIn;
    final isLoggedInMunicipality =
        isUserLoggedInMunicipality ?? CommonProperties.isLoggedInMunicipality;
    final userAccountBusiness = isUserAccountBusiness ?? false;

    final result = await getMiniAppsUseCase(
      isLoggedInLifestyle,
      isLoggedInMunicipality,
      userAccountBusiness,
    );

    result.fold(
      (e) {
        emit(
          state.copyWith(
            isFavLoading: false,
            isAppsGroupLoading: false,
            isEntryPointsLoading: false,
            favError: e.toString(),
            entryPointsError: e.toString(),
          ),
        );
      },
      (final data) async {
        final savedFavIds = await loadFavoriteIds();
        final allApps = data.miniApps;

        final appsById = {for (final app in allApps) app.id: app};

        final favoriteApps = savedFavIds
            .map((id) => appsById[id])
            .whereType<MiniApp>()
            .toList();

        final favoriteIdSet = favoriteApps.map((e) => e.id).toSet();
        final unFavoriteApps = allApps
            .where((app) => !favoriteIdSet.contains(app.id))
            .toList();

        emit(
          state.copyWith(
            allMiniApps: data.miniApps,
            isFavLoading: false,
            isAppsGroupLoading: false,
            isEntryPointsLoading: false,
            favoriteApps: favoriteApps,
            unFavoriteApps: unFavoriteApps,
            parentMiniApp: data.parentMiniApp,
            appGroups: data.appGroups,
            entryPoints: data.entryPoints,
            favError: null,
            entryPointsError: null,
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
        favError: null,
        entryPointsError: null,
        searchError: null,
      ),
    );

    await loadMiniApps(showLoading: false);

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
            searchError: null,
          ),
        );
        return;
      }

      final baseList =
          source ?? [...state.favoriteApps, ...state.unFavoriteApps];

      final q = trimmed.toLowerCase();

      final results = baseList.where((app) {
        return app.name.toLowerCase().contains(q) ||
            app.description.toLowerCase().contains(q);
      }).toList();

      emit(
        state.copyWith(
          isSearching: false,
          searchResults: results,
          searchError: null,
        ),
      );
    });

    emit(
      state.copyWith(isSearching: true, searchError: null, searchResults: []),
    );
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
    if (miniApp.nafathLogin) {
      /// check if we already logged in
      if (!CommonProperties.isLoggedInMunicipality) {
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
      }
    }

    /// continue flow

    if (miniApp.latestVersion?.otpLogin == true &&
        miniApp.latestVersion?.deepLinkDto == null) {
      CommonFunctions.onLogin();
    } else {
      if (miniApp.latestVersion?.deepLinkDto != null) {
        try {
          await AppLaunchService.launchApp(
            deepLinkInfo: miniApp.latestVersion!.deepLinkDto!,
          );
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

  Future<void> openMiniAppByServiceKey({
    required String serviceKey,
    String? path,
  }) async {
    try {
      MiniApp miniApp = state.allMiniApps
          .firstWhere((service) => service.serviceKey == serviceKey)
          .copyWith();

      openMiniApp(miniApp);
    } catch (e) {
      // CommonFunctions.showSuccess(e.toString());
    }
  }

  void clearSearch() {
    emit(
      state.copyWith(searchResults: [], isSearching: false, searchError: null),
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
}

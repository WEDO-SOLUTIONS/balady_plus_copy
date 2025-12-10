import 'dart:async';
import 'dart:convert';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/app/features/entry_point/domain/use_cases/get_cookie.dart';
import 'package:balady_plus/mini_apps_engine/data/repositories/mini_apps_repository.dart';
import 'package:balady_plus/mini_apps_engine/helper/app_launch_service.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/use_cases/get_new_mini_apps_logic_usecase.dart';
import 'package:balady_plus/super_app_js_bridge/model/access_token_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
  Future<void> loadMiniApps() async {
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

    final result = await getMiniAppsUseCase();

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
      (data) async {
        final savedFavIds = await _loadFavoriteIds();
        final allApps = data.miniApps;

        final favoriteApps =
            allApps.where((app) => savedFavIds.contains(app.id)).toList();

        final unFavoriteApps =
            allApps.where((app) => !savedFavIds.contains(app.id)).toList();

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
      await _saveFavoriteIds(favoriteApps);
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

      await _saveFavoriteIds(favoriteApps);
    }
  }

  //! Reorder fav apps ...
  Future<void> reorderFavoriteApps(int oldIndex, int newIndex) async {
    final favoriteApps = List<MiniApp>.from(state.favoriteApps);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final app = favoriteApps.removeAt(oldIndex);
    favoriteApps.insert(newIndex, app);

    emit(
      state.copyWith(
        favoriteApps: favoriteApps,
      ),
    );

    await _saveFavoriteIds(favoriteApps);
  }

  //! Search for mini app ...
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
      state.copyWith(
        isSearching: true,
        searchError: null,
        searchResults: [],
      ),
    );
  }

  //! Get the fav mini apps ...
  Future<List<String>> _loadFavoriteIds() async {
    try {
      final jsonString = await secureStorage.read(key: _favoritesKey);
      if (jsonString == null || jsonString.isEmpty) return [];

      final decoded = json.decode(jsonString);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (_) {
      // if anything goes wrong, just treat as no favorites
      return [];
    }
  }

  //! Save the selected fav apps to local storage ...
  Future<void> _saveFavoriteIds(List<MiniApp> favorites) async {
    final ids = favorites.map((e) => e.id).toList();
    final jsonString = json.encode(ids);
    await secureStorage.write(key: _favoritesKey, value: jsonString);
  }

  void openMiniApp(MiniApp miniApp) async {

    /// if mini app needs login
    if (miniApp.nafathLogin) {
      /// check if we already logged in
      /*if (!(miniApp.latestVersion?.nafathLogin == true) &&*/
      if (!CommonProperties.isLoggedInMunicipality) {
        await showDialog(
          context: NavigationService.navigatorKey.currentState!.context,
          builder: (ctx) => NeedLoginDialog(
            onSuccessLogin: (bool? isSuccess) async {
              if (isSuccess ?? false) openMiniApp(miniApp);
            },
          ),
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
            //deepLink: deeplink,
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
                'Show errors Not Fund The Parent Maini App'.tr());
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
    emit(state.copyWith(
      searchResults: [],
      isSearching: false,
      searchError: null,
    ));
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<BaseResponse?> getMiniAppAcessToken(MiniApp miniApp) async {
    MiniApp model = miniApp;

    try {
      final response =
          await homeServicesUseCases.getMiniAppAcessToken(model.id);

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
            data: AccessTokenModel(
              accessToken: res.toString(),
            ),
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

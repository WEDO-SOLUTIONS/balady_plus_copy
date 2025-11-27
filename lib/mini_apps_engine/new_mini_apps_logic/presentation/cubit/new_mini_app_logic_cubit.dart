import 'dart:async';
import 'dart:convert';

import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/use_cases/get_new_mini_apps_logic_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'new_mini_app_logic_state.dart';

class NewMiniAppLogicCubit extends Cubit<NewMiniAppLogicState> {
  final GetNewMiniAppsLogicUseCase getMiniAppsUseCase;
  final FlutterSecureStorage secureStorage;

  static const _favoritesKey = 'mini_apps_favorite_ids';

  NewMiniAppLogicCubit(this.getMiniAppsUseCase, this.secureStorage)
      : super(NewMiniAppLogicState.initial());

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
            isFavLoading: false,
            isAppsGroupLoading: false,
            isEntryPointsLoading: false,
            favoriteApps: favoriteApps,
            unFavoriteApps: unFavoriteApps,
            parentMiniApp: data.parentMiniApp,
            appGroups: data.appGroups,
            entryPoints: data.entryPoints,
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

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}

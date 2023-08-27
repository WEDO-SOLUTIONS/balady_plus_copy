import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/app/features/map_page/data/model/suggest_history.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

import 'map_view_model.dart';

FocusNode searchFocusNode = FocusNode();

class SearchBottomViewModel extends BaseViewModel {
  String queryText = '';
  String oldQueryText = '';

  // TextEditingController searchController = TextEditingController();
  final showSearchView = ValueNotifier<bool>(false);

  final MapViewModel mapViewModel;

  final suggestResultMessage = ValueNotifier<SuggestResultMessage?>(null);
  final suggestResultMessageHistory =
      ValueNotifier<Map<int, SuggestHistory>?>(null);

  SearchBottomViewModel(this.mapViewModel) {
    fetchSuggestHistory();
    searchFocusNode.addListener(() {
      showSearchView.value = searchFocusNode.hasFocus;
      queryText = '';
      oldQueryText = '';
      removeSuggestList();
    });
  }

  void fetchSuggest(String newQueryText) async {
    queryText = newQueryText;
    try {
      if (!isLoading) {
        isLoading = true;
        oldQueryText = newQueryText;
        suggestResultMessage.value = await mapViewModel.controller.fetchSuggest(
          queryText,
        );
        isLoading = false;
        if (queryText.isNotEmpty) {
          if (queryText == oldQueryText) {
            suggestResultMessage.notifyListeners();
          } else {
            fetchSuggest(queryText);
          }
        } else {
          oldQueryText = '';
          removeSuggestList();
        }
      }
    } catch (e) {
      isLoading = false;
      removeSuggestList();
      print(e);
    }
  }

  void fetchSuggestHistory() async {
    try {
      suggestResultMessageHistory.value = await sharedPrefs
          .getSuggestResultHistory();
      suggestResultMessageHistory.notifyListeners();
    } catch (_) {}
  }

  void removeSuggestList() {
    suggestResultMessage.value = null;
    oldQueryText = '';
    queryText = '';
    suggestResultMessage.notifyListeners();
  }

  void saveItemHistory(SuggestObjectHandlerMessage objectHandler) {
    suggestResultMessageHistory.value![objectHandler.item.id!.objectId] =
        SuggestHistory(
      id: objectHandler.item.id!,
      markerPosition: objectHandler.item.markerPosition!,
      title: objectHandler.item.title ?? '',
      subtitle: objectHandler.item.fullAddressName?.streetAddress ?? '',
    );
    sharedPrefs.setSuggestResultHistory(suggestResultMessageHistory.value!);
    suggestResultMessageHistory.notifyListeners();
  }
}

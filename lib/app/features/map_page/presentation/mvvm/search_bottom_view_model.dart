import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/utils/extensions/json_conversion.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

import 'map_view_model.dart';

FocusNode searchFocusNode = FocusNode();

class SearchBottomViewModel extends BaseViewModel {
  String queryText = '';
  String oldQueryText = '';
  final isLoadingData = ValueNotifier<bool>(false);
  final showCategory = ValueNotifier<bool>(false);
  final showSearchView = ValueNotifier<bool>(false);

  final MapViewModel mapViewModel;

  final suggestResultMessage = ValueNotifier<SuggestResultMessage?>(null);

  SearchBottomViewModel(this.mapViewModel) {
    searchFocusNode.addListener(() {
      showSearchView.value = searchFocusNode.hasFocus;
      queryText = '';
      oldQueryText = '';
      removeSuggestList();
    });

    searchController.addListener(() {
      bool show = true;
      if (searchController.text.isEmpty) {
        show = true;
      } else {
        show = false;
      }
      if (showCategory.value != show) {
        showCategory.value = show;
        showCategory.notifyListeners();
      }
    });
  }

  void fetchSuggest(String newQueryText) async {
    queryText = newQueryText;
    try {
      if (!isLoadingData.value) {
        isLoadingData.value = true;
        isLoadingData.notifyListeners();
        oldQueryText = newQueryText;
        suggestResultMessage.value = await mapViewModel.controller.fetchSuggest(
          queryText,
        );
        isLoadingData.value = false;
        isLoadingData.notifyListeners();
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
      isLoadingData.value = false;
      isLoadingData.notifyListeners();

      removeSuggestList();
      print(e);
    }
  }

  void removeSuggestList() {
    suggestResultMessage.value = null;
    oldQueryText = '';
    queryText = '';
    suggestResultMessage.notifyListeners();
  }

  void saveItemHistory(SuggestObjectHandlerMessage objectHandler) {
    String data = objectHandler.toJson();
  }
}

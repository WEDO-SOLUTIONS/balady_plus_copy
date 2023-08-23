import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/utils/extensions/json_conversion.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

import 'map_view_model.dart';

FocusNode searchFocusNode = FocusNode();

class SearchBottomViewModel extends BaseViewModel {
  String queryText = '';
  String oldQueryText = '';
  TextEditingController searchController = TextEditingController();
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

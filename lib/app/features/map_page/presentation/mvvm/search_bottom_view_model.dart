import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/app/features/map_page/data/model/suggest_history.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

import 'map_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

FocusNode searchFocusNode = FocusNode();

class SearchBottomViewModel extends BaseViewModel {
  String queryText = '';
  String oldQueryText = '';
  final isLoadingData = ValueNotifier<bool>(false);
  final showCategory = ValueNotifier<bool>(false);

  // TextEditingController searchController = TextEditingController();
  final showSearchView = ValueNotifier<bool>(false);

  final MapViewModel mapViewModel;

  final suggestResultMessage = ValueNotifier<SuggestResultMessage?>(null);
  final suggestResultMessageHistory =
      ValueNotifier<Map<int, SuggestHistory>?>(null);

  SearchBottomViewModel(this.mapViewModel) {
    // fetchSuggestHistory();
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
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      isLoadingData.value = false;
      isLoadingData.notifyListeners();

      removeSuggestList();
    }
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////

  void fetchSuggestHistory() async {
    try {
      suggestResultMessageHistory.value =
          await sharedPrefs.getSuggestResultHistory();
      suggestResultMessageHistory.notifyListeners();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );}
  }

  void removeSuggestList() {
    suggestResultMessage.value = null;
    oldQueryText = '';
    queryText = '';
    suggestResultMessage.notifyListeners();
  }

  void saveItemHistory(SuggestObjectHandlerMessage objectHandler) {
    if (suggestResultMessageHistory.value![objectHandler.item.id!.objectId] ==
            null &&
        suggestResultMessageHistory.value!.length == 20) {
      suggestResultMessageHistory.value!.remove(
        suggestResultMessageHistory.value!.keys.first,
      );
    }
    suggestResultMessageHistory.value![objectHandler.item.id!.objectId] =
        SuggestHistory(
      id: objectHandler.item.id!,
      markerPosition: objectHandler.item.markerPosition!,
      title: objectHandler.item.title ?? '',
      subtitle: objectHandler.item.fullAddressName?.streetAddress ?? '',
    );
    try {
      sharedPrefs.setSuggestResultHistory(suggestResultMessageHistory.value!);
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
    suggestResultMessageHistory.notifyListeners();
  }
}

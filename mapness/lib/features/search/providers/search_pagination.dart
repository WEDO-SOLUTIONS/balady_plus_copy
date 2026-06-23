import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_pagination.g.dart';

@riverpod
class SearchPagination extends _$SearchPagination {
  PageMessage? _currentPage;

  @override
  List<DirectoryObjectMessage> build(SearchResultMessage results) {
    _currentPage = results.firstPage;
    ref.onDispose(() {
      if (_currentPage != null) {
        try {
          ref.read(dgisControllerProvider).value?.releasePage(_currentPage!);
        } catch (_) {
          // ignore because page is already released
        } finally {
          _currentPage = null;
        }
      }
    });

    return _currentPage != null ? _mapPage(_currentPage!) : [];
  }

  /// The items added by the most recent [fetchNext] call. Lets the results UI
  /// report a `search_results_exposure` for the newly-loaded page.
  List<DirectoryObjectMessage> lastFetchedItems = const [];

  Future<bool> fetchNext() async {
    if (_currentPage == null) {
      return false;
    }

    final dgisController = await ref.read(dgisControllerProvider.future);

    PageMessage page;
    try {
      page = await dgisController.fetchNextPage(_currentPage!);
    } catch (e) {
      return false;
    }

    try {
      await dgisController.releasePage(_currentPage!);
    } catch (_) {
      // ignore because page is already released
    }

    _currentPage = page;
    final newItems = _mapPage(page);
    lastFetchedItems = newItems;
    state = [
      ...state,
      ...newItems,
    ];
    return true;
  }

  List<DirectoryObjectMessage> _mapPage(PageMessage message) =>
      message.items.whereType<DirectoryObjectMessage>().toList();
}

import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/features/saudi_pass/providers/poi_offers_provider.dart';
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

  Future<bool> fetchNext() async {
    if (_currentPage == null) {
      return false;
    }

    final dgisController = await ref.read(dgisControllerProvider.future);

    PageMessage page;
    try {
      page = await dgisController.fetchNextPage(_currentPage!);

      final licenseIds = page.items.map((e) => e.tradeLicense?.license.trim()).nonNulls.toSet();
      if (licenseIds.isNotEmpty) {
        unawaited(ref.read(poiOffersProvider.notifier).fetchOffers(licenseIds));
      }
    } catch (e) {
      return false;
    }

    try {
      await dgisController.releasePage(_currentPage!);
    } catch (_) {
      // ignore because page is already released
    }

    _currentPage = page;
    state = [
      ...state,
      ..._mapPage(page),
    ];
    return true;
  }

  List<DirectoryObjectMessage> _mapPage(PageMessage message) =>
      message.items.whereType<DirectoryObjectMessage>().toList();
}

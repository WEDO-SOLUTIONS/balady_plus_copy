import 'dart:async';

import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mapness/legacy/routing_page/data/directory_object_ext.dart';

import '../data/object_info.dart';
import '../data/object_info_state.dart';
import '../data/search_state.dart';

class RoutingSearchViewModel extends SearchViewModel {
  /// @nodoc
  RoutingSearchViewModel(
    super.controller,
    this._selectedValue, {
    required super.onItemSelected,
  }) : super() {
    _selectedValue.addListener(valueChanged);
    unawaited(valueChanged());
  }

  final ValueNotifier<ObjectInfoState?> _selectedValue;
  bool setTextState = false;
  String? _selectedAddress;

  Future<void> valueChanged() async {
    final objectId = _selectedValue.value;

    if (objectId == null) {
      setText(null);
      return;
    }

    final object = await this._controller.searchByObjectId(DgisObjectIdMessage(
          objectId: objectId.dgisObjectId.objectId,
          entranceId: objectId.dgisObjectId.entranceId,
        ));
    _selectedAddress = object.makeAddress();
    setText(_selectedAddress);
  }

  @override
  void dispose() {
    _selectedValue.removeListener(valueChanged);
    super.dispose();
  }

  @override
  Future<void> _itemTapHandler(DgisObjectIdMessage? objectId) async {
    if (objectId == null) return;

    print("item tapped");

    final response = await _controller.searchByObjectId(objectId);
    final point = response.markerPosition;

    if (point != null) {
      searchFocusNode.unfocus();
      onItemSelected(
        ObjectInfoState(
            dgisObjectId: DgisObjectId(
              objectId: objectId.objectId,
              entranceId: objectId.entranceId,
            ),
            latLng: LatLng(
              latitude: point.latitude,
              longitude: point.longitude,
            )),
      );
      onCancelTap();
    }
  }

  @override
  void onCancelTap() {
    super.onCancelTap();
    clearControlState.value = false;
    setText(_selectedAddress);
  }

  void setText(String? value) {
    setTextState = true;
    searchController.text = value ?? ""; // ?? placeholder;
  }

  @override
  void _searchInputHandler() {
    if (setTextState) {
      setTextState = false;
      return;
    }

    super._searchInputHandler();
  }
}

class SearchViewModel {
  SearchViewModel(
    this._controller, {
    required this.onItemSelected,
  });

  final ValueChanged<ObjectInfoState> onItemSelected;

  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final paginationController = ScrollController();

  final searchState = ValueNotifier(SearchState.initial());
  final heightState = ValueNotifier(_midHeight);
  final cancelControlState = ValueNotifier(false);
  final clearControlState = ValueNotifier(false);

  final DgisMapController _controller;

  final _sortingType = SortingTypeMessage.byRelevance;

  String? _lastQueryText;
  String? _lastSuggestQuery;
  PageMessage? _currentPage;

  Timer? _suggestDebounce;
  CancelableOperation<SuggestResultMessage>? _suggestCancelable;
  CancelableOperation<SearchResultMessage>? _searchCancelable;

  void init() {
    paginationController.addListener(_paginationListener);
    searchController.addListener(_searchInputHandler);
    searchFocusNode.addListener(_searchFiledFocusHandler);
    searchState.addListener(_updateControlsState);
  }

  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    paginationController.dispose();
    searchState.dispose();
    _suggestDebounce?.cancel();
    unawaited(_suggestCancelable?.cancel());
    unawaited(_searchCancelable?.cancel());
  }

  Future<bool> onWillPop() {
    if (searchState.value.hasData || searchState.value.hasSuggests) {
      heightState.value = _midHeight;
      searchFocusNode.unfocus();
      return Future.value(false);
    }
    return Future.value(true);
  }

  void onSearchTap() {
    searchFocusNode.unfocus();
    onSubmitTap(searchController.text);
  }

  Future<void> onSubmitTap(String value) async {
    if (value.isEmpty) {
      heightState.value = _midHeight;
      return;
    }

    if (value.isEmpty || value == _lastQueryText) return;

    await _performSearch(
      searchFuture: _controller.search(
        value,
        sortingType: _sortingType,
      ),
      queryText: value,
    );
  }

  Future<void> onSuggestTap(SuggestMessage suggest) async {
    if (suggest.handler.objectHandler != null) {
      searchFocusNode.unfocus();
      return _itemTapHandler(suggest.handler.objectHandler?.item.id);
    } else if (suggest.handler.performSearchHandler != null) {
      return _performSearch(
        searchFuture: _controller.searchByQuery(
          suggest.handler.performSearchHandler!.searchQuery,
          sortingType: _sortingType,
        ),
        queryText: suggest.title.text,
      );
    } else {
      return _performSearch(
        searchFuture: _controller.search(
          searchController.text,
          sortingType: _sortingType,
        ),
        queryText: searchController.text,
      );
    }
  }

  Future<void> onItemTap(int index) async {
    final data = searchState.value.data;
    if (data == null) return;

    return _itemTapHandler(data[index].objectId);
  }

  void onCancelTap() {
    searchFocusNode.unfocus();
    searchController.text = "";
    _lastQueryText = null;
    _lastSuggestQuery = null;
    searchState.value = SearchState.initial();
    heightState.value = _midHeight;
    unawaited(_suggestCancelable?.cancel());
    unawaited(_searchCancelable?.cancel());
    if (_currentPage != null) {
      unawaited(_controller.releasePage(_currentPage!));
    }
  }

  void onClearTap() => searchController.clear();

  void _searchInputHandler() {
    clearControlState.value = searchController.text.isNotEmpty;
    if (searchController.text.length < 3) return;

    if (_suggestDebounce?.isActive ?? false) _suggestDebounce?.cancel();
    if (searchState.value.isLoading) return;
    _suggestDebounce = Timer(const Duration(milliseconds: 500), _fetchSuggests);
  }

  Future<void> _itemTapHandler(DgisObjectIdMessage? objectId) async {
    if (objectId == null) return;

    final response = await _controller.searchByObjectId(objectId);
    final point = response.markerPosition;

    if (point != null) {
      searchFocusNode.unfocus();
      onItemSelected(
        ObjectInfoState(
            dgisObjectId: DgisObjectId(
              objectId: objectId.objectId,
              entranceId: objectId.entranceId,
            ),
            latLng: LatLng(
              latitude: point.latitude,
              longitude: point.longitude,
            )),
      );
    }
  }

  /// Called typically when user taps search icon in field and on filter change
  Future<void> _performSearch({
    required Future<SearchResultMessage> searchFuture,
    required String? queryText,
  }) async {
    searchState.value = SearchState.loading();
    searchController.text = queryText ?? "";

    await _suggestCancelable?.cancel();
    await _searchCancelable?.cancel();

    _searchCancelable = CancelableOperation.fromFuture(searchFuture);
    final response = await _searchCancelable?.value;
    final items = response?.firstPage?.items;
    _currentPage = response?.firstPage;

    if (items != null) {
      final responseDistance = await _controller.getDistanceTo(
        _mapToDistanceRequest(
          items.whereType<DirectoryObjectMessage>().toList(),
        ),
      );

      searchState.value = SearchState.data(
        _concatObjectsWithDistance(
          items.whereType<DirectoryObjectMessage>().toList(),
          responseDistance,
        ),
      );

      _lastQueryText = queryText;
      _lastSuggestQuery = queryText;
      heightState.value = _maxHeight;
    }
  }

  List<DistanceRequestMessage> _mapToDistanceRequest(
          List<DirectoryObjectMessage> values) =>
      values
          .where((element) => element.id != null)
          .where((element) => element.markerPosition != null)
          .map((e) => DistanceRequestMessage(
                geoPoint: GeoPointMessage(
                  latitude: e.markerPosition!.latitude,
                  longitude: e.markerPosition!.longitude,
                ),
                dgisObjectId: e.id!,
              ))
          .toList();

  Future<void> _fetchSuggests() async {
    final queryText = searchController.text;
    if (queryText.isEmpty || queryText == _lastSuggestQuery) return;

    searchState.value = SearchState.loading();

    await _suggestCancelable?.cancel();
    await _searchCancelable?.cancel();

    _suggestCancelable =
        CancelableOperation.fromFuture(_controller.fetchSuggest(queryText));
    final response = await _suggestCancelable?.value;

    if (response != null) {
      _lastSuggestQuery = queryText;
      searchState.value = SearchState.suggests(
        response.suggests.whereType<SuggestMessage>().toList(),
      );
      heightState.value = _maxHeight;
    }
  }

  List<ObjectInfo> _concatObjectsWithDistance(
    List<DirectoryObjectMessage> objects,
    List<DistanceResponseMessage>? distanceList,
  ) {
    print("_concatObjectsWithDistance ${objects.length}");

    return objects
        .where((element) => element.markerPosition != null)
        .map((object) => ObjectInfo.fromMessage(
              object,
              distanceList
                  ?.firstWhereOrNull(
                    (e) => e.dgisObjectId?.objectId == object.id?.objectId,
                  )
                  ?.distance
                  .floor(),
            ))
        .toList();
  }

  Future<void> _paginationListener() async {
    if (!searchState.value.hasData) return;

    if (paginationController.position.maxScrollExtent -
            paginationController.offset <
        50) {
      if (_currentPage == null) {
        return;
      }

      final page = await _controller.fetchNextPage(_currentPage!);
      _controller.releasePage(_currentPage!);
      _currentPage = page;
      final items = page.items.whereType<DirectoryObjectMessage>().toList();

      final responseDistance = await _controller.getDistanceTo(
        _mapToDistanceRequest(items),
      );

      searchState.value = SearchState.data(
        List.of([
          ...searchState.value.data ?? [],
          ..._concatObjectsWithDistance(
            items,
            responseDistance,
          ),
        ]),
      );
    }
  }

  void _searchFiledFocusHandler() {
    if (searchFocusNode.hasFocus) {
      heightState.value = _maxHeight;
    }
    _updateControlsState();
  }

  void _updateControlsState() {
    cancelControlState.value = searchFocusNode.hasFocus ||
        searchState.value.isLoading ||
        searchState.value.hasData ||
        searchState.value.hasSuggests;
  }

  static const _midHeight = 220.0;
  double _maxHeight = _midHeight;

  set max(double? value) {
    if (value != null) _maxHeight = value;
  }
}

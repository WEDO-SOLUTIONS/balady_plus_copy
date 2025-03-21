import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/search/providers/search_pagination.dart';
import 'package:mapness/features/search/ui/add_place_item.dart';
import 'package:mapness/pages/map_search/ui/map_search_empty.dart';

class SearchResults extends ConsumerStatefulWidget {
  final SearchResultMessage results;
  final ScrollController scrollController;
  final Widget Function(BuildContext) loaderBuilder;
  final Widget Function(BuildContext, DirectoryObjectMessage) itemBuilder;
  final bool? isShowAddPlace;

  const SearchResults({
    required this.results,
    required this.scrollController,
    required this.loaderBuilder,
    required this.itemBuilder,
    this.isShowAddPlace,
    super.key,
  });

  @override
  ConsumerState<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<SearchResults> {
  bool _hasNext = true;
  bool _isLoading = false;
  late final bool _isShowAddPlace = widget.isShowAddPlace ?? true;

  @override
  void initState() {
    super.initState();
    // Check if the first page has more than 5 items to determine if there is more data to fetch
    // We need it to show loader at the end of the list
    _hasNext = (widget.results.firstPage?.items.length ?? 0) > 5;
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final current = widget.scrollController.position.pixels;
    final max = widget.scrollController.position.maxScrollExtent;

    final delta = MediaQuery.of(context).size.height * 0.2;

    if (!_isLoading && max - current <= delta) {
      _isLoading = true;
      ref.read(searchPaginationProvider(widget.results).notifier).fetchNext().then(
        (hasNext) {
          _isLoading = false;
          setState(() => _hasNext = hasNext);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchPaginationProvider(widget.results));
    if (results.isEmpty) {
      return MapSearchEmpty(isShowAddPlaceButton: _isShowAddPlace);
    }
    // If the result list is not empty add AddPlaceItem at the end of the list
    final totalCount = results.length + (_isShowAddPlace ? 1 : 0);

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == results.length && _isShowAddPlace) {
          if (_hasNext) {
            return widget.loaderBuilder(context);
          }
          return AddPlaceItem(
            onTapMetrics: () {
              ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiSearch);
            },
          );
        }

        return widget.itemBuilder(context, results[index]);
      },
      itemCount: totalCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}

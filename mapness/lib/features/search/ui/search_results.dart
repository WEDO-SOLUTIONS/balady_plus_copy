import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/providers/search_pagination.dart';
import 'package:mapness/features/search/ui/add_place_item.dart';

class SearchResults extends ConsumerStatefulWidget {
  const SearchResults({
    required this.results,
    required this.scrollController,
    required this.loaderBuilder,
    required this.itemBuilder,
    super.key,
  });

  final SearchResultMessage results;
  final ScrollController scrollController;
  final Widget Function(BuildContext) loaderBuilder;
  final Widget Function(BuildContext, DirectoryObjectMessage) itemBuilder;

  @override
  ConsumerState<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<SearchResults> {
  bool _hasNext = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
    final hasAddPlaceAtEnd = results.isNotEmpty && results.length < 10;
    final totalCount = results.length + (results.length ~/ 10) + (hasAddPlaceAtEnd ? 1 : 0);

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        /// every 10th item should be an AddPlaceItem
        if (_hasNext && index == totalCount) {
          return widget.loaderBuilder(context);
        }

        final addPlaceItemsBeforeIndex = index ~/ 10;
        final actualResultIndex = index - addPlaceItemsBeforeIndex;

        // Check if this position should be an AddPlaceItem
        final isAddPlacePosition =
            (index + 1) % 10 == 0 || (hasAddPlaceAtEnd && actualResultIndex == results.length - 1);

        if (isAddPlacePosition) {
          return const AddPlaceItem();
        }

        return widget.itemBuilder(context, results[actualResultIndex]);
      },
      itemCount: totalCount + (_hasNext ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}

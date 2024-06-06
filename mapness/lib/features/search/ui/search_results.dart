import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/providers/search_pagination.dart';

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

    if (max - current <= delta) {
      ref.read(searchPaginationProvider(widget.results).notifier).fetchNext().then(
        (hasNext) {
          setState(() {
            _hasNext = hasNext;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchPaginationProvider(widget.results));

    return ListView.separated(
      shrinkWrap: true,
      cacheExtent: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == results.length) {
          return widget.loaderBuilder(context);
        }

        return widget.itemBuilder(context, results[index]);
      },
      itemCount: results.length + (_hasNext ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }
}

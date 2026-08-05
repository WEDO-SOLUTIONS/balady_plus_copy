import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_pagination.dart';
import 'package:mapness/features/search/ui/add_place_item.dart';
import 'package:mapness/pages/map_search/ui/map_search_empty.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

class SearchResults extends ConsumerStatefulWidget {
  final SearchResultMessage results;
  final ScrollController bottomSheetContentScrollController;
  final Widget Function(BuildContext) loaderBuilder;
  final bool showAddPlace;
  final bool showSearchMore;
  final Widget Function(BuildContext, DirectoryObjectMessage, int) itemBuilder;

  const SearchResults({
    required this.results,
    required this.bottomSheetContentScrollController,
    required this.loaderBuilder,
    required this.itemBuilder,
    this.showAddPlace = true,
    this.showSearchMore = false,
    super.key,
  });

  @override
  ConsumerState<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<SearchResults> {
  bool _hasNext = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Check if the first page has more than 5 items to determine if there is more data to fetch
    // We need it to show loader at the end of the list
    _hasNext = (widget.results.firstPage?.items.length ?? 0) > 5;
    widget.bottomSheetContentScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.bottomSheetContentScrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final current = widget.bottomSheetContentScrollController.position.pixels;
    final max = widget.bottomSheetContentScrollController.position.maxScrollExtent;

    final delta = MediaQuery.of(context).size.height * 0.2;

    if (!_isLoading && max - current <= delta) {
      _isLoading = true;
      final paginationNotifier = ref.read(searchPaginationProvider(widget.results).notifier);
      paginationNotifier.fetchNext().then(
        (hasNext) {
          _isLoading = false;
          if (hasNext) {
            // DataFinder: report exposure for the newly-loaded result page
            // (continued ranks, same search session).
            final scope = context.read<SearchScope>().value;
            ref
                .read(searchProvider(scope).notifier)
                .reportResultsPageExposure(paginationNotifier.lastFetchedItems);
          }
          if (mounted) {
            setState(() => _hasNext = hasNext);
          }
        },
      );
    }
  }

  // Don't show alternative search button if we are in google search
  bool get _showSearchMore =>
      widget.showSearchMore && !ref.read(searchProvider(context.read<SearchScope>().value).notifier).isGoogleSearch;

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchPaginationProvider(widget.results));
    if (results.isEmpty) {
      return MapSearchEmpty(showAddPlaceButton: widget.showAddPlace);
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _itemBuilder(context: context, index: index, results: results)!,
      itemCount: _calculateTotalItemCount(results.length),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }

  Widget? _itemBuilder({
    required BuildContext context,
    required int index,
    required List<DirectoryObjectMessage> results,
  }) {
    void _onAlternativeSearchPressed() {
      final scope = context.read<SearchScope>();
      ref.read(searchProvider(scope.value).notifier).alternativeSearch();
    }

    // Calculate how many "Search more" buttons we've inserted so far
    final buttonsInserted = index ~/ 11; // Every 11th position (after every 10 results)

    // Calculate the actual result index
    final actualResultIndex = _showSearchMore ? index - buttonsInserted : index;

    // Check if this position should show a "Search more" button (every 11th position)
    if (_showSearchMore && index > 0 && index % 11 == 0) {
      return AppButton(
        onTap: _onAlternativeSearchPressed,
        buttonColorScheme: ButtonColorScheme.accentSecondary,
        buttonType: ButtonType.secondary,
        primaryLabel: context.l10n.searchMore,
        primaryIcon: SystemIcons.search,
      );
    }

    // Check if we've reached the end and should show loader or AddPlaceItem
    if (actualResultIndex >= results.length) {
      // If we have less than 10 items and haven't shown the button yet, show it here
      if (_showSearchMore && results.length < 10 && index == results.length) {
        return AppButton(
          onTap: _onAlternativeSearchPressed,
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          buttonType: ButtonType.secondary,
          primaryLabel: context.l10n.showMore,
          primaryIcon: SystemIcons.search,
        );
      }

      if (widget.showAddPlace) {
        if (_hasNext) {
          return widget.loaderBuilder(context);
        }
        return AddPlaceItem(
          onTapMetrics: () {
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiSearch);
          },
          googleSearchOnTap: _onAlternativeSearchPressed,
        );
      }
      return const SizedBox.shrink();
    }

    return widget.itemBuilder(
      context,
      results[actualResultIndex],
      actualResultIndex,
    );
  }

  int _calculateTotalItemCount(int resultsLength) {
    if (resultsLength == 0) {
      return 0;
    }

    // Base count: results + 1 (loader/AddPlaceItem)
    final baseCount = resultsLength + (widget.showAddPlace ? 1 : 0);

    // Only add buttons if not in Google search
    if (_showSearchMore) {
      // Add "Show Results" buttons every 11th position
      int buttonsToAdd = (resultsLength - 1) ~/ 10;

      // If we have less than 10 items, add one more button at the end
      if (resultsLength < 10 && resultsLength > 0) {
        buttonsToAdd += 1;
      }

      return baseCount + buttonsToAdd;
    }

    return baseCount;
  }
}

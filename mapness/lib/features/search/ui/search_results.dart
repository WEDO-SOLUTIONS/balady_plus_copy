import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/saudi_pass/providers/poi_offers_provider.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
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
  final Widget Function(BuildContext, DirectoryObjectMessage, int, List<Offer>) itemBuilder;
  final bool? isShowAddPlace;

  const SearchResults({
    required this.results,
    required this.bottomSheetContentScrollController,
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
      ref.read(searchPaginationProvider(widget.results).notifier).fetchNext().then(
        (hasNext) {
          _isLoading = false;
          setState(() => _hasNext = hasNext);
        },
      );
    }
  }

  // Don't show alternative search button if we are in google search
  bool _getShowAlternativeSearchButton() {
    // TODO: amr hide the search more for now
    // final scope = context.read<SearchScope>();
    // return !ref.read(searchProvider(scope.value).notifier).isGoogleSearch;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    void _onAlternativeSearchPressed() {
      final scope = context.read<SearchScope>();
      ref.read(searchProvider(scope.value).notifier).alternativeSearch();
    }

    final results = ref.watch(searchPaginationProvider(widget.results));
    final offers = ref.watch(poiOffersProvider);
    if (results.isEmpty) {
      return MapSearchEmpty(isShowAddPlaceButton: _isShowAddPlace);
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // Calculate how many "Show Results" buttons we've inserted so far
        final buttonsInserted = index ~/ 11; // Every 11th position (after every 10 results)

        // Calculate the actual result index
        final actualResultIndex = index - buttonsInserted;

        // Check if this position should show a "Show Results" button (every 11th position)
        if (index > 0 && index % 11 == 0 && _getShowAlternativeSearchButton()) {
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
          if (results.length < 10 && index == results.length && _getShowAlternativeSearchButton()) {
            return AppButton(
              onTap: _onAlternativeSearchPressed,
              buttonColorScheme: ButtonColorScheme.accentSecondary,
              buttonType: ButtonType.secondary,
              primaryLabel: context.l10n.showMore,
              primaryIcon: SystemIcons.search,
            );
          }

          if (_isShowAddPlace) {
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

        return widget.itemBuilder(context, results[actualResultIndex], actualResultIndex,
            offers[results[actualResultIndex].tradeLicense?.license.trim()] ?? []);
      },
      itemCount: _calculateTotalItemCount(results.length),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }

  int _calculateTotalItemCount(int resultsLength) {
    if (resultsLength == 0) {
      return 0;
    }

    // Base count: results + 1 (loader/AddPlaceItem)
    final baseCount = resultsLength + (_isShowAddPlace ? 1 : 0);

    // Only add buttons if not in Google search
    if (_getShowAlternativeSearchButton()) {
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

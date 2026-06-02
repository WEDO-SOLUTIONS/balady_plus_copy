import 'package:balady_uikit/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/pages/map_search/ui/map_search_empty.dart';
import 'package:mapness/pages/routing/ui/routing_search_history.dart';
import 'package:mapness/pages/routing/ui/routing_search_results.dart';
import 'package:mapness/pages/routing/ui/routing_suggest_list.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:provider/provider.dart';

class RoutingSearchContent extends ConsumerWidget {
  const RoutingSearchContent({
    required this.bottomSheetContentScrollController,
    required this.showMyLocation,
    super.key,
  });

  final bool showMyLocation;
  final ScrollController bottomSheetContentScrollController;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final scope = context.read<SearchScope>();
    final searchState = ref.watch(searchProvider(scope.value));
    ref.listen(searchProvider(scope.value), (_oldState, newState) {
        if (newState is SearchStateEmpty) {
          ref.read(urbiAnalyticsProvider).track(
            'searchFailed',
            properties: {
              'text': newState.searchText,
            },
          );
        }
      });

    return searchState.map(
      empty: () => const SafeArea(
        top: false,
        child: MapSearchEmpty(),
      ),
      history: () => SafeArea(
        top: false,
        child: RoutingSearchHistory(
          showMyLocation: showMyLocation,
        ),
      ),
      loading: () => SafeArea(
        top: false,
        child: Center(
          child: Loading(
            orientation: Axis.vertical,
            size: LoaderSize.large,
            title: context.l10n.loading,
          ),
        ),
      ),
      suggest: (suggest) => SafeArea(
        top: false,
        child: RoutingSuggestList(
          suggest: suggest,
        ),
      ),
      results: (results) => SafeArea(
        top: false,
        child: RoutingSearchResults(
          results: results,
          bottomSheetContentScrollController: bottomSheetContentScrollController,
        ),
      ),
      failure: (query, errorMessage) => BaseErrorWidget(
          errorLabel: errorMessage,
          onRetry: () {
            ref.read(searchProvider(scope.value).notifier).searchQueryChanged(query);
          }),
    );
  }
}

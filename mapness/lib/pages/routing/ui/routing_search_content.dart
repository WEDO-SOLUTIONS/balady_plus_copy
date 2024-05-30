import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/pages/map_search/ui/map_search_empty.dart';
import 'package:mapness/pages/routing/ui/routing_search_history.dart';
import 'package:mapness/pages/routing/ui/routing_search_results.dart';
import 'package:mapness/pages/routing/ui/routing_suggest_list.dart';
import 'package:provider/provider.dart';

class RoutingSearchContent extends ConsumerWidget {
  const RoutingSearchContent({
    required this.scrollController,
    required this.showMyLocation,
    super.key,
  });

  final bool showMyLocation;
  final ScrollController scrollController;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final scope = context.read<SearchScope>();
    final searchState = ref.watch(searchProvider(scope.value));

    return searchState.map(
      empty: () => const SliverFillRemaining(
        child: SafeArea(
          top: false,
          child: MapSearchEmpty(),
        ),
      ),
      history: () => SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: RoutingSearchHistory(
            showMyLocation: showMyLocation,
          ),
        ),
      ),
      suggest: (suggest) => SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: RoutingSuggestList(
              suggest: suggest,
            ),
          ),
        ),
      ),
      results: (results) => SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: Container(
            color: Colors.white,
            child: RoutingSearchResults(
              results: results,
              scrollController: scrollController,
            ),
          ),
        ),
      ),
    );
  }
}

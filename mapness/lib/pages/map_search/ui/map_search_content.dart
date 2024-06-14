import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/pages/map_search/ui/map_lost_internet.dart';
import 'package:mapness/pages/map_search/ui/map_search_empty.dart';
import 'package:mapness/pages/map_search/ui/map_search_history.dart';
import 'package:mapness/pages/map_search/ui/map_search_results.dart';
import 'package:mapness/pages/map_search/ui/map_suggest_list.dart';
import 'package:provider/provider.dart';

class MapSearchContent extends ConsumerStatefulWidget {
  const MapSearchContent({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  ConsumerState<MapSearchContent> createState() => _MapSearchContentState();
}

class _MapSearchContentState extends ConsumerState<MapSearchContent> {
  bool _isLostInternet = false;

  @override
  void initState() {
    _isLostInternet = ref.read(networkStatusProvider) == ConnectivityResult.none;
    super.initState();
  }

  void _watchInternet(BuildContext context, haveInternet) {
    if (context.mounted) {
      setState(() {
        _isLostInternet = haveInternet;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.read<SearchScope>();
    final searchState = ref.watch(searchProvider(scope.value));

    ref.listen(
      networkStatusProvider,
      (previous, next) {
        if (next == ConnectivityResult.none) {
          _watchInternet(context, true);
        }
      },
    );

    if (_isLostInternet) {
      return SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: MapLostInternet(
            onTap: () {
              _watchInternet(context, false);
              ref.read(searchProvider(scope.value).notifier).refresh();
            },
          ),
        ),
      );
    }

    return searchState.map(
      empty: () => const SliverFillRemaining(
        hasScrollBody: false,
        child: SafeArea(
          top: false,
          child: MapSearchEmpty(),
        ),
      ),
      history: () => const SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: MapSearchHistory(),
        ),
      ),
      suggest: (suggest) => SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: MapSuggestList(
              suggest: suggest,
            ),
          ),
        ),
      ),
      results: (results) => SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: MapSearchResults(
            results: results,
            scrollController: widget.scrollController,
          ),
        ),
      ),
    );
  }
}

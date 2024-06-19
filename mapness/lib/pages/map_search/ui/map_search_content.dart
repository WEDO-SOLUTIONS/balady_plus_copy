import 'dart:async';

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
  Timer? _debounceTimer;

  @override
  void initState() {
    _isLostInternet = ref.read(networkStatusProvider) == ConnectivityResult.none;
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateInternetStatus(BuildContext context, bool haveInternet) {
    if (context.mounted) {
      setState(() {
        _isLostInternet = haveInternet;
      });
    }
  }

  void _debouncedUpdate(BuildContext context, ConnectivityResult next) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final bool noInternet = next == ConnectivityResult.none;

      if (noInternet) {
        _updateInternetStatus(context, noInternet);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.read<SearchScope>();
    final searchState = ref.watch(searchProvider(scope.value));

    ref.listen(
      networkStatusProvider,
      (previous, next) {
        _debouncedUpdate(context, next);
      },
    );

    if (_isLostInternet) {
      return SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: MapLostInternet(
            onTap: () async {
              _updateInternetStatus(
                context,
                ref.read(networkStatusProvider) == ConnectivityResult.none,
              );
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

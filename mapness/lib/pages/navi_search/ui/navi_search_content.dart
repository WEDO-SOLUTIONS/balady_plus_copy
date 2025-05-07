import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/pages/map_search/ui/map_lost_internet.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_empty.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_history.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_results.dart';
import 'package:mapness/pages/navi_search/ui/navi_suggest_list.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:mapness/widgets/navi_search/navi_find_in_fav.dart';
import 'package:mapness/widgets/navi_search/navi_quick_filter.dart';
import 'package:provider/provider.dart';

class NaviSearchContent extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const NaviSearchContent({
    required this.scrollController,
    super.key,
  });

  @override
  ConsumerState<NaviSearchContent> createState() => _MapSearchContentState();
}

class _MapSearchContentState extends ConsumerState<NaviSearchContent> {
  bool _hasConnection = true;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateInternetStatus(BuildContext context, bool hasConnection) {
    if (context.mounted) {
      // If the [hasConnection] value has changed we rebuild widget with `setState`
      // Otherwise we do nothing
      if (hasConnection != _hasConnection) {
        setState(() {
          _hasConnection = hasConnection;
        });
      }
    }
  }

  void _debouncedUpdate(BuildContext context, bool hasConnection) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _updateInternetStatus(context, hasConnection);
    });
  }

  @override
  Widget build(BuildContext context) {
    _hasConnection = ref.watch(networkStatusProvider);
    final scope = context.read<SearchScope>();
    final searchState = ref.watch(searchProvider(scope.value));
    ref
      ..listen(searchProvider(scope.value), (_oldState, newState) {
        if (newState is SearchStateEmpty) {
          ref.read(urbiAnalyticsProvider).track(
            'searchFailed',
            properties: {
              'text': newState.searchText,
            },
          );
        }
      })
      ..listen(
        networkStatusProvider,
        (_, hasConnection) {
          _debouncedUpdate(context, hasConnection);
        },
      );

    if (!_hasConnection) {
      return SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MapLostInternet(
              onTap: () async {
                await ref.read(networkStatusProvider.notifier).update();
                _updateInternetStatus(context, ref.read(networkStatusProvider));
              },
            ),
          ),
        ),
      );
    }

    return searchState.map(
      empty: () => const SliverFillRemaining(
        hasScrollBody: false,
        child: SafeArea(
          top: false,
          child: NaviSearchEmpty(),
        ),
      ),
      history: () => SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              NaviQuickFilter(
                onFilterSelected: (q) => ref.read(searchProvider(scope.value).notifier).searchByText(q),
              ),
              const NaviFindInFav(),
              const NaviSearchHistory(),
            ],
          ),
        ),
      ),
      loading: () => SliverFillRemaining(
        hasScrollBody: false,
        child: SafeArea(
          top: false,
          child: Center(
            child: Loading(
              orientation: Axis.vertical,
              size: LoaderSize.large,
              title: context.l10n.loading,
            ),
          ),
        ),
      ),
      suggest: (suggest) => SliverToBoxAdapter(
        child: NaviSuggestList(
          suggest: suggest,
        ),
      ),
      results: (results) => SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: NaviSearchResults(
              results: results,
              scrollController: widget.scrollController,
            ),
          ),
        ),
      ),
      failure: (query, errorMessage) => SliverToBoxAdapter(
        child: BaseErrorWidget(
          errorLabel: errorMessage,
          onRetry: () {
            ref.read(searchProvider(scope.value).notifier).searchByText(query);
          },
        ),
      ),
    );
  }
}

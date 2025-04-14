import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/pages/feedback/feedback_address/feedback_address_suggest.dart';
import 'package:mapness/pages/map_search/ui/map_search_empty.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:provider/provider.dart';

class FeedbackAddressContent extends ConsumerWidget {
  const FeedbackAddressContent({
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
      empty: () => const SafeArea(
        top: false,
        child: MapSearchEmpty(),
      ),
      history: () => const SafeArea(
        top: false,
        child: MapSearchEmpty(),
      ),
      loading: () => const SafeArea(
        top: false,
        child: Center(
          child: Loading(
            orientation: Axis.vertical,
            size: LoaderSize.large,
          ),
        ),
      ),
      suggest: (suggest) => SafeArea(
        top: false,
        child: FeedbackAddressSuggestions(
          suggest: suggest,
        ),
      ),
      results: (_) => const SafeArea(
        top: false,
        child: MapSearchEmpty(),
      ),
      failure: (query, errorMessage) => BaseErrorWidget(
          errorLabel: errorMessage,
          onRetry: () {
            ref.read(searchProvider(scope.value).notifier).searchAddress(query);
          }),
    );
  }
}

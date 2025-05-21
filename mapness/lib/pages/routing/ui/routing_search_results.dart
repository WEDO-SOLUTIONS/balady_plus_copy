import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_results.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';
import 'package:provider/provider.dart';

class RoutingSearchResults extends ConsumerWidget {
  const RoutingSearchResults({
    required this.results,
    required this.scrollController,
    super.key,
  });

  final SearchResultMessage results;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();
    final language = ref.watch(appLanguageProvider);
    final myLocation = ref.watch(locationProvider);

    return SearchResults(
      results: results,
      scrollController: scrollController,
      loaderBuilder: (context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ),
      itemBuilder: (context, item) => SearchItem(
        result: item,
        language: language,
        myLocation:
            myLocation == null ? null : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
        onTap: () {
          Metrics.logEventAdvanced(MetricsConstants.routesKeys.searchElement,
              group: MetricsConstants.routesTag,
              action: MetricAction.tap.toString(),
              props: {'item': item.id?.objectId});

          final isFromSuggest = ref.read(searchProvider(scope.value).notifier).searchFromSuggest;
          if (isFromSuggest) {
            ref.read(urbiAnalyticsProvider.notifier).trackWithPrint(
                  '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.suggestionPressed}',
                );
          } else {
            ref.read(urbiAnalyticsProvider.notifier).trackWithPrint(
                  '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.fullSearchResultPressed}',
                );
          }

          ref.read(searchHistoryProvider(scope.value).notifier).put(
                SearchHistoryItem.fromDirectoryObject(item),
              );
          context.router.popForced(RoutePointDirectoryObject(item));
        },
      ),
    );
  }
}

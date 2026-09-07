import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_results.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/directory_obj_ext.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/search_type_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';
import 'package:provider/provider.dart';

class RoutingSearchResults extends ConsumerWidget {
  const RoutingSearchResults({
    required this.results,
    required this.bottomSheetContentScrollController,
    super.key,
  });

  final SearchResultMessage results;
  final ScrollController bottomSheetContentScrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();
    final language = ref.watch(appLanguageProvider);
    final myLocation = ref.watch(locationProvider);

    Future<void> _bssAnalyticRequest({
      required SearchResultMessage results,
      required DirectoryObjectMessage item,
    }) async {
      final index =
          results.firstPage?.items.indexWhere(
            (e) => e.id?.objectId == item.id?.objectId,
          ) ??
          0;
      final scope = context.read<SearchScope>();
      final isFromSuggest = ref.read(searchProvider(scope.value).notifier).searchFromSuggest;

      if (item.markerPosition == null) {
        debugPrint('GeoPosition for this object is null');
      }
      await BssService.instance.sendEvent(
        BssRequest(
          eventType: BSSEventType.action,
          actionType: BSSActionType.tap,
          uiElement: BssUIElement(
            name: BssUIElementNames.placeCardMini,
            ownerName: isFromSuggest ? BssUIElementNames.suggestList : BssUIElementNames.searchResultList,
            position: index + 1,
          ),
          payload: BssPayload(
            placeItem: item.toBss(index),
            searchResultList: results.toBss(),
          ),
        ),
      );
    }

    return SearchResults(
      results: results,
      bottomSheetContentScrollController: bottomSheetContentScrollController,
      loaderBuilder: (context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ),
      itemBuilder: (context, item, index) => SearchItem(
        result: item,
        language: language,
        myLocation: myLocation == null
            ? null
            : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
        onTap: () {
          Metrics.logEventAdvanced(
            MetricsConstants.routesKeys.searchElement,
            group: MetricsConstants.routesTag,
            action: MetricAction.tap.toString(),
            props: {'item': item.id?.objectId},
          );

          _bssAnalyticRequest(results: results, item: item);

          final isFromSuggest = ref.read(searchProvider(scope.value).notifier).searchFromSuggest;
          if (isFromSuggest) {
            ref
                .read(urbiAnalyticsProvider.notifier)
                .trackWithPrint(
                  '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.suggestionPressed}',
                );
          } else {
            ref
                .read(urbiAnalyticsProvider.notifier)
                .trackWithPrint(
                  '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.fullSearchResultPressed}',
                );
          }

          ref
              .read(searchHistoryProvider(scope.value).notifier)
              .put(
                SearchHistoryItem.fromDirectoryObject(item).toMessage(),
              );
          ref.read(searchProvider(scope.value).notifier).reportSearchResultsClick(item: item, rank: index + 1);
          context.router.pop(RoutePointDirectoryObject(item));
        },
        index: index,
      ),
    );
  }
}

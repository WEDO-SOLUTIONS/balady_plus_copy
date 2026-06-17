import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/poi_card/data/poi_data_google.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_results.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
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

class MapSearchResults extends ConsumerWidget {
  const MapSearchResults({
    required this.results,
    required this.bottomSheetContentScrollController,
    super.key,
  });

  final SearchResultMessage results;
  final ScrollController bottomSheetContentScrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final myLocation = ref.watch(locationProvider);

    final isGoogleSearch = ref.watch(searchProvider(context.read<SearchScope>().value).notifier).isGoogleSearch;

    void _sendSuggestionPressed() {
      final scope = context.read<SearchScope>();
      final isFromSuggest = ref.read(searchProvider(scope.value).notifier).searchFromSuggest;
      if (isFromSuggest) {
        ref
            .read(urbiAnalyticsProvider.notifier)
            .trackWithPrint(
              '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.suggestionPressed}',
            );
      } else {
        ref
            .read(urbiAnalyticsProvider)
            .track(
              '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.fullSearchResultPressed}',
            );
      }
    }

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
      child: SearchResults(
        results: results,
        bottomSheetContentScrollController: bottomSheetContentScrollController,
        loaderBuilder: (context) => Center(
          child: CircularProgressIndicator(
            color: context.colors.accentDefault,
          ),
        ),
        itemBuilder: (context, item, index) => SearchItem(
          result: item,
          language: language,
          myLocation: myLocation == null
              ? null
              : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
          onTap: () {
            _bssAnalyticRequest(results: results, item: item);
            // DataFinder: card-body tap = View POI Details.
            final scope = context.read<SearchScope>();
            ref.read(searchProvider(scope.value).notifier).reportSearchResultsClick(item: item, rank: index + 1);
            _onResultTap(context, item, _sendSuggestionPressed, isGoogleSearch);
          },
          searchResultList: results.toBss(),
          index: index,
        ),
      ),
    );
  }

  void _onResultTap(
    BuildContext context,
    DirectoryObjectMessage item,
    void Function() sendSuggestionPressed,
    bool isGoogleSearch,
  ) {
    if (item.id == null) {
      return;
    }

    sendSuggestionPressed();

    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.searchResult,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
      props: {
        'object': item.id!.objectId,
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      final markerPosition = item.markerPosition;
      context.router.replaceOrPush(
        route: PoiCardWidgetRoute(
          objectId: item.id,
          closestPoint: markerPosition != null
              ? LatLng(latitude: markerPosition.latitude, longitude: markerPosition.longitude)
              : null,
          cameraConfig: const PoiCameraConfig(zoom: 18),
          poiCardDataFromGoogle: isGoogleSearch
              ? PoiCardDataFromGoogle(
                  id: item.id!.objectId.toString(),
                  displayName: item.title,
                  location: item.markerPosition != null
                      ? LatLng(
                          latitude: item.markerPosition!.latitude,
                          longitude: item.markerPosition!.longitude,
                        )
                      : null,
                )
              : null,
        ),
        toCompareRoutes: [PoiCardWidgetRoute.page],
      );
    });
  }
}

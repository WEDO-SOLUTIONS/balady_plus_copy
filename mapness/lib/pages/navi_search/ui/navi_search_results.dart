import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/search/ui/search_results.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';

class NaviSearchResults extends ConsumerWidget {
  const NaviSearchResults({
    required this.results,
    required this.scrollController,
    super.key,
  });

  final SearchResultMessage results;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final myLocation = ref.watch(locationProvider);

    return SearchResults(
      isShowAddPlace: false,
      results: results,
      scrollController: scrollController,
      loaderBuilder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: CircularProgressIndicator(
            color: context.colorsV2.accentDefault,
          ),
        ),
      ),
      itemBuilder: (context, item) => SearchItem(
        contentColor: context.colorsV3.backgroundSurface1,
        result: item,
        language: language,
        myLocation:
            myLocation == null ? null : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
        onTap: () => _onResultTap(context, item),
      ),
    );
  }

  void _onResultTap(BuildContext context, DirectoryObjectMessage item) {
    if (item.id == null) {
      return;
    }

    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.searchResult,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
      props: {
        'object': item.id!.objectId,
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.router.replaceOrPush(
        route: PoiCardWidgetRoute(
          objectId: DgisObjectIdMessage(
            objectId: item.id!.objectId,
            entranceId: 0,
          ),
          cameraConfig: const PoiCameraConfig(zoom: 18),
        ),
        toCompareRoutes: [PoiCardWidgetRoute.page],
      );
    });
  }
}

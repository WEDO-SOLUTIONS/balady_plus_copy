import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/suggest_item.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:provider/provider.dart';

class NaviSuggestList extends ConsumerWidget {
  const NaviSuggestList({
    required this.suggest,
    super.key,
  });

  final SuggestResultMessage suggest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = suggest.suggests.whereType<SuggestMessage>().toList();
    final myLocation = ref.watch(locationProvider);
    final scope = context.read<SearchScope>();
    final searchText = ref.read(searchProvider(scope.value)).searchText;

    void onObjectTap(DirectoryObjectMessage object) {
      final objectId = object.id?.objectId;
      if (objectId != null) {
        Metrics.logEventAdvanced(
          MetricsConstants.searchKeys.suggestion,
          group: MetricsConstants.searchTag,
          action: MetricAction.tap.toString(),
          props: {
            'object': objectId,
          },
        );

        context.router.replaceOrPush(
          route: PoiCardWidgetRoute(
            objectId: DgisObjectIdMessage(
              objectId: object.id!.objectId,
              entranceId: 0,
            ),
            cameraConfig: const PoiCameraConfig(zoom: 18),
          ),
          toCompareRoutes: [PoiCardWidgetRoute.page],
        );
      }
    }

    return Container(
      padding: const EdgeInsets.only(
        top: Spacing.$4x,
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
            color: context.colors.backgroundSurface1,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemBuilder: (context, index) => SuggestItem(
                iconColor: context.colors.foregroundMuted,
                tralingTextColor: context.colors.foregroundSoft,
                suggest: suggests[index],
                myLocation: myLocation == null
                    ? null
                    : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
                isLast: index == suggests.length - 1,
                onObjectTap: onObjectTap,
                index: index,
                suggestList: BssSuggestList(size: suggests.length),
                searchRequest: BssSearchRequest(text: searchText),
              ),
              itemCount: suggests.length,
            ),
          ),
        ],
      ),
    );
  }
}

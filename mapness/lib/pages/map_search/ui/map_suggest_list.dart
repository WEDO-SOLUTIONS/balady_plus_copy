import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/search/ui/suggest_item.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';

class MapSuggestList extends ConsumerWidget {
  const MapSuggestList({
    required this.suggest,
    super.key,
  });

  final SuggestResultMessage suggest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = suggest.suggests.whereType<SuggestMessage>().toList();
    final myLocation = ref.watch(locationProvider);
    final contentColor = context.colorsV2.backgroundSurface4;

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

          context.router.push(
            PoiCardWidgetRoute(
              objectId: DgisObjectIdMessage(
                objectId: object.id!.objectId,
                entranceId: 0,
              ),
              cameraConfig: PoiCameraConfig(zoom: 18),
            ),
          );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
        color: contentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (context, index) => SuggestItem(
              suggest: suggests[index],
              myLocation: myLocation == null
                  ? null
                  : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
              isLast: index == suggests.length - 1,
              onObjectTap: onObjectTap,
            ),
            itemCount: suggests.length,
          ),
        ),
      ),
    );
  }
}

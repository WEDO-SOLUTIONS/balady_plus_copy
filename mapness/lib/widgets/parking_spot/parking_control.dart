import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:provider/provider.dart';

class ParkingControl extends ConsumerWidget {
  const ParkingControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(parkingManageProvider(theme: context.read<ThemeController>().currentTheme)).value;

    if (result == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: Spacing.$1_5x),
      child: SizedBox(
        width: 28,
        height: 28,
        child: MapButton(
          onTap: () {
            final cameraPosition = ref.read(cameraPositionProvider);
            if (cameraPosition == null) {
              return;
            }

            ref
                .read(cameraPositionProvider.notifier)
                .animateTo(
                  CameraPositionMessage(
                    point: GeoPointMessage(latitude: result.lat, longitude: result.lon),
                    zoom: cameraPosition.zoom,
                    tilt: cameraPosition.tilt,
                    bearing: cameraPosition.bearing,
                  ),
                );

            context.router.replaceOrPush(
              route: PoiCardWidgetRoute(
                closestPoint: LatLng(latitude: result.lat, longitude: result.lon),
                objectId: DgisObjectIdMessage(objectId: parkingObjectId, entranceId: 0),
              ),
              toCompareRoutes: [PoiCardWidgetRoute.page],
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(Spacing.$1x),
            child: Assets.icons.svg.parkingControl.svg(
              colorFilter: SaudiNationalDay.isNow()
                  ? ColorFilter.mode(context.colors.accentDefault, BlendMode.srcIn)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

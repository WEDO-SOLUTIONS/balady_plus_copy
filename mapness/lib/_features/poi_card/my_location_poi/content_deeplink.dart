import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_sheet_sizes.dart';
import 'package:mapness/_features/poi_card/my_location_poi/my_location_image.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/_features/poi_card/provider/poi_my_location_provider.dart';
import 'package:mapness/_features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_map_controls.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/disable_overscroll_behavior.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

import '../ui_kit_tmp/poi_header.dart';

part 'poi_deeplink_location_action.dart';
part 'poi_deeplink_location_content.dart';
part 'poi_my_location_content.dart';

@RoutePage()
class DeeplinkPage extends ConsumerWidget {
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const DeeplinkPage({
    required this.closestPoint,
    this.cameraConfig,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    _cameraAnimation(ref);

    final data = ref.watch(
      poiMyLocationProvider(
        latitude: closestPoint!.latitude,
        longitude: closestPoint!.longitude,
      ),
    );
    final sheetSizes = _calculateSheetSize(context, data);

    return Directionality(
      textDirection: switch (language) {
        Language.arabic => TextDirection.rtl,
        Language.english => TextDirection.ltr,
      },
      child: LayoutBuilder(
        builder: (context, constrains) => DgisBottomSheet(
          showBarrier: false,
          scrollBehavior: const NeverScrollableConfiguration(),
          availableExpansions: Expansion.values.toSet(),
          initialExpansion: Expansion.middle,
          collapsedHeight: sheetSizes.collapsedHeight,
          middleHeight: sheetSizes.middleHeight,
          hiddenHeight: sheetSizes.hiddenHeight,
          mapControlsBuilder: (context, bottomSheetSize, biggestHeight, smallestHeight) => PoiCardMapControls(
            bottomSheetSize: bottomSheetSize,
            biggestHeight: biggestHeight,
          ),
          body: (context) => ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                PoiDeeplinkContent(
                  location: closestPoint!,
                  onTapClose: () => onClose(context, ref),
                  data: data,
                ),
                PoiDeeplinkPersonActions(
                  onShare: () => ref.read(poiCardActionsProvider.notifier).shareMyLocation(closestPoint),
                  onGo: () {
                    context.router.popAndPush(
                      RoutingRoutesRoute(
                        points: [
                          RouteParamsPointWithLabel(
                            value: null,
                            label: context.l10n.myLocation,
                          ),
                          RouteParamsPointWithLabel(
                            value: RouteParamsPoint(
                              latitude: closestPoint!.latitude,
                              longitude: closestPoint!.longitude,
                            ),
                            label: context.l10n.pointToMap,
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onClose(BuildContext context, WidgetRef ref) async {
    context.router.popForced();
    final read = ref.read(selectedMarkerProvider.notifier);
    await read.removeAllMarkers();
  }

  Future<void> _cameraAnimation(WidgetRef ref) async {
    if (closestPoint != null) {
      final settings = MapObjectManagerSettings.myLocation();
      final mapObjectManager = ref.watch(
        mapObjectManagerProvider(
          named: settings.name,
          layerId: settings.layerId,
        ).notifier,
      );
      await mapObjectManager.removeAllMarkers();
      final marker = Markers.pinMarker(
        GeoPointWithElevationMessage(
          latitude: closestPoint!.latitude,
          longitude: closestPoint!.longitude,
          elevation: 1,
        ),
      );

      final read = ref.read(selectedMarkerProvider.notifier);
      await read.removeAllMarkers();

      await mapObjectManager.addMarker(marker);

      await ref.read(cameraPositionProvider.notifier).animateTo(
        CameraPositionMessage(
          point: GeoPointMessage(latitude: closestPoint!.latitude, longitude: closestPoint!.longitude),
          zoom: cameraConfig?.zoom ?? 16,
          tilt: cameraConfig?.tilt ?? 0,
          bearing: cameraConfig?.bearing ?? 0,
        ),
      );
    }
  }

  PoiSheetSizes _calculateSheetSize(BuildContext context, AsyncValue<PoiMyLocationState?> data) {
    bool twoLineAddress = false;
    bool twoLineTitle = false;
    final sizeOfAddress = _textSize(
      data.maybeWhen(
        data: (value) => value?.address ?? '',
        orElse: () => '',
      ),
      context.textStyleV3.bodySmallRegular,
    );
    final isAuthorized = data.maybeWhen(
      data: (value) => value?.isAuthorized ?? false,
      orElse: () => false,
    );

    if (sizeOfAddress.width > MediaQuery.of(context).size.width - Spacing.$4x) {
      twoLineAddress = true;
    }

    final sizeOfTitle = _textSize(
      data.maybeWhen(
        data: (value) => value?.title ?? '',
        orElse: () => '',
      ),
      context.textStyleV3.h4SemiBold,
    );

    if (sizeOfTitle.width > MediaQuery.of(context).size.width - Spacing.$4x - (isAuthorized ? 48 : 0) - 40) {
      twoLineTitle = true;
    }

    return PoiSheetSizes.myLocation(
      bottomPadding: MediaQuery.of(context).viewPadding.bottom,
      isAddressInTwoLines: twoLineAddress,
      isTitleInTwoLine: twoLineTitle,
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter =
    TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout();
    return textPainter.size;
  }
}

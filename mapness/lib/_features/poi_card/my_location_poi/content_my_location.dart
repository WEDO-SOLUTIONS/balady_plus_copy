import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_map_controls.dart';
import 'package:mapness/_features/profile/domain/user_profile_data.dart';
import 'package:mapness/_features/profile/widgets/profile_image_widget.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/disable_overscroll_behavior.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
// import 'package:mapness/widgets/profile/profile_image_widget.dart';

import '../ui_kit_tmp/poi_header.dart';

part 'poi_deeplink_location_action.dart';
part 'poi_deeplink_location_content.dart';
part 'poi_my_location_action.dart';
part 'poi_my_location_content.dart';

enum LocationType { myLocation, deeplinkLocation }

class ContentMyLocation extends ConsumerWidget {
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;
  final LocationType locationType;

  const ContentMyLocation({
    required this.closestPoint,
    required this.locationType,
    this.cameraConfig,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.l10n;
    final viewModel = PoiCardViewModel(ref: ref);
    final language = ref.watch(appLanguageProvider);
    _cameraAnimation(ref);

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
          collapsedHeight: 100,
          middleHeight: 162 + MediaQuery.of(context).padding.bottom,
          hiddenHeight: 90,
          mapControlsBuilder:
              (context, scrollController, biggestHeight, smallestHeight) =>
                  PoiCardMapControls(
            scrollController: scrollController,
            biggestHeight: biggestHeight,
          ),
          body: (context) => ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Builder(
              builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Builder(builder: (context) {
                    switch (locationType) {
                      case LocationType.myLocation:
                        return PoiMyLocationContent(
                          location: closestPoint!,
                          onTapClose: () => onClose(context, ref),
                        );
                      case LocationType.deeplinkLocation:
                        return PoiDeeplinkContent(
                          location: closestPoint!,
                          onTapClose: () => onClose(context, ref),
                        );
                    }
                  }),
                  Builder(builder: (context) {
                    switch (locationType) {
                      case LocationType.myLocation:
                        return MyLocationPoiActions(
                          onShare: () =>
                              viewModel.shareMyLocation(closestPoint),
                          onCopy: () => viewModel.copyToClipboard(closestPoint),
                        );
                      case LocationType.deeplinkLocation:
                        return PoiDeeplinkPersonActions(
                          onShare: () =>
                              viewModel.shareMyLocation(closestPoint),
                          onGo: () {
                            viewModel
                                .goRoute(
                                  startLabel: locale.myLocation,
                                  finishLabel: locale.pointToMap,
                                  finishLocation: closestPoint!,
                                )
                                .pushReplacement(context);
                          },
                        );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onClose(BuildContext context, WidgetRef ref) async {
    context.pop();
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
              point: GeoPointMessage(
                  latitude: closestPoint!.latitude,
                  longitude: closestPoint!.longitude),
              zoom: cameraConfig?.zoom ?? 16,
              tilt: cameraConfig?.tilt ?? 0,
              bearing: cameraConfig?.bearing ?? 0,
            ),
          );
    }
  }
}

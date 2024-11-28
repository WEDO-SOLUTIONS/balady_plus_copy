import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/my_location_poi/my_location_image.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_my_location_provider.dart';
import 'package:mapness/features/share_eta/entities/share_eta_time_type.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_sharing_sheet.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_sharing_time_sheet.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/loading/loading_overlay.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:mapness/shared/ui/share_eta/poi_my_location_action.dart';
import 'package:mapness/shared/ui/sheets/card_header.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

class ShareMyLocationContent extends HookConsumerWidget {
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const ShareMyLocationContent({
    super.key,
    this.closestPoint,
    this.cameraConfig,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final data = ref.watch(
      poiMyLocationProvider(
        latitude: closestPoint!.latitude,
        longitude: closestPoint!.longitude,
      ),
    );

    final value = data.valueOrNull;

    final isAuthorized = value?.isAuthorized ?? false;

    final title = value?.title ?? context.l10n.myLocation;
    final subTitle = isAuthorized ? context.l10n.myLocationSubtitle : null;
    final text = value?.address ?? '${closestPoint?.latitude}, ${closestPoint?.longitude}';

    const sheetPadding = 0.27;

    ref.listen(etaServiceProvider, (_, next) {
      if (context.mounted == false) {
        return;
      }
      if (next.isLoading) {
        return;
      }
      if (next.hasError) {
        LoadingOverlay.of(context).endLoading();
        context.pop();
        ToastOverlay.of(context).show(
          title: context.l10n.failedShareLiveLocation,
          actionText: context.l10n.tryAgain,
          onActionTap: () {
            _showEtaTimeSheet(context, ref);
          },
        );
      } else if (next.hasValue && next.value != null) {
        LoadingOverlay.of(context).endLoading();

        if (closestPoint == null) {
          return;
        }

        EtaStreamStorage()
          ..setLatitude(closestPoint!.latitude)
          ..setLongitude(closestPoint!.longitude);
      }
    });

    _cameraAnimation(ref);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        RoutingMapControls(
          bottomExtent: MediaQuery.of(context).size.height * sheetPadding,
        ),
        BottomSheet(
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            const RoundedRectangleBorder(),
            0,
          ),
          animationController: _animationController,
          onClosing: () => onClose(context, ref),
          showDragHandle: false,
          builder: (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Spacing.$1_5x),
                    child: SheetDragger(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                  child: CardHeader(
                    onTapClose: () => onClose(context, ref),
                    title: CardHeaderText.title(text: title, context: context),
                    subTitle: subTitle != null ? CardHeaderText.subTitle(text: subTitle, context: context) : null,
                    profileImage: isAuthorized
                        ? const Padding(
                            padding: EdgeInsets.only(top: Spacing.$1x),
                            child: MyLocationImageWidget(),
                          )
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: isAuthorized ? Spacing.$4x : Spacing.$2x),
                  child: Text(
                    text,
                    style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV2.foregroundSoft),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                MyLocationPoiActions(
                  onShare: () => _showEtaControlSheet(context, ref),
                  onCopy: () => ref.read(poiCardActionsProvider.notifier).copyToClipboard(closestPoint),
                ),
              ],
            ),
          ),
        ),
      ],
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
              point: GeoPointMessage(latitude: closestPoint!.latitude, longitude: closestPoint!.longitude),
              zoom: cameraConfig?.zoom ?? 16,
              tilt: cameraConfig?.tilt ?? 0,
              bearing: cameraConfig?.bearing ?? 0,
            ),
          );
    }
  }

  void _showEtaControlSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => EtaSharingSheet(
        onCurrentLocationPressed: () {
          context.pop();
          ref.read(poiCardActionsProvider.notifier).shareMyLocation(closestPoint);
        },
        onLiveLocationPressed: () {
          context.pop();
          _showEtaTimeSheet(context, ref);
        },
      ),
    );
  }

  void _showEtaTimeSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => EtaSharingTimeSheet(
        onConfirmTap: (v) {
          context.pop();
          LoadingOverlay.of(context).startLoading();

          ref.read(shareEtaProvider.notifier).startSharingLiveLocation(v.durationInMinutes);
        },
      ),
    );
  }
}

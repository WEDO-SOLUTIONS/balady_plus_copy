import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
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
import 'package:mapness/features/share_eta/providers/share_my_location_launch_intent.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/loading/loading_overlay.dart';
import 'package:mapness/shared/ui/measure_size.dart';
import 'package:mapness/shared/ui/share_eta/poi_my_location_action.dart';
import 'package:mapness/shared/ui/sheets/card_header.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

@RoutePage()
class ShareMyLocationPage extends HookConsumerWidget {
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const ShareMyLocationPage({super.key, this.closestPoint, this.cameraConfig});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LatLng? closestPoint;
    PoiCameraConfig? cameraConfig;

    if (this.closestPoint == null || this.cameraConfig == null) {
      final userLocation = ref.read(locationProvider);
      if (userLocation != null) {
        closestPoint = LatLng(latitude: userLocation.latitude, longitude: userLocation.longitude);
        cameraConfig = const PoiCameraConfig(zoom: 17, bearing: 0, tilt: 0);
      }
    } else {
      closestPoint = this.closestPoint;
      cameraConfig = this.cameraConfig;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        final intent = ref.read(shareMyLocationLaunchIntentProvider.notifier).consume();
        if (intent == ShareMyLocationLaunchMode.liveLocationOptions) {
          _showEtaControlSheet(context, ref, closestPoint: closestPoint);
        }
      });
      return null;
    }, const []);

    final _bottomHeightNotifier = useState(0.0);
    final _animationController = useAnimationController(duration: const Duration(milliseconds: 300));

    final data = ref.watch(poiMyLocationProvider(closestPoint: closestPoint, cameraConfig: cameraConfig));

    final value = data.value;

    final isAuthorized = value?.isAuthorized ?? false;

    final title = value?.title ?? context.l10n.myLocation;
    final subTitle = isAuthorized ? context.l10n.myLocationSubtitle : null;
    final text = data.maybeWhen(data: (v) => v?.address ?? '', orElse: () => '');

    ref.listen(etaServiceProvider, (_, next) {
      if (context.mounted == false) {
        return;
      }
      if (next.isLoading) {
        return;
      }
      if (next.hasError) {
        LoadingOverlay.of(context).endLoading();
        context.router.pop();
        ToastOverlay.of(context).show(
          title: context.l10n.failedShareLiveLocation,
          displayDuration: ToastOverlayState.actionableDisplayDuration,
          actions: [
            ToastAction(
              title: context.l10n.tryAgain,
              onTap: () {
                _showEtaTimeSheet(context, ref);
              },
            ),
          ],
        );
      } else if (next.hasValue && next.value != null) {
        LoadingOverlay.of(context).endLoading();
        context.router.popUntilRouteWithName(BottomMenuRoute.name);

        if (closestPoint == null) {
          return;
        }

        EtaStreamStorage()
          ..setLatitude(closestPoint.latitude)
          ..setLongitude(closestPoint.longitude);
      }
    });

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        RoutingMapControls(bottomHeightNotifier: _bottomHeightNotifier),
        MeasureSize(
          onChange: (size) {
            _bottomHeightNotifier.value = size.height + Spacing.$3x;
          },
          child: BottomSheet(
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              const RoundedRectangleBorder(),
              0,
            ),
            animationController: _animationController,
            onClosing: () => onClose(context, ref),
            showDragHandle: false,
            builder: (context) => Container(
              decoration: BoxDecoration(
                color: context.colors.backgroundSurface2,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
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
                    padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: isAuthorized ? Spacing.$4x : 0),
                    child: data.isLoading
                        ? Shimmer.fromColors(
                            baseColor: context.colors.backgroundSurface4,
                            highlightColor: context.colors.backgroundSurface1,
                            child: FractionallySizedBox(
                              widthFactor: 0.55,
                              alignment: AlignmentDirectional.centerStart,
                              child: Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  color: context.colors.backgroundSurface4,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          )
                        : Text(
                            text,
                            style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  MyLocationPoiActions(
                    onShare: () => _showEtaControlSheet(context, ref, closestPoint: closestPoint),
                    onCopy: () => ref.read(poiCardActionsProvider.notifier).copyToClipboard(closestPoint),
                    onParkingAdd: () => context.router.push(
                      ParkingSpotRoute(
                        address: text,
                        markerPosition: GeoPointWithElevationMessage(
                          latitude: closestPoint?.latitude ?? 0,
                          longitude: closestPoint?.longitude ?? 0,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onClose(BuildContext context, WidgetRef ref) async {
    context.router.pop();
    final read = ref.read(selectedMarkerProvider.notifier);
    await read.removeAllMarkers();
  }

  void _showEtaControlSheet(BuildContext context, WidgetRef ref, {LatLng? closestPoint}) {
    final point = closestPoint ?? this.closestPoint;
    // TODO(Ayat) Change showModalBottomSheet to screen AutoRoute
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => EtaSharingSheet(
        onCurrentLocationPressed: () {
          Navigator.pop(context);
          ref.read(poiCardActionsProvider.notifier).shareMyLocation(point);
        },
        onLiveLocationPressed: () {
          Navigator.pop(context);
          _showEtaTimeSheet(context, ref);
        },
      ),
    );
  }

  void _showEtaTimeSheet(BuildContext context, WidgetRef ref) {
    // TODO(Ayat) Change showModalBottomSheet to screen AutoRoute
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => EtaSharingTimeSheet(
        onConfirmTap: (v) {
          Navigator.pop(context);
          LoadingOverlay.of(context).startLoading();

          ref.read(shareEtaProvider.notifier).startSharingLiveLocation(v.durationInMinutes);
        },
      ),
    );
  }
}

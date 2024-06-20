import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/routing/providers/nearest_object.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/geo_point_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/dgis_handle.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/widget_size_notifier.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class RoutingMapSelect extends ConsumerStatefulWidget {
  const RoutingMapSelect({super.key});

  @override
  ConsumerState<RoutingMapSelect> createState() => _RoutingMapSelectState();
}

class _RoutingMapSelectState extends ConsumerState<RoutingMapSelect> {
  @override
  void deactivate() {
    ref.read(cameraPaddingProvider.notifier).resetPadding();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final nearestObject = ref.watch(nearestObjectProvider);
    ref.listen(
      nearestObjectProvider,
      (prev, next) {
        final prevValue = prev?.valueOrNull;
        final nextValue = next.valueOrNull;

        if (nextValue is DGisNearestObject) {
          final notEqual =
              prevValue is DGisNearestObject && prevValue.object.id?.objectId != nextValue.object.id?.objectId;
          if (prevValue == null || notEqual) {
            ref.read(cameraPositionProvider.notifier).animateTo(
                  CameraPositionMessage(
                    point: nextValue.nearestPoint.geoPoint,
                    zoom: 17,
                    tilt: 0,
                    bearing: 0,
                  ),
                );
          }
        }
      },
    );

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 12,
                        bottom: 16,
                        right: 12,
                      ),
                      child: Column(
                        children: [
                          TrafficControl(),
                          Spacer(),
                          ZoomControl(),
                          Spacer(),
                          FollowControl(
                            onlyFollowDirection: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: SvgPicture.asset(
                        'assets/icons/svg/ic_pin.svg',
                        height: 48,
                        width: 38,
                        package: PackageConfig.packageName,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WidgetSizeNotifier(
              onSizeChanged: (value) {
                final pixelSize = MediaQuery.of(context).devicePixelRatio;
                final topPadding = MediaQuery.of(context).viewPadding.top;
                final double screenHeight = MediaQuery.of(context).size.height;
                final extendSize = screenHeight - value.height;
                // TODO(Sergei): refactor this (we need additional research)
                final additionalPadding = extendSize / 2 - 80;

                ref.read(cameraPaddingProvider.notifier).setPadding(
                      CameraSetPaddingMessage(
                        leftPadding: 0,
                        topPadding: (topPadding * pixelSize).floor(),
                        rightPadding: 0,
                        bottomPadding: ((value.height + additionalPadding) * pixelSize).floor(),
                      ),
                    );
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: DgisHandle(),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.pointToMap,
                                  style: context.textStyle.heading2.copyWith(
                                    color: context.color.textAndIconsBasePrimary,
                                  ),
                                ),
                                Text(
                                  context.l10n.moveMap,
                                  style: context.textStyle.footNote.copyWith(
                                    color: context.color.textAndIconsBaseTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppCloseButton(
                            onPressed: () {
                              Metrics.logEventAdvanced(
                                MetricsConstants.routesKeys.specifyOnMapExit,
                                group: MetricsConstants.routesTag,
                                action: MetricAction.tap.toString(),
                              );

                              context.pop(null);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      _NearestObject(
                        nearestObject: nearestObject,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 8,
                        ),
                        child: LabeledElevatedButton(
                          label: context.l10n.done,
                          onPressed: () {
                            Metrics.logEventAdvanced(
                              MetricsConstants.routesKeys.specifyOnMapDone,
                              group: MetricsConstants.routesTag,
                              action: MetricAction.tap.toString(),
                            );

                            switch (nearestObject.value!) {
                              case DGisNearestObject(object: final object):
                                context.pop(
                                  RoutePointDirectoryObject(
                                    object,
                                  ),
                                );
                              case CooridnatesNearestObject(geoPoint: final geoPoint):
                                context.pop(
                                  RoutePointCoordinates(geoPoint),
                                );
                            }
                          },
                          enabled: nearestObject.unwrapPrevious().hasValue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearestObject extends StatelessWidget {
  const _NearestObject({required this.nearestObject});

  final AsyncValue<NearestObject> nearestObject;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 17,
              left: 4,
              right: 4,
            ),
            child: nearestObject.when(
              data: (_) => SvgPicture.asset(
                'assets/icons/svg/ic_routing_circle.svg',
                package: PackageConfig.packageName,
                width: 20,
                height: 20,
              ),
              error: (_, __) => SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.color.textAndIconsBasePrimary,
                ),
              ),
              loading: () => SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.color.textAndIconsBasePrimary,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: nearestObject.when(
              data: (object) => Text(
                _buildTitle(object),
                style: context.textStyle.text.copyWith(
                  color: context.color.textAndIconsBasePrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              error: (_, __) => Text(
                context.l10n.moveMap,
                style: context.textStyle.text.copyWith(
                  color: context.color.textAndIconsBasePrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              loading: () => Text(
                context.l10n.moveMap,
                style: context.textStyle.text.copyWith(
                  color: context.color.textAndIconsBasePrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
            ),
          ),
        ],
      );

  String _buildTitle(NearestObject object) => switch (object) {
        DGisNearestObject() => object.object.title,
        CooridnatesNearestObject() =>
          '${object.geoPoint.latitude.toStringAsFixed(5)}, ${object.geoPoint.longitude.toStringAsFixed(5)}'
      };
}

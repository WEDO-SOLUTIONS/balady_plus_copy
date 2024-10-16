import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart' as uikitExt;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/routing/providers/nearest_object.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/geo_point_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class RoutingMapSelect extends ConsumerStatefulWidget {
  const RoutingMapSelect({super.key});

  @override
  ConsumerState<RoutingMapSelect> createState() => _RoutingMapSelectState();
}

class _RoutingMapSelectState extends ConsumerState<RoutingMapSelect> {
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

    final additionPadding = MediaQuery.of(context).viewPadding.top * MediaQuery.of(context).devicePixelRatio;

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
                          FollowControl(),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: additionPadding,
                      ),
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
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(uikit.RadiusBorder.xl),
                ),
                color: context.colorsV2.backgroundSurface1,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    uikit.Spacing.$2x.heightBox,
                    const Center(child: SheetDragger()),
                    uikit.Spacing.$3x.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: uikit.Spacing.$4x),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.pointToMap,
                                  style: context.textStyleV3.h4SemiBold.copyWith(
                                    color: context.color.textAndIconsBasePrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.l10n.moveMap,
                                  style: context.textStyleV3.bodySmallRegular.copyWith(
                                    color: context.color.textAndIconsBaseSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          uikit.AppButton.close(onTap: _onClose),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _NearestObject(
                      nearestObject: nearestObject,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: uikit.Spacing.$4x,
                        right: uikit.Spacing.$4x,
                        top: 12,
                        bottom: 8,
                      ),
                      child: uikit.BaladyAppButton(
                        primaryLabel: context.l10n.done,
                        buttonType:
                            nearestObject.isLoading ? uikit.BaladyButtonType.secondary : uikit.BaladyButtonType.primary,
                        buttonColorScheme: nearestObject.isLoading
                            ? uikit.BaladyButtonColorScheme.neutral
                            : uikit.BaladyButtonColorScheme.accent,
                        onTap: () => _onTap(nearestObject),
                        buttonState: nearestObject.isLoading
                            ? uikit.BaladyButtonState.loading
                            : nearestObject.unwrapPrevious().hasValue
                                ? uikit.BaladyButtonState.defaultState
                                : uikit.BaladyButtonState.disabled,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(AsyncValue<NearestObject> nearestObject) {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.specifyOnMapDone,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    switch (nearestObject.value!) {
      case DGisNearestObject(nearestPoint: final nearestPoint):
        context.pop(
          // We need to pass the coordinates of the nearest point
          // because coordinates of object like street or districts are so far from the selected point
          RoutePointCoordinates(nearestPoint.geoPoint),
        );
      case CooridnatesNearestObject(geoPoint: final geoPoint):
        context.pop(
          RoutePointCoordinates(geoPoint),
        );
    }
  }

  void _onClose() {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.specifyOnMapExit,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    context.pop();
  }
}

class _NearestObject extends StatelessWidget {
  const _NearestObject({required this.nearestObject});

  final AsyncValue<NearestObject> nearestObject;

  @override
  Widget build(BuildContext context) => uikit.ContentRowV2(
        leading: const Icon(uikit.GeneralIcons.placeholder),
        text: nearestObject.when(
          data: (object) => uikit.ContentRowTextOptions(
            title: _buildTitle(object),
          ),
          error: (_, __) => uikit.ContentRowTextOptions(
            title: context.l10n.moveMap,
          ),
          loading: () => uikit.ContentRowTextOptions(
            title: context.l10n.moveMap,
          ),
        ),
      );
  // Row(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(
  //             top: 15,
  //             bottom: 17,
  //             left: 4,
  //             right: 4,
  //           ),
  //           child: nearestObject.when(
  //             data: (_) => SvgPicture.asset(
  //               'assets/icons/svg/ic_routing_circle.svg',
  //               package: PackageConfig.packageName,
  //               width: 20,
  //               height: 20,
  //             ),
  //             error: (_, __) => SizedBox(
  //               width: 20,
  //               height: 20,
  //               child: CircularProgressIndicator(
  //                 strokeWidth: 2,
  //                 color: context.color.textAndIconsBasePrimary,
  //               ),
  //             ),
  //             loading: () => SizedBox(
  //               width: 20,
  //               height: 20,
  //               child: CircularProgressIndicator(
  //                 strokeWidth: 2,
  //                 color: context.color.textAndIconsBasePrimary,
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(
  //           width: 14,
  //         ),
  //         Expanded(
  //           child: nearestObject.when(
  //             data: (object) => Text(
  //               _buildTitle(object),
  //               style: context.textStyle.text.copyWith(
  //                 color: context.color.textAndIconsBasePrimary,
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //             error: (_, __) => Text(
  //               context.l10n.moveMap,
  //               style: context.textStyle.text.copyWith(
  //                 color: context.color.textAndIconsBasePrimary,
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //             loading: () => Text(
  //               context.l10n.moveMap,
  //               style: context.textStyle.text.copyWith(
  //                 color: context.color.textAndIconsBasePrimary,
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //             skipLoadingOnRefresh: true,
  //             skipLoadingOnReload: true,
  //           ),
  //         ),
  //       ],
  //     );

  String _buildTitle(NearestObject object) => switch (object) {
        DGisNearestObject() => object.object.title,
        CooridnatesNearestObject() =>
          '${object.geoPoint.latitude.toStringAsFixed(5)}, ${object.geoPoint.longitude.toStringAsFixed(5)}'
      };
}

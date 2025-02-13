import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/routing/providers/nearest_object.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/geo_point_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:mapness/shared/ui/measure_size.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

@RoutePage()
class RoutingMapSelectPage extends ConsumerStatefulWidget {
  const RoutingMapSelectPage({super.key});

  @override
  ConsumerState<RoutingMapSelectPage> createState() => _RoutingMapSelectState();
}

class _RoutingMapSelectState extends ConsumerState<RoutingMapSelectPage> {
  @override
  Widget build(BuildContext context) {
    final nearestObject = ref.watch(nearestObjectProvider);
    final mediaQuery = ref.read(mediaQueryInfoProvider);
    final mediaQueryTop = mediaQuery?.viewPadding.top ?? 0;
    final additionPadding = mediaQueryTop * MediaQuery.of(context).devicePixelRatio;

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
                      child: SvgPicture.asset(Markers.defaultPinNew),
                    ),
                  ),
                ],
              ),
            ),
            MeasureSize(
              onChange: (size) {
                final initPadding = (size.height + mediaQueryTop + (mediaQuery?.padding.bottom ?? 0)) *
                    (mediaQuery?.devicePixelRatio ?? 1);

                ref
                    .read(cameraPaddingProvider.notifier)
                    .setPadding(CameraSetPaddingMessage(bottomPadding: initPadding.toInt()));
              },
              child: Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  uikit.Spacing.$1x.heightBox,
                                  Text(
                                    context.l10n.moveMap,
                                    style: context.textStyleV3.bodySmallRegular.copyWith(
                                      color: context.color.textAndIconsBaseSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            uikit.AppButton.close(
                              onTap: _onClose,
                            ),
                          ],
                        ),
                      ),
                      uikit.Spacing.$3x.heightBox,
                      _NearestObject(
                        nearestObject: nearestObject,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: uikit.Spacing.$4x,
                          right: uikit.Spacing.$4x,
                          top: uikit.Spacing.$3x,
                          bottom: uikit.Spacing.$2x,
                        ),
                        child: nearestObject.when(
                          loading: () => uikit.BaladyAppButton(
                            primaryLabel: context.l10n.done,
                            buttonType: uikit.BaladyButtonType.secondary,
                            buttonColorScheme: uikit.BaladyButtonColorScheme.neutral,
                            onTap: null,
                            buttonState: uikit.BaladyButtonState.loading,
                          ),
                          data: (data) => uikit.BaladyAppButton(
                            primaryLabel: context.l10n.done,
                            buttonColorScheme: uikit.BaladyButtonColorScheme.accent,
                            onTap: () => _onTap(data),
                          ),
                          error: (error, stackTrace) => uikit.BaladyAppButton(
                            primaryLabel: context.l10n.done,
                            buttonColorScheme: uikit.BaladyButtonColorScheme.accent,
                            onTap: null,
                            buttonState: uikit.BaladyButtonState.disabled,
                          ),
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

  void _onTap(NearestObject nearestObject) {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.specifyOnMapDone,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    switch (nearestObject) {
      case DGisNearestObject(nearestPoint: final nearestPoint):
        context.router.popForced(
          // We need to pass the coordinates of the nearest point
          // because coordinates of object like street or districts are so far from the selected point
          RoutePointCoordinates(nearestPoint.geoPoint, nearestObject.object.title),
        );
      case CooridnatesNearestObject(geoPoint: final geoPoint):
        context.router.popForced(
          RoutePointCoordinates(geoPoint, null),
        );
    }
  }

  void _onClose() {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.specifyOnMapExit,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    context.router.popForced();
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

  String _buildTitle(NearestObject object) => switch (object) {
        DGisNearestObject() => object.object.title,
        CooridnatesNearestObject() =>
          '${object.geoPoint.latitude.toStringAsFixed(5)}, ${object.geoPoint.longitude.toStringAsFixed(5)}'
      };
}

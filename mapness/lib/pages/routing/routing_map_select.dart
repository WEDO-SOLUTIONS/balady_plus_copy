import 'package:balady_uikit/typography/text_theme_styles.dart';
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
import 'package:mapness/shared/lib/geo_point_ext.dart';
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
    ref.read(cameraPositionProvider.notifier).setPadding(
          CameraSetPaddingMessage(
            leftPadding: 0,
            topPadding: 0,
            rightPadding: 0,
            bottomPadding: 0,
          ),
        );
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final nearestObject = ref.watch(nearestObjectProvider);
    ref.listen(
      nearestObjectProvider,
      (prev, next) {
        if (next.value != null &&
            prev?.valueOrNull?.object.id?.objectId !=
                next.valueOrNull?.object.id?.objectId) {
          ref
              .read(cameraPositionProvider.notifier)
              .animateTo(CameraPositionMessage(
                point: next.value!.nearestPoint.geoPoint,
                zoom: 17,
                tilt: 0,
                bearing: 0,
              ));
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
                          )
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

                ref.read(cameraPositionProvider.notifier).setPadding(
                      CameraSetPaddingMessage(
                        leftPadding: 0,
                        topPadding: (topPadding * pixelSize).floor(),
                        rightPadding: 0,
                        bottomPadding: (value.height * pixelSize).floor(),
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
                                  'Point to map',
                                  style: Theme.of(context)
                                      .extension<ThemeTextStyles>()!
                                      .accentL
                                      .copyWith(
                                        color: const Color(0xFF1E2A36),
                                      ),
                                ),
                                Text(
                                  'Move the map to choose a place',
                                  style: Theme.of(context)
                                      .extension<ThemeTextStyles>()!
                                      .textS
                                      .copyWith(
                                        color: const Color(0x801E2A36),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          AppCloseButton(
                            onPressed: () => context.pop(null),
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
                          label: 'Done',
                          onPressed: () {
                            context.pop(RoutePointDirectoryObject(
                              nearestObject.value!.object,
                            ));
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
              error: (_, __) => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xB21E2A36),
                ),
              ),
              loading: () => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xB21E2A36),
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
                object.object.title,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textM
                    .copyWith(
                      color: const Color(0xFF1E2A36),
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              error: (_, __) => Text(
                'Move the map to choose a place',
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textM
                    .copyWith(
                      color: const Color(0xFF1E2A36),
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              loading: () => Text(
                'Move the map to choose a place',
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textM
                    .copyWith(
                      color: const Color(0xFF1E2A36),
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
            ),
          ),
        ],
      );
}

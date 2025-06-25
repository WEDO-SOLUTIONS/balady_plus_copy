import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/routing/providers/nearest_object.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/shared/lib/geo_point_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/follow_state.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:mapness/shared/ui/safe_area_padding.dart';

@RoutePage()
class RoutingMapSelectPage extends StatefulHookConsumerWidget {
  const RoutingMapSelectPage({super.key});

  @override
  ConsumerState<RoutingMapSelectPage> createState() => _RoutingMapSelectState();
}

class _RoutingMapSelectState extends ConsumerState<RoutingMapSelectPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final follow = ref.read(followStateProvider);
      if (follow.type != LocationFollowType.off) {
        ref.read(dgisControllerProvider).valueOrNull?.stopFollowNavigation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nearestObject = ref.watch(nearestObjectProvider);
    final mediaQuery = ref.read(mediaQueryInfoProvider);
    final mediaQueryTop = mediaQuery?.viewPadding.top ?? 0;
    final additionPadding = mediaQueryTop * MediaQuery.of(context).devicePixelRatio;

    final scrollController = useStatelessBottomsheetController(onClose: (_) => _onClose(context));
    final _bottomHeightNotifier = useState(0.0);

    useEffect(() {
      void updateCameraPadding() {
        final initPadding = (scrollController.sheetHeight + mediaQueryTop + (mediaQuery?.padding.bottom ?? 0)) *
            (mediaQuery?.devicePixelRatio ?? 1);

        ref
            .read(cameraPaddingProvider.notifier)
            .setPadding(CameraSetPaddingMessage(bottomPadding: initPadding.toInt()));
      }

      scrollController.addListener(updateCameraPadding);

      return () => scrollController.removeListener(updateCameraPadding);
    }, [scrollController]);

    return SafeAreaPadding(
      child: uikit.StatelessBottomSheet(
        scrollController: scrollController,
        backgroundColor: context.colorsV3.backgroundSurface4,
        draggerColor: context.colorsV3.backgroundSurface4,
        safeAreaColor: context.colorsV3.backgroundSurface4,
        outside: Stack(
          children: [
            RoutingMapControls(bottomHeightNotifier: _bottomHeightNotifier),
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
        header: Padding(
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
                      style: context.textStyleV3.h4SemiBold,
                    ),
                    uikit.Spacing.$1x.heightBox,
                    Text(
                      context.l10n.moveMap,
                      style: context.textStyleV3.bodySmallRegular.copyWith(
                        color: context.colorsV3.foregroundSoft,
                      ),
                    ),
                  ],
                ),
              ),
              CustomCloseButton(onClose: () => _onClose(context)),
            ],
          ),
        ),
        content: [
          uikit.Spacing.$3x.heightBox,
          _NearestObject(
            nearestObject: nearestObject,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: uikit.Spacing.$4x,
              right: uikit.Spacing.$4x,
              top: uikit.Spacing.$3x,
              bottom: uikit.Spacing.$3x,
            ),
            child: AnimatedSwitcher(
              duration: Durations.medium1,
              child: nearestObject.when(
                loading: () => SizedBox(
                  key: const ValueKey(uikit.ButtonColorScheme.secondary),
                  width: double.infinity,
                  child: uikit.AppButton(
                    primaryLabel: context.l10n.done,
                    buttonColorScheme: uikit.ButtonColorScheme.secondary,
                    buttonState: uikit.ButtonState.disabled,
                    onTap: null,
                  ),
                ),
                data: (data) => SizedBox(
                  key: const ValueKey(uikit.ButtonColorScheme.primary),
                  width: double.infinity,
                  child: uikit.AppButton(
                    primaryLabel: context.l10n.done,
                    buttonColorScheme: uikit.ButtonColorScheme.primary,
                    onTap: () => _onTap(data, context),
                  ),
                ),
                error: (error, stackTrace) => SizedBox(
                  key: const ValueKey(uikit.ButtonColorScheme.secondary),
                  width: double.infinity,
                  child: uikit.AppButton(
                    primaryLabel: context.l10n.done,
                    buttonColorScheme: uikit.ButtonColorScheme.secondary,
                    buttonState: uikit.ButtonState.disabled,
                    onTap: null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(NearestObject nearestObject, BuildContext context) {
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

  void _onClose(BuildContext context) {
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
  Widget build(BuildContext context) {
    final leadingIcon = nearestObject.when(
      data: (_) => const Icon(uikit.GeneralIcons.pin),
      error: (_, __) => uikit.Loading.small(color: context.colorsV3.accentSecondaryDefault),
      loading: () => uikit.Loading.small(color: context.colorsV3.accentSecondaryDefault),
    );
    final title = nearestObject.when(
      data: (object) => _buildTitle(object),
      error: (_, __) => context.l10n.moveMap,
      loading: () => context.l10n.moveMap,
    );
    final subtitle = nearestObject.when(
      data: (object) => _buildSubtitle(object),
      error: (_, __) => null,
      loading: () => null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: uikit.Spacing.$4x),
      child: SizedBox(
        height: 68,
        child: Center(
          child: AnimatedSwitcher(
            duration: Durations.medium1,
            child: SizedBox(
              key: ValueKey(title),
              width: double.infinity,
              child: uikit.ContentRow(
                options: uikit.ContentRowOptions(
                  wrapperEnabled: true,
                  wrapperColor: context.colorsV3.backgroundSurface1,
                  leadingIcon: leadingIcon,
                  title: title,
                  subtitle: subtitle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _buildTitle(NearestObject object) => switch (object) {
        DGisNearestObject() => object.object.title,
        CooridnatesNearestObject() =>
          '${object.geoPoint.latitude.toStringAsFixed(5)}, ${object.geoPoint.longitude.toStringAsFixed(5)}'
      };
  String? _buildSubtitle(NearestObject object) =>
      switch (object) { DGisNearestObject() => object.object.subtitle, CooridnatesNearestObject() => null };
}

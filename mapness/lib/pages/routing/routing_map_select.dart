import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/routing/providers/nearest_object.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/lib/geo_point_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/follow_state.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:provider/provider.dart';
import 'package:sheetify/sheetify.dart';

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
        ref.read(dgisControllerProvider).value?.stopFollowNavigation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nearestObject = ref.watch(nearestObjectProvider);
    final mediaQuery = ref.read(mediaQueryInfoProvider);
    final mediaQueryTop = mediaQuery?.viewPadding.top ?? 0;
    final additionPadding = mediaQueryTop * MediaQuery.of(context).devicePixelRatio;

    final scrollController = useToggleSheetController(onClose: (_) => _onClose(context));

    useEffect(() {
      void updateCameraPadding() {
        final sheetHeight = scrollController.sheetHeight.isNegative ? 0 : scrollController.sheetHeight;
        final initPadding =
            (sheetHeight + mediaQueryTop + (mediaQuery?.padding.bottom ?? 0)) * (mediaQuery?.devicePixelRatio ?? 1);

        ref
            .read(cameraPaddingProvider.notifier)
            .setPadding(CameraSetPaddingMessage(bottomPadding: initPadding.toInt()));
      }

      scrollController.addListener(updateCameraPadding);

      return () => scrollController.removeListener(updateCameraPadding);
    }, [scrollController]);

    final activeEvent = ref.watch(activeCityEventProvider);
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.watch<ThemeController>().systemOverlayStyle,
      child: ToggleSheet(
        scrollController: scrollController,
        backgroundColor: context.colors.backgroundSurface4,
        safeAreaColor: context.colors.backgroundSurface4,
        dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface4),
        outside: Stack(
          children: [
            const RoutingMapControls(),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: additionPadding,
                ),
                child: SvgPicture.asset(activeEvent?.defaultPin(isDark: isDark) ?? Markers.defaultPinNew),
              ),
            ),
          ],
        ),
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.pointToMap,
                      style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                    ),
                    Spacing.$1x.heightBox,
                    Text(
                      context.l10n.moveMap,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                    ),
                  ],
                ),
              ),
              CustomCloseButton(onClose: () => _onClose(context)),
            ],
          ),
        ),
        content: [
          _NearestObject(nearestObject: nearestObject),
          Padding(
            padding: const EdgeInsets.only(
              left: Spacing.$4x,
              right: Spacing.$4x,
              top: Spacing.$3x,
              bottom: Spacing.$3x,
            ),
            child: AnimatedSwitcher(
              duration: Durations.medium1,
              child: nearestObject.when(
                loading: () => SizedBox(
                  key: const ValueKey(ButtonColorScheme.accentSecondary),
                  width: double.infinity,
                  child: AppButton(
                    primaryLabel: context.l10n.done,
                    buttonColorScheme: ButtonColorScheme.accentSecondary,
                    buttonType: ButtonType.secondary,
                    buttonState: ButtonState.loading,
                    size: ButtonSize.large,
                    onTap: null,
                  ),
                ),
                data: (data) => SizedBox(
                  key: const ValueKey(ButtonColorScheme.accent),
                  width: double.infinity,
                  child: AppButton(
                    primaryLabel: context.l10n.done,
                    buttonColorScheme: ButtonColorScheme.accentSecondary,
                    size: ButtonSize.large,
                    onTap: () => _onTap(data, context),
                  ),
                ),
                error: (error, stackTrace) => SizedBox(
                  key: const ValueKey(ButtonColorScheme.accentSecondary),
                  width: double.infinity,
                  child: AppButton(
                    primaryLabel: context.l10n.done,
                    buttonColorScheme: ButtonColorScheme.accentSecondary,
                    buttonState: ButtonState.disabled,
                    size: ButtonSize.large,
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
    switch (nearestObject) {
      case DGisNearestObject(nearestPoint: final nearestPoint):
        context.router.pop(
          // We need to pass the coordinates of the nearest point
          // because coordinates of object like street or districts are so far from the selected point
          RoutePointCoordinates(
            nearestPoint.geoPoint,
            nearestObject.object.title,
            nearestObject.object.levelId ?? nearestObject.levelId,
            objectIdParam: nearestObject.object.id?.objectId,
            entranceIdParam: nearestObject.object.id?.entranceId,
          ),
        );
      case CooridnatesNearestObject(geoPoint: final geoPoint):
        context.router.pop(RoutePointCoordinates(geoPoint, null, null));
    }
  }

  void _onClose(BuildContext context) {
    context.router.pop();
  }
}

class _NearestObject extends StatelessWidget {
  const _NearestObject({required this.nearestObject});

  final AsyncValue<NearestObject> nearestObject;

  @override
  Widget build(BuildContext context) {
    final leadingIcon = nearestObject.when(
      data: (_) => Icon(GeneralIcons.pin, color: context.colors.foregroundSoft),
      error: (_, __) => Loading.small(color: context.colors.accentSecondaryDefault),
      loading: () => Loading.small(color: context.colors.accentSecondaryDefault),
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
    return SizedBox(
      // height: 70,
      child: Center(
        child: AnimatedSwitcher(
          duration: Durations.medium1,
          child: SizedBox(
            key: ValueKey(title),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, top: Spacing.$3x),
              child: ContentRow(
                options: ContentRowOptions(
                  wrapperEnabled: true,
                  wrapperColor: context.colors.backgroundSurface1,
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
      '${object.geoPoint.latitude.toStringAsFixed(5)}, ${object.geoPoint.longitude.toStringAsFixed(5)}',
  };

  String? _buildSubtitle(NearestObject object) => switch (object) {
    DGisNearestObject() => object.object.subtitle,
    CooridnatesNearestObject() => null,
  };
}

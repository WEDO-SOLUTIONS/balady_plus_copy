import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/favourites/providers/favourite_markers.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/routing/lib/active_navigation_helper.dart';
import 'package:mapness/features/routing/providers/routes_helper.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/pages/path_nav/path_nav_page.dart';
import 'package:mapness/pages/routing/ui/routing_change_path_sheet.dart';
import 'package:mapness/pages/routing/ui/routing_info.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:provider/provider.dart' as provider;
import 'package:sheetify/sheetify.dart';
import 'package:urbi_utils/urbi_utils.dart';

@RoutePage()
class RoutingRoutesPage extends StatefulHookConsumerWidget {
  final List<RouteParamsPointWithLabel> points;
  final bool isHomeOrWork;
  final RouteSearchOptionsMessage? navType;

  const RoutingRoutesPage({required this.points, this.isHomeOrWork = false, this.navType, super.key});

  @override
  ConsumerState<RoutingRoutesPage> createState() => _RoutingRoutesPageState();
}

class _RoutingRoutesPageState extends ConsumerState<RoutingRoutesPage> {
  late List<RouteParamsPointWithLabel> points;
  DgisMapController? _dgisController;
  bool _permissionRequested = false;
  RouteSearchOptionsMessage? _navType;
  int? _activeRouteIndex;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    _navType = widget.navType;
    points = widget.points;
    _dgisController = ref.read(dgisControllerProvider).value;

    if (!_permissionRequested && widget.points.any((p) => p.value == null)) {
      _permissionRequested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(locationProvider.notifier).checkLocationPermission(routeOnClose: RoutingRoutesRoute.name);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).unfocus();
  }

  @override
  void didUpdateWidget(covariant RoutingRoutesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!const DeepCollectionEquality().equals(oldWidget.points, widget.points)) {
      _initialize();
    }
  }

  @override
  void deactivate() {
    _dgisController?.hideRoutes();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //TODO(Someone): Fix layers lifecicle
    final esri = MapObjectManagerSettings.esri();
    final mappness = MapObjectManagerSettings.mappness();
    final colors = provider.Provider.of<ThemeController>(context, listen: false).colors;
    ref
      ..watch(layersControlsProvider)
      ..watch(routesHelperProvider)
      ..watch(locationProvider.select((_) => null))
      ..watch(favouriteMarkersProvider.select((value) => null))
      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier);

    final sheetController = useToggleSheetController(isInteractive: false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.read<ThemeController>().systemOverlayStyle,
      child: ToggleSheet(
        shouldPop: (_) => false,
        backgroundColor: colors.backgroundSurface4,
        safeAreaColor: colors.backgroundSurface4,
        dragger: SheetDragger(backgroundColor: colors.backgroundSurface4),
        scrollController: sheetController,
        outside: RoutingMapControls(onAddStop: _onAddStop(context)),
        header: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ABPoints(
                      locations: _abLocations(context.l10n),
                      onTap: _changeRoute,
                      change: points.first.value == null
                          ? ABPointsChange.off
                          : points.last.value == null
                          ? ABPointsChange.on
                          : ABPointsChange.none,
                    ),
                  ),
                  // this button is always visible because the page can not be shown without start and finish points
                  AppButton(
                    primaryIcon: SystemIcons.share,
                    iconColor: colors.neutralOnContainer,
                    buttonColorScheme: ButtonColorScheme.neutral,
                    buttonType: ButtonType.secondary,
                    size: ButtonSize.large,
                    onTap: _onSharePressed,
                  ),
                  if (points.length > 2)
                    Semantics(
                    label: context.l10n.edit,
                    button: true,
                    child: ExcludeSemantics(
                      child: AppButton(
                        primaryIcon: General16Icons.edit,
                        iconColor: colors.neutralOnContainer,
                        buttonColorScheme: ButtonColorScheme.neutral,
                        buttonType: ButtonType.secondary,
                        size: ButtonSize.large,
                        onTap: _changeRoute,
                      ),
                    ),
                  )
                else
                  Semantics(
                    label: context.l10n.a11ySwapRouteEndpoints,
                    button: true,
                    child: ExcludeSemantics(
                      child: AppButton(
                        primaryIcon: TransportIcons.verticalChange,
                        buttonColorScheme: ButtonColorScheme.neutral,
                        buttonType: ButtonType.secondary,
                        size: ButtonSize.large,
                        onTap: _onSwipeRoutes,
                      ),
                    ),
                  ),
                Semantics(
                  label: context.l10n.a11yClose,
                  button: true,
                  child: ExcludeSemantics(
                    child: AppButton(
                      primaryIcon: SystemIcons.close,
                      iconColor: colors.neutralOnContainer,
                      buttonColorScheme: ButtonColorScheme.neutral,
                      buttonType: ButtonType.secondary,
                      size: ButtonSize.large,
                      onTap: _onClose,
                    ),
                  ),
                  ),
                ].insertBetween(Spacing.$3x.widthBox).toList(),
              ),
            ),
            RoutingInfo(
              pointsWithLabel: points,
              isHomeOrWork: widget.isHomeOrWork,
              navType: widget.navType,
              onNavTypeChanged: (value) {
                _navType = value;
              },
              onRouteIndexChanged: (value) {
                _activeRouteIndex = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  int get intermediatePointCount {
    final count = points.length - 2;
    return count.clamp(0, count);
  }

  Future<void> _onSharePressed() async {
    final navType = _navType;
    final activeRouteIndex = _activeRouteIndex;
    if (navType == null || activeRouteIndex == null) {
      return;
    }

    context.router.push(
      ShareRouteRoute(
        points: points,
        navType: navType,
        activeRouteIndex: activeRouteIndex,
      ),
    );
  }

  VoidCallback? _onAddStop(BuildContext context) {
    final colors = provider.Provider.of<ThemeController>(context, listen: false).colors;
    final l10n = context.l10n;
    final myLocation = ref.read(locationProvider);

    if (intermediatePointCount >= 10) {
      return null;
    }

    final icon = StopNumbersIcons.fromIndex(intermediatePointCount + 1);
    if (icon == null) {
      return null;
    }

    return () async {
      final containsMyLocation = points.map((e) => e.label).contains(l10n.myLocation);

      // Show the search route screen and get new value from it
      final value = await context.router.push(
        RoutingSearchSheetRoute(
          placeholder: l10n.intermediatePoint,
          affixIcon: BaladyInputAffixIcon(icon: icon, iconColor: colors.extra01Default),
          showMyLocation: !containsMyLocation,
        ),
      );

      if (value != null && value is RoutePoint) {
        var latitude = value.latitude;
        var longitude = value.longitude;
        if (value is RoutePointMyLocation && myLocation != null) {
          latitude = myLocation.latitude;
          longitude = myLocation.longitude;
        }
        if (longitude != null && latitude != null) {
          final newPoint = RouteParamsPointWithLabel(
            value: RouteParamsPoint(
              latitude: latitude,
              longitude: longitude,
              objectId: value.objectId,
              entranceId: value.entranceId,
              levelId: value.levelId,
            ),
            label: value.title(l10n) ?? l10n.intermediatePointNumberedName(points.length),
          );
          setState(() {
            points.insert(points.length - 1, newPoint);
          });
        }
      }
    };
  }

  List<String> _abLocations(AppLocalizations l10n) {
    if (points.length > 2) {
      return [points.first.label, l10n.stopCount(points.length - 1)];
    }

    return points.map((e) => e.label).toList();
  }

  void _onSwipeRoutes() {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.routeSelectionReverseRouteDirectionIcon,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    setState(() {
      points = points.reversed.toList();
    });
  }

  /// On tap of the ABPoints widget, show the bottom sheet to change the route
  void _changeRoute() {
    final myLocation = ref.watch(locationProvider);
    const shape = RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Spacing.$4x)));
    final colors = provider.Provider.of<ThemeController>(context, listen: false).colors;
    showModalBottomSheet(
      backgroundColor: colors.backgroundSurface4,
      shape: shape,
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.9,
      builder: (modalContext) => ChangePathSheet(
        onConfirm: _onConfirm,
        myLocation: myLocation == null
            ? null
            : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
        onTap: () {
          // Don't want to pass ref to the sheet, so we have to clear the search results here
          ref.read(searchProvider(SearchScopeEnum.routes.value).notifier).clear();
        },
        // We need to pass the points and labels as copy (List.of) to manipulate the data and
        // change original data only when user confirms
        points: List.of(points),
        onClose: () => modalContext.router.pop(),
        // We have to pass external context to the sheet to be able to get the colors, text styles, etc.
        externalContext: modalContext,
      ),
    );
  }

  /// Confirm the reordering of the points. Also close the bottom sheet
  void _onConfirm(List<RouteParamsPointWithLabel> points) {
    setState(() {
      this.points = points;
    });
    context.router.pop();
  }

  Future<void> _onClose() async {
    final mapSetting = MapObjectManagerSettings.search();
    await ref
        .read(mapObjectManagerProvider(named: mapSetting.name, layerId: mapSetting.layerId).notifier)
        .setMapObjectManagerIsVisible(isVisible: true);

    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.routeSelectionBack,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    final navState = await ActiveNavigationHelper.getState(ref.read(dgisControllerProvider).value);

    if (navState.isActive && context.mounted) {
      await context.router.pushAndPopUntil(
        PathNavRoute(navType: navState.navType!, initAction: PathNavPageInitAction.restoreFromState),
        predicate: (route) => route.settings.name == BottomMenuRoute.name,
      );
      return;
    }

    if (context.mounted) {
      context.router.pop();
    }
  }
}

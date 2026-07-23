import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' show ABRoute, ABRouteModel, Spacing;
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/favourites/providers/favourite_markers.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/landing/landing_page.dart';
import 'package:mapness/pages/routing/ui/routing_header_delegate.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:provider/provider.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class RoutingPointsPage extends StatelessWidget {
  const RoutingPointsPage({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) => const RoutingPointsSheet());
}

class RoutingPointsSheet extends ConsumerStatefulWidget {
  const RoutingPointsSheet({super.key});

  @override
  ConsumerState<RoutingPointsSheet> createState() => _RoutingPointsSheetState();
}

class _RoutingPointsSheetState extends ConsumerState<RoutingPointsSheet> {
  List<RoutePoint> points = [RoutePointMyLocation(), RoutePointDirectoryObject(null)];

  /// Subscribes to object tap events on the map
  StreamSubscription<TapEvent>? _objectTapStreamSubscription;
  MultiStateSheetController<ThreeStateSheet>? _bottomSheetController;
  VoidCallback? _removeFooterOpacityListener;
  VoidCallback? _clearBottomSheetController;

  final ValueNotifier<double> footerOpacity = ValueNotifier<double>(1.0);

  final outsideOpacityDelegate = StatefulSheetDelegateFunction<double, ThreeStateSheet>(
    function: (c) => c.fraction > 0.4 ? 1 - (c.fraction - 0.4) * 10 : 1.0,
  );

  @override
  void initState() {
    _setupTapListener();
    final bottomSheetControllerWrapper = ref.read(bottomSheetControllerProvider.notifier).state;
    final bottomSheetController = bottomSheetControllerWrapper.controller;
    _bottomSheetController = bottomSheetController;
    bottomSheetController?.addListener(updateFooterOpacity);
    _removeFooterOpacityListener = () => bottomSheetController?.removeListener(updateFooterOpacity);
    _clearBottomSheetController = () {
      if (identical(bottomSheetControllerWrapper.controller, bottomSheetController)) {
        bottomSheetControllerWrapper.controller = null;
      }
    };
    super.initState();
  }

  void updateFooterOpacity() => footerOpacity.value = min(
    1.0,
    (1 - _bottomSheetController!.fraction) * 2,
  );

  @override
  void dispose() {
    _removeFooterOpacityListener?.call();
    _clearBottomSheetController?.call();
    footerOpacity.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _objectTapStreamSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final isDGA =
        context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA ||
        context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;

    //TODO(Someone): Fix layers lifecicle
    final esri = MapObjectManagerSettings.esri();
    final mappness = MapObjectManagerSettings.mappness();

    ref
      ..watch(layersControlsProvider)
      ..watch(favouriteMarkersProvider.select((value) => null))
      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier);

    final aBRouteModels = points.mapIndexed((i, point) {
      final title =
          point.title(context.l10n) ??
          switch (i) {
            0 => context.l10n.from,
            1 => context.l10n.to,
            _ => context.l10n.to,
          };
      return ABRouteModel(title: title, isMyLocation: point is RoutePointMyLocation);
    });
    final isDarkMode = ref.watch(darkModeProvider).value?.isDark ?? false;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.read<ThemeController>().systemOverlayStyle,
      child: MultiStateSheet<ThreeStateSheet>(
        animateOpening: false,
        useSafeArea: false,
        dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface4),
        backgroundColor: context.colors.backgroundSurface4,
        outside: const RoutingMapControls(),
        outsideOpacityDelegate: outsideOpacityDelegate,
        sliver: SliverPersistentHeader(
          delegate: RoutingHeaderDelegate(onFavouritesTap: _onFavouritesTap),
          pinned: true,
          floating: true,
        ),
        header: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(bottom: Spacing.$4x),
            child: ABRoute(
              backgroundColor: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
              stopByTitle: context.l10n.addStop,
              items: aBRouteModels.toList(),
              onTap: (i) => _onTap(i, context, ref),
              onReorder: _onReorder,
            ),
          ),
        ),
        content: [
          Column(
            children: [RoutingHistory(updatePoint: _updatePoint, searchByQuery: _searchQuery)],
          ),
        ],
        keepContentBehindFooter: true,
        footer: IgnorePointer(
          child: SizedBox(
            height: Spacing.$16x + Spacing.$5x,
            width: double.infinity,
            child: FadeTransition(
              opacity: Animation.fromValueListenable(footerOpacity),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.srcOver,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDarkMode
                        ? [
                            Colors.transparent,
                            context.colors.screenOverlayDimming40,
                          ]
                        : [
                            context.colors.gradientBackgroundSurface4opacity0,
                            context.colors.gradientBackgroundSurface4opacity80,
                          ],
                  ),
                ),
              ),
            ),
          ),
        ),
        scrollController: ref.read(bottomSheetControllerProvider.notifier).state.controller!,
      ),
    );
  }

  Future<void> _onTap(int index, BuildContext context, WidgetRef ref) async {
    ref.read(searchProvider(SearchScopeEnum.routes.value).notifier).clear();

    await ref
        .read(urbiAnalyticsProvider.notifier)
        .trackWithPrint('${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.uniqueSearchInitialized}');
    final value = await context.router.push(
      RoutingSearchSheetRoute(
        placeholder: index == 0 ? context.l10n.from : context.l10n.to,
        showMyLocation: points[index] is! RoutePointMyLocation,
      ),
    );

    if (value != null && value is RoutePoint) {
      // We don't want to make route MyLocation - MyLocation and if we already have myLocation, we just
      // swap previous points
      if (points.whereType<RoutePointMyLocation>().length == 1 && value is RoutePointMyLocation) {
        points.swap(0, 1);
      } else {
        points[index] = value;
      }

      _updatePoints(points);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    var newIndex_ = newIndex;
    if (oldIndex < newIndex_) {
      newIndex_ -= 1;
    }
    points.swap(oldIndex, newIndex_);
    _updatePoints(points);
  }

  Future<void> _onFavouritesTap(FavouriteItem point) async {
    final index = points.indexWhere(
      (element) => element is RoutePointFavouriteItem || element is RoutePointDirectoryObject,
    );
    if (index.isNegative) {
      return;
    }
    points[index] = RoutePointFavouriteItem(point);
    _updatePoints(points);
  }

  void _updatePoints(List<RoutePoint> newPoints) {
    setState(() => points = newPoints);
    _showRoute();
  }

  void _updatePoint(RoutePoint point) {
    setState(() {
      if (points[0].isNotEmpty) {
        points[1] = point;
      } else {
        points[0] = point;
      }
    });
    _showRoute();
  }

  void _showRoute() {
    if (points.every((element) => element.isNotEmpty)) {
      final start = points.first;
      final finish = points.last;

      context.router.push(
        RoutingRoutesRoute(
          points: [
            RouteParamsPointWithLabel(
              value: start.latitude != null && start.longitude != null
                  ? RouteParamsPoint(
                      latitude: start.latitude!,
                      longitude: start.longitude!,
                      objectId: start.objectId,
                      entranceId: start.entranceId,
                      levelId: start.levelId,
                    )
                  : null,
              label: start.title(context.l10n) ?? '',
            ),
            RouteParamsPointWithLabel(
              value: finish.latitude != null && finish.longitude != null
                  ? RouteParamsPoint(
                      latitude: finish.latitude!,
                      longitude: finish.longitude!,
                      objectId: finish.objectId,
                      entranceId: finish.entranceId,
                      levelId: finish.levelId,
                    )
                  : null,
              label: finish.title(context.l10n) ?? '',
            ),
          ],
        ),
      );

      points = [RoutePointMyLocation(), RoutePointDirectoryObject(null)];
    }
  }

  Future<void> _searchQuery(String query) async {
    final index = points[0].isNotEmpty ? 1 : 0;
    final value = await context.router.push(
      RoutingSearchSheetRoute(
        placeholder: index == 0 ? context.l10n.from : context.l10n.to,
        showMyLocation: index == 0 && points[index] is! RoutePointMyLocation,
        initialQuery: query,
      ),
    );

    if (value != null && value is RoutePoint) {
      points[index] = value;
      _updatePoints(points);
    }
  }

  void _setupTapListener() {
    _objectTapStreamSubscription = ref.read(mapTapHandlerProvider.notifier).listen(_tapListener);
  }

  void _tapListener(event) {
    if (event is ObjectTapEvent) {
      final state = ref.read(bottomSheetControllerProvider.notifier).state.controller!.state;
      switch (state) {
        case ThreeStateSheet.open:
          break;
        case ThreeStateSheet.hidden:
        case ThreeStateSheet.expanded:
          ref.read(bottomSheetControllerProvider.notifier).state.controller?.setState(ThreeStateSheet.open);
          break;
      }
    }
  }
}

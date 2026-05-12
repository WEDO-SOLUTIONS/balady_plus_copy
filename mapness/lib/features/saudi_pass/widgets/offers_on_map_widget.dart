import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/saudi_pass/pages/offers_list_bottom_sheet_map_page.dart';
import 'package:mapness/features/saudi_pass/providers/show_map_offers_provider.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart' as lookups_body;
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/lib/geo/geo_utils.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../lifestyle_layers/configs/layers_consts.dart';

const offerPoiPinId = 'offer_poi_pin_id';

class OffersOnMapWidget extends StatefulHookConsumerWidget {
  final Set<lookups_body.Category> categories;
  final Set<lookups_body.RecommendedType> recommendedTypes;
  final lookups_body.City city;
  final bool isAll;

  const OffersOnMapWidget({
    required this.categories,
    required this.recommendedTypes,
    required this.city,
    required this.isAll,
    super.key,
  });

  @override
  ConsumerState<OffersOnMapWidget> createState() => _OffersOnMapWidgetState();
}

class _OffersOnMapWidgetState extends ConsumerState<OffersOnMapWidget> {
  final _settings = MapObjectManagerSettings.mappness();
  final _selectedMarkerSettings = MapObjectManagerSettings.selectedMarker();
  static const double _kMarkerWidth = 32.0;
  static const double _kClusterLogicalPixel = 40;
  static const double _kClusterMaxZoom = 20;
  static const double _kClusterIconSize = 32.0;
  final ValueNotifier<List<Offer>> _notifierOffers = ValueNotifier([]);
  late final ClusteringMapObjectManager _offersClustering;
  StreamSubscription<VisibleRectEvent>? _visibleRectSub;
  MapObjectManager? _selectedMarkerManager;
  BaladyAppThemes _currentTheme = BaladyAppThemes.light;
  bool _isRtl = false;
  bool _isDark = false;
  bool _isFirstLoad = true;
  int _showOffersRequestId = 0;

  @override
  void initState() {
    super.initState();
    _offersClustering = ClusteringMapObjectManager(
      options: ClusteringMapObjectManagerOptionsMessage(
        logicalPixel: _kClusterLogicalPixel,
        maxZoom: _kClusterMaxZoom,
      ),
      onTap: (cluster) => _onClusterTap(cluster),
      renderCluster: (count) => _clusterOptions(objectCount: count),
    );
    init();
  }

  Future<void> init() async {
    final controller = await ref.read(dgisControllerProvider.future);
    if (!mounted) {
      return;
    }

    _setupVisibleRectListener(controller);
  }

  MarkerTextStyleMessage _buildTextStyle({required bool isArabic, required bool isDark}) => MarkerTextStyleMessage(
    color: isDark ? 0xD3FFFFFF : 0xff1B1B1B,
    strokeColor: isDark ? 0xff1B1B1B : 0xD3FFFFFF,
    fontSize: 13,
    fontName: isArabic ? poiMapFontAr : poiMapFontEn,
    textOffset: 4,
    strokeWidth: 1,
  );

  Marker _createMarker({required Offer item}) {
    final text = item.provider.name.breakMarkerLabel(maxCharsPerLine: 20);
    final hasArabic = text.containsArabic() || _isRtl;

    final options = MarkerOptionsMessage(
      text: text,
      textStyle: _buildTextStyle(isArabic: hasArabic, isDark: _isDark),
      position: GeoPointWithElevationMessage(
        latitude: double.tryParse(item.location.latitude) ?? 0.0,
        longitude: double.tryParse(item.location.longitude) ?? 0.0,
        elevation: 0,
      ),
      isVisible: true,
      icon: SvgMarkerIcon(
        svgPath: switch (_currentTheme) {
          BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icOffers.keyName,
          _ => Assets.icons.svg.placesNew.light.icOffers.keyName,
        },
        width: _kMarkerWidth,
      ),
    );

    return Marker(id: item.id, onTap: () => _onTapMarker(item, text, options), options: options);
  }

  SimpleClusterOptionsMessage _clusterOptions({required int objectCount}) => SimpleClusterOptionsMessage(
    icon: switch (_currentTheme) {
      BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icOffersClusteringMarkerDark.keyName,
      _ => Assets.icons.svg.placesNew.light.icOffersClusteringMarker.keyName,
    }.markerIcon(size: _kClusterIconSize),
    text: objectCount.toString(),
    textStyle: MarkerTextStyleMessage(
      textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.centerCenter),
      color: Colors.white.value,
      fontSize: 13,
      fontName: _isRtl ? poiMapFontAr : poiMapFontEn,
    ),
  );

  Future<void> _onClusterTap(SimpleClusterObject simpleClusterObject) async {
    if (!mounted) {
      return;
    }

    final showMapOffers = ref.read(showMapOffersProvider.notifier);
    final clusterPosition = simpleClusterObject.position;
    final ids = simpleClusterObject.markers.map((e) => e.id ?? '').toSet();

    await showMapOffers.showMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(
          latitude: clusterPosition.latitude,
          longitude: clusterPosition.longitude,
          elevation: 0,
        ),
        icon: switch (_currentTheme) {
          BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icOffersPin.keyName,
          _ => Assets.icons.svg.placesBigNew.light.icOffersPin.keyName,
        },
        id: offerPoiPinId,
      ),
      _currentTheme,
      selectedMarkerManager: _selectedMarkerManager,
      clearSourceMarkers: false,
    );

    if (!mounted) {
      return;
    }

    final offersInState = ref.read(showMapOffersProvider);
    _setSelectedOffers(offersInState.where((o) => ids.contains(o.id)).toList());
  }

  Future<void> _onTapMarker(Offer item, String? text, MarkerOptionsMessage options) async {
    final showMapOffers = ref.read(showMapOffersProvider.notifier);
    await showMapOffers.showMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(
          latitude: double.tryParse(item.location.latitude) ?? 0,
          longitude: double.tryParse(item.location.longitude) ?? 0,
          elevation: 1,
        ),
        text: text,
        textStyle: options.textStyle,
        icon: switch (_currentTheme) {
          BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icOffersPin.keyName,
          _ => Assets.icons.svg.placesBigNew.light.icOffersPin.keyName,
        },
        id: offerPoiPinId,
      ),
      _currentTheme,
      selectedMarkerManager: _selectedMarkerManager,
    );

    _setSelectedOffers([item]);
  }

  void _setSelectedOffers(List<Offer> offers) {
    if (!mounted) {
      return;
    }

    void update() {
      if (mounted) {
        _notifierOffers.value = offers;
      }
    }

    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle || phase == SchedulerPhase.postFrameCallbacks) {
      update();
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) => update());
  }

  void _setupVisibleRectListener(DgisMapController controller) {
    _visibleRectSub = controller.visibleRectEvents.debounceTime(const Duration(seconds: 1)).listen((event) {
      if (!mounted) {
        return;
      }

      ref
          .read(showMapOffersProvider.notifier)
          .switchOffersVisibility(
            enabled: true,
            cityId: widget.city.id,
            isAll: widget.isAll,
            category: widget.categories.isEmpty ? null : widget.categories,
            promotionsType: widget.recommendedTypes.isEmpty ? null : widget.recommendedTypes,
            visibleRect: event.visibleRect,
          );
    });
  }

  @override
  void dispose() {
    _showOffersRequestId++;
    _visibleRectSub?.cancel();
    _notifierOffers.dispose();
    super.dispose();
  }

  bool _isActiveShowOffersRequest(int requestId) => mounted && requestId == _showOffersRequestId;

  Future<void> _showOffers(
    List<Offer> offers,
    CameraPosition cameraPosition,
    MapObjectManager mapObjectManager,
  ) async {
    final requestId = ++_showOffersRequestId;
    final markers = offers.map((o) => _createMarker(item: o)).toList();

    await ref.read(showMapOffersProvider.notifier).initObjectManager(mapObjectManager);
    await mapObjectManager.removeAllMarkers();
    if (!_isActiveShowOffersRequest(requestId)) {
      return;
    }

    await mapObjectManager.addMarkers(markers);
    if (!_isActiveShowOffersRequest(requestId)) {
      return;
    }

    // Only for the first load, animate to the first marker
    if (_isFirstLoad && markers.isNotEmpty) {
      _isFirstLoad = false;
      final first = markers.first.options.position;
      final gp = GeoPointMessage(latitude: first.latitude, longitude: first.longitude);
      final zoom = await GeoUtils.zoomByMarkersNearby(markers: markers, position: gp);
      if (!_isActiveShowOffersRequest(requestId)) {
        return;
      }

      await cameraPosition.animateTo(CameraPositionMessage(point: gp, zoom: zoom, tilt: 0, bearing: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final showMapOffers = ref.watch(showMapOffersProvider.notifier);
    final cameraPosition = ref.read(cameraPositionProvider.notifier);
    _currentTheme = context.read<ThemeController>().currentTheme;
    _isRtl = ref.watch(appLanguageProvider) == Language.arabic;
    _isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final mapObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: _settings.name,
        layerId: _settings.layerId,
        clustering: _offersClustering,
      ).notifier,
    );
    _selectedMarkerManager = ref.watch(
      mapObjectManagerProvider(named: _selectedMarkerSettings.name, layerId: _selectedMarkerSettings.layerId).notifier,
    );

    useEffect(() {
      // First load
      showMapOffers.switchOffersVisibility(
        enabled: true,
        cityId: widget.city.id,
        isAll: widget.isAll,
        category: widget.categories.isEmpty ? null : widget.categories,
        promotionsType: widget.recommendedTypes.isEmpty ? null : widget.recommendedTypes,
      );
      return null;
    }, [mapObjectManager]);

    ref.listen(showMapOffersProvider, (prev, next) {
      unawaited(_showOffers(next, cameraPosition, mapObjectManager));
    });

    final typesStringBar = widget.recommendedTypes.isNotEmpty
        ? ', ${widget.recommendedTypes.length} ${context.l10n.saudiPassOffersPreferencesTypesPluralZero}'
        : '';
    final categoryStringBar = widget.categories.isNotEmpty
        ? ', ${widget.categories.length} ${context.l10n.saudiPassOffersPreferencesCategoriesPluralZero}'
        : '';
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: Spacing.$2x),
          color: context.colors.backgroundSurface4,
          child: BaladyTopBar.iconAndText(
            systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
            titleWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.offers,
                  style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                ),
                const SizedBox(height: Spacing.$1x),
                Text(
                  '${widget.city.name}$typesStringBar$categoryStringBar',
                  style: context.textStyles.captionLargeRegular.copyWith(color: context.colors.foregroundSoft),
                ),
              ],
            ),
            colorEnabled: context.colors.foregroundDefault,
            leading: ActionModel(
              onPressed: () {
                context.router.pop();
              },
              icon: SystemIcons.arrowCornerLeftLarge,
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _notifierOffers,
          builder: (context, offers, _) {
            if (offers.isEmpty) {
              return const Expanded(
                child: RoutingMapControls(key: ValueKey('OffersOnMapWidgetRoutingMapControls'), useSafeArea: false),
              );
            }

            return Expanded(child: OfferListBottomSheetMapWidget(list: offers));
          },
        ),
      ],
    );
  }
}

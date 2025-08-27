import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/saudi_pass/pages/offers_list_bottom_sheet_map_page.dart';
import 'package:mapness/features/saudi_pass/providers/show_map_offers_provider.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart'
    as lookups_body;
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/simple_map_object_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/lib/geo/geo_utils.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

const offerPoiPinId = 'offer_poi_pin_id';

class OffersOnMapWidget extends StatefulHookConsumerWidget {
  final Set<lookups_body.Category> categories;
  final Set<lookups_body.RecommendedType> recommendedTypes;
  final lookups_body.City city;

  const OffersOnMapWidget({
    required this.categories,
    required this.recommendedTypes,
    required this.city,
    super.key,
  });

  @override
  ConsumerState<OffersOnMapWidget> createState() => _OffersOnMapWidgetState();
}

class _OffersOnMapWidgetState extends ConsumerState<OffersOnMapWidget> {
  final _settings = MapObjectManagerSettings.mappness();
  static const double _kMarkerWidth = 32.0;
  static const double _kClusterLogicalPixel = 40;
  static const double _kClusterMaxZoom = 20;
  static const double _kClusterFitPaddingDp = 40.0;
  static const double _kClusterIconSize = 32.0;
  final ValueNotifier<List<String>> _notifierIds = ValueNotifier([]);

  MarkerTextStyleMessage _buildTextStyle({
    required bool isArabic,
    required bool isDark,
  }) =>
      MarkerTextStyleMessage(
        color: isDark ? 0xD3FFFFFF : 0xff1B1B1B,
        strokeColor: isDark ? 0xff1B1B1B : 0xD3FFFFFF,
        fontSize: 13,
        fontName: isArabic ? poiMapFontAr : poiMapFontEn,
        textOffset: 4,
        strokeWidth: 1,
      );

  Marker _createMarker({
    required Offer item,
    required bool isRtl,
    required bool isDark,
  }) {
    final text = item.name.breakMarkerLabel(maxCharsPerLine: 20);
    final hasArabic = text.containsArabic() || isRtl;

    final options = MarkerOptionsMessage(
      text: text,
      textStyle: _buildTextStyle(isArabic: hasArabic, isDark: isDark),
      position: GeoPointWithElevationMessage(
        latitude: double.tryParse(item.location.latitude) ?? 0.0,
        longitude: double.tryParse(item.location.longitude) ?? 0.0,
        elevation: 0,
      ),
      isVisible: true,
      icon: SvgMarkerIcon(
        svgPath: isDark
            ? Assets.icons.svg.icOfferMarkerDark.keyName
            : Assets.icons.svg.icOfferMarker.keyName,
        width: _kMarkerWidth,
      ),
    );

    return Marker(
      id: item.id,
      onTap: () => _onTapMarker(item, text, options),
      options: options,
    );
  }

  SimpleClusterOptionsMessage _clusterOptions({
    required bool isRtl,
    required bool isDark,
    required int objectCount,
  }) =>
      SimpleClusterOptionsMessage(
        icon: isDark
            ? Assets.icons.svg.icOffersClusteringMarkerDark.keyName
                .markerIcon(size: _kClusterIconSize)
            : Assets.icons.svg.icOffersClusteringMarker.keyName
                .markerIcon(size: _kClusterIconSize),
        text: objectCount.toString(),
        textStyle: MarkerTextStyleMessage(
          textPlacement: MarkerTextPlacementMessage(
              placement: TextPlacementMessage.centerCenter),
          color: Colors.white.value,
          fontSize: 13,
          fontName: isRtl ? poiMapFontAr : poiMapFontEn,
        ),
      );

  Future<void> _onClusterTap(SimpleClusterObject simpleClusterObject,
      CameraPosition cameraPosition) async {
    final media = ref.read(mediaQueryInfoProvider);
    final _cameraPosition = ref.read(cameraPositionProvider);
    final dpr = media?.devicePixelRatio ?? 1.0;
    final padding = (_kClusterFitPaddingDp * dpr).ceil();

    if (_cameraPosition?.zoom == null || (_cameraPosition?.zoom ?? 0) > 16) {
      final showMapOffers = ref.read(showMapOffersProvider.notifier);
      await showMapOffers.showMarker(
        Markers.pinMarker(
          GeoPointWithElevationMessage(
            latitude: simpleClusterObject.position.latitude,
            longitude: simpleClusterObject.position.longitude,
            elevation: 0,
          ),
          icon: Assets.icons.svg.icOffersPin.keyName,
          id: offerPoiPinId,
        ),
      );

      final ids = simpleClusterObject.markers.map((e) => e.id ?? '').toList();
      _notifierIds.value = ids;
    } else {
      await cameraPosition.animateToMarkers(
        simpleClusterObject.markers.toMarkers(),
        options: CalcPositionOptionsMessage(
          screenArea: CameraSetPaddingMessage(
            leftPadding: padding * 2,
            topPadding: padding,
            rightPadding: padding * 2,
            bottomPadding: padding,
          ),
        ),
      );
    }
  }

  Future<void> _onTapMarker(
      Offer item, String? text, MarkerOptionsMessage options) async {
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
        icon: Assets.icons.svg.icOffersPin.keyName,
        id: offerPoiPinId,
      ),
    );

    _notifierIds.value = [item.id];
  }

  @override
  void dispose() {
    _notifierIds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showMapOffers = ref.watch(showMapOffersProvider.notifier);
    final cameraPosition = ref.read(cameraPositionProvider.notifier);

    useEffect(() {
      showMapOffers.switchOffersVisibility(
        enabled: true,
        cityId: widget.city.id,
        category: widget.categories.isEmpty ? null : widget.categories,
        promotionsType:
            widget.recommendedTypes.isEmpty ? null : widget.recommendedTypes,
      );

      return () => showMapOffers.switchOffersVisibility(
            enabled: false,
            cityId: widget.city.id,
          );
    });

    ref.listen(showMapOffersProvider, (prev, next) async {
      final isRtl = ref.watch(appLanguageProvider) == Language.arabic;
      final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;

      final mapObjectManager = ref.watch(
        mapObjectManagerProvider(
          named: _settings.name,
          layerId: _settings.layerId,
          clustering: ClusteringMapObjectManager(
            options: ClusteringMapObjectManagerOptionsMessage(
              logicalPixel: _kClusterLogicalPixel,
              maxZoom: _kClusterMaxZoom,
            ),
            onTap: (cluster) => _onClusterTap(cluster, cameraPosition),
            renderCluster: (count) => _clusterOptions(
                isRtl: isRtl, isDark: isDark, objectCount: count),
          ),
        ).notifier,
      );

      final markers = next
          .map((o) => _createMarker(item: o, isRtl: isRtl, isDark: isDark))
          .toList();

      await mapObjectManager.removeAllMarkers();
      await mapObjectManager.addMarkers(markers);

      final userPos = ref.read(locationProvider);
      if (userPos == null) {
        return;
      }

      final gp = GeoPointMessage(
          latitude: userPos.latitude, longitude: userPos.longitude);
      final zoom =
          await GeoUtils.zoomByMarkersNearby(markers: markers, position: gp);

      await cameraPosition.animateTo(
          CameraPositionMessage(point: gp, zoom: zoom, tilt: 0, bearing: 0));

      await showMapOffers.initObjectManager(mapObjectManager);
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
          height: 130,
          color: context.colors.backgroundSurface4,
          child: Stack(
            children: [
              BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: context.l10n.offers,
                textStyle: context.textStyles.bodyLargeSemiBold
                    .copyWith(color: context.colors.foregroundDefault),
                colorEnabled: context.colors.foregroundDefault,
                leading: ActionModel(
                  onPressed: () {
                    context.router.popForced();
                    showMapOffers.removeMarker(offerPoiPinId);
                  },
                  icon: SystemIcons.arrowCornerLeftLarge,
                ),
              ),
              Positioned.fill(
                top: 90,
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        '${widget.city.name}$typesStringBar$categoryStringBar',
                        style: context.textStyles.captionLargeRegular.copyWith(color: context.colors.foregroundSoft),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _notifierIds,
          builder: (context, val, _) {
            if (val.isEmpty) {
              return const Expanded(
                child: RoutingMapControls(
                  key: ValueKey('OffersOnMapWidgetRoutingMapControls'),
                  useSafeArea: false,
                ),
              );
            }

            return Expanded(
              child: OfferListBottomSheetMapWidget(offersId: val),
            );
          },
        ),
      ],
    );
  }
}

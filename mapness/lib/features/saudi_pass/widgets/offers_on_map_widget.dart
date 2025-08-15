import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/saudi_pass/providers/show_map_offers_provider.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart' as lookups_body;
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

class OffersOnMapWidget extends StatefulHookConsumerWidget {
  final Set<lookups_body.Category> categories;
  final Set<lookups_body.RecommendedType> recommendedTypes;

  const OffersOnMapWidget({
    required this.categories,
    required this.recommendedTypes,
    super.key,
  });

  @override
  ConsumerState<OffersOnMapWidget> createState() => _OffersOnMapWidgetState();
}

class _OffersOnMapWidgetState extends ConsumerState<OffersOnMapWidget> {
  static const double _kMarkerWidth = 32.0;
  static const double _kClusterLogicalPixel = 70;
  static const double _kClusterMaxZoom = 20;
  static const double _kClusterFitPaddingDp = 40.0;
  static const double _kClusterIconSize = 32.0;
  late final StatelessBottomSheetController _bottomsheetController;

  @override
  void initState() {
    super.initState();
    _bottomsheetController = StatelessBottomSheetController(
      onClose: (controller) => context.router.popForced(),
    );
  }

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

    return Marker(
      id: item.id,
      onTap: () => context.router.push(OfferRoute(offerId: item.id)),
      options: MarkerOptionsMessage(
        text: text,
        textStyle: _buildTextStyle(isArabic: hasArabic, isDark: isDark),
        position: GeoPointWithElevationMessage(
          latitude: double.tryParse(item.location.latitude) ?? 0.0,
          longitude: double.tryParse(item.location.longitude) ?? 0.0,
          elevation: 0,
        ),
        isVisible: true,
        icon: SvgMarkerIcon(
          svgPath: isDark ? Assets.icons.svg.icOfferMarkerDark.keyName : Assets.icons.svg.icOfferMarker.keyName,
          width: _kMarkerWidth,
        ),
      ),
    );
  }

  SimpleClusterOptionsMessage _clusterOptions({
    required bool isRtl,
    required bool isDark,
    required int objectCount,
  }) =>
      SimpleClusterOptionsMessage(
        icon: isDark ? Assets.icons.svg.icOffersClusteringMarkerDark.keyName.markerIcon(size: _kClusterIconSize) : Assets.icons.svg.icOffersClusteringMarker.keyName.markerIcon(size: _kClusterIconSize),
        text: objectCount.toString(),
        textStyle: MarkerTextStyleMessage(
          textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.centerCenter),
          color: Colors.white.value,
          fontSize: 13,
          fontName: isRtl ? poiMapFontAr : poiMapFontEn,
        ),
      );

  Future<void> _onClusterTap(
      SimpleClusterObject simpleClusterObject,
      CameraPosition cameraPosition,
      ) async {
    final media = ref.read(mediaQueryInfoProvider);
    final dpr = media?.devicePixelRatio ?? 1.0;
    final padding = (_kClusterFitPaddingDp * dpr).ceil();

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

  @override
  Widget build(BuildContext context) {
    final settings = MapObjectManagerSettings.mappness();
    final showMapOffers = ref.watch(showMapOffersProvider.notifier);
    final cameraPosition = ref.read(cameraPositionProvider.notifier);

    useEffect(() {
      showMapOffers.switchOffersVisibility(
        enabled: true,
        category: widget.categories.isEmpty ? null : widget.categories,
        promotionsType: widget.recommendedTypes.isEmpty ? null : widget.recommendedTypes,
      );

      return () => showMapOffers.switchOffersVisibility(enabled: false);
    });

    ref.listen(showMapOffersProvider, (prev, next) async {
      final isRtl = ref.read(appLanguageProvider) == Language.arabic;
      final isDark = ref.read(darkModeProvider).value?.isDark ?? false;

      final objectManager = ref.watch(
        mapObjectManagerProvider(
          named: settings.name,
          layerId: settings.layerId,
          clustering: ClusteringMapObjectManager(
            options: ClusteringMapObjectManagerOptionsMessage(
              logicalPixel: _kClusterLogicalPixel,
              maxZoom: _kClusterMaxZoom,
            ),
            onTap: (cluster) => _onClusterTap(cluster, cameraPosition),
            renderCluster: (count) => _clusterOptions(isRtl: isRtl, isDark: isDark, objectCount: count),
          ),
        ).notifier,
      );

      final markers = next.map((o) => _createMarker(item: o, isRtl: isRtl, isDark: isDark)).toList();

      await objectManager.removeAllMarkers();
      await objectManager.addMarkers(markers);

      final userPos = ref.read(locationProvider);
      if (userPos == null) {
        return;
      }

      final gp = GeoPointMessage(latitude: userPos.latitude, longitude: userPos.longitude);
      final zoom = await GeoUtils.zoomByMarkersNearby(markers: markers, position: gp);

      await cameraPosition.animateTo(CameraPositionMessage(point: gp, zoom: zoom, tilt: 0, bearing: 0));
    });

    return StatelessBottomSheet(
      scrollController: _bottomsheetController,
      outside: const RoutingMapControls(key: ValueKey('OffersOnMapWidgetRoutingMapControls')),
      content: [
        ContentRow(
          text: ContentRowTextOptions(
            titleOptions: ContentRowTextOption(
              builder: (context) => Center(
                child: Text(
                  context.l10n.allOffers,
                  style: context.textStyles.h3Medium.copyWith(
                    color: context.colors.foregroundDefault,
                  ),
                ),
              ),
            ),
          ),
          trailing: ContentRowCustomTrailingOptions(
            builder: (context) => IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.router.popForced(),
            ),
          ),
        ),
      ],
    );
  }
}
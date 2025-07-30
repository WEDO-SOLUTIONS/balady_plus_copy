import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/providers/show_map_offers_provider.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart' as lookups_body;
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/lib/geo/geo_utils.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';

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
  static double markersWidth = 32.0;
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

  Marker _createMarker(Offer item, bool isRtl, bool isDark) {
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
          svgPath: Assets.icons.svg.icPinNew.keyName,
          width: markersWidth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _settings = MapObjectManagerSettings.mappness();

    final showMapOffers = ref.watch(showMapOffersProvider.notifier);

    useEffect(() {
      showMapOffers.switchOffersVisibility(
        enabled: true,
        category: widget.categories.isEmpty ? null : widget.categories,
        promotionsType: widget.recommendedTypes.isEmpty ? null : widget.recommendedTypes,
      );

      return () => showMapOffers.switchOffersVisibility(enabled: false);
    });

    ref.listen(showMapOffersProvider, (prev, next) {
      final objectManager = ref.read(
        mapObjectManagerProvider(
          named: _settings.name,
          layerId: _settings.layerId,
        ).notifier,
      );

      final isDarkMode = ref.read(darkModeProvider).value?.isDark ?? false;
      final isRtl = ref.read(appLanguageProvider) == Language.arabic;
      final markers = next.map((item) => _createMarker(item, isRtl, isDarkMode)).toList();

      objectManager
        ..removeAllMarkers()
        ..addMarkers(markers);

      final position = ref.read(locationProvider);

      if (position == null) {
        return;
      }

      final point = GeoPointMessage(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      GeoUtils.zoomByMarkersNearby(markers: markers, position: point).then((zoom) async {
        final cameraPosition = ref.read(cameraPositionProvider.notifier);

        await cameraPosition.animateTo(
          CameraPositionMessage(
            point: point,
            zoom: zoom,
            tilt: 0,
            bearing: 0,
          ),
        );
      });
    });

    return StatelessBottomSheet(
      scrollController: _bottomsheetController,
      outside: const RoutingMapControls(
        key: ValueKey('OffersOnMapWidgetRoutingMapControls'),
      ),
      content: [
        ContentRowV2(
          text: ContentRowTextOptions(
            titleOptions: ContentRowTextOption(
              builder: (context) => Center(
                child: Text(
                  context.l10n.allOffers,
                  style: context.textStyleV3.h3Medium.copyWith(
                    color: context.colorsV3.foregroundDefault,
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

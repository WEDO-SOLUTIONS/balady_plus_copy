import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/hajj/poi_marker_rcmc.dart';
import 'package:mapness/features/hajj/hajj_rcmc_provider.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

const hajjPoiPinId = 'hajj_poi_pin_id';

class HajjWrapperListeners extends ConsumerStatefulWidget {
  final Widget child;

  const HajjWrapperListeners({
    required this.child,
    super.key,
  });

  @override
  HajjWrapperListenersState createState() => HajjWrapperListenersState();
}

class HajjWrapperListenersState extends ConsumerState<HajjWrapperListeners> {
  final _settings = MapObjectManagerSettings.hajj();
  final _sizeMarkersHajj = 24.0;
  final _fontSizePin = 13.0;
  final _fontSizeMarker = 11.0;
  final _maxCharsPerLine = 20;
  bool? _previousIsDarkMode;

  @override
  Widget build(BuildContext context) {
    final objectManager = ref.watch(
      mapObjectManagerProvider(
        named: _settings.name,
        layerId: _settings.layerId,
      ).notifier,
    );

    ref
      ..listen(hajjRcmcProvider, (prevState, newState) async {
        final isDarkMode = ref.read(darkModeProvider).value?.isDark ?? false;

        final hasVisualChange = _previousIsDarkMode != isDarkMode;
        _previousIsDarkMode = isDarkMode;

        final dataChanged = prevState?.value != newState.value;

        if (!dataChanged && !hasVisualChange) {
          return;
        }

        final isRtl = ref.read(appLanguageProvider) == Language.arabic;
        final markers = (newState.value ?? []).map((item) => _createMarker(item, isRtl, isDarkMode)).toList();

        await objectManager.removeAllMarkers();
        await objectManager.addMarkers(markers);
      })
      ..listen(darkModeProvider, (prevState, newState) {
        ref.invalidate(hajjRcmcProvider);
      });

    return widget.child;
  }

  Marker _createMarker(PoiMarkerRcmc item, bool isRtl, bool isDark) {
    final text = item.title.breakMarkerLabel(maxCharsPerLine: 20);

    final hasArabic = text.containsArabic() || isRtl;

    return Marker(
      id: item.id,
      onTap: () => _onMarkerTap(item, isRtl, isDark),
      options: MarkerOptionsMessage(
        text: text,
        textStyle: _buildTextStyle(isArabic: hasArabic, isPin: false, isDark: isDark),
        position: GeoPointWithElevationMessage(
          latitude: item.latitude,
          longitude: item.longitude,
          elevation: 0,
        ),
        isVisible: true,
        icon: item.categoryId.categoryFromId()?.iconPath.markerIcon(size: _sizeMarkersHajj),
      ),
    );
  }

  Future<void> _onMarkerTap(PoiMarkerRcmc item, bool isRtl, bool isDark) async {
    final text = item.title.breakMarkerLabel(maxCharsPerLine: _maxCharsPerLine);
    final hasArabic = text.containsArabic() || isRtl;

    final selectedMarker = ref.read(selectedMarkerProvider.notifier);

    await selectedMarker.showMarker(
      Markers.pinMarker(
          GeoPointWithElevationMessage(
            latitude: item.latitude,
            longitude: item.longitude,
            elevation: 1,
          ),
          text: text,
          textStyle: _buildTextStyle(isArabic: hasArabic, isPin: true, isDark: isDark),
          icon: Markers.defaultPinNew,
          id: hajjPoiPinId,
          maxCharsPerLine: _maxCharsPerLine),
      settings: _settings,
    );

    await context.router.replaceOrPush(
      route: HajjPoiCardRoute(poiMarkerRcmc: item),
      toCompareRoutes: [
        PoiCardWidgetRoute.page,
        HajjPoiCardRoute.page,
      ],
    );
  }

  MarkerTextStyleMessage _buildTextStyle({
    required bool isArabic,
    required bool isPin,
    required bool isDark,
  }) {
    final colorPin = isDark ? 0xD3FFFFFF : 0xff1B1B1B;
    final strokeColorPin = isDark ? 0xff1B1B1B : 0xD3FFFFFF;
    final strokeColorMarker = isDark ? 0xFF1B1B1B : 0xFFFFFFFF;

    return MarkerTextStyleMessage(
      color: isPin ? colorPin : context.colorsV3.accentDefault.value,
      strokeColor: isPin ? strokeColorPin : strokeColorMarker,
      fontSize: isPin ? _fontSizePin : _fontSizeMarker,
      fontName: isArabic ? poiMapFontAr : poiMapFontEn,
      textOffset: 4,
      strokeWidth: 1,
    );
  }
}

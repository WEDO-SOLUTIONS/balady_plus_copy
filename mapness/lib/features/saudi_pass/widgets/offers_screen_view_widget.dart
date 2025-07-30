import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/saudi_pass/providers/show_map_offers_provider.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_view_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/prefs_content_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_scaffold.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

class OffersScreenViewWidget extends ConsumerStatefulWidget {
  final OffersScreenView offersScreenView;

  const OffersScreenViewWidget(this.offersScreenView, {super.key});

  @override
  OffersScreenViewWidgetState createState() => OffersScreenViewWidgetState();
}

class OffersScreenViewWidgetState extends ConsumerState<OffersScreenViewWidget> {
  final _settings = MapObjectManagerSettings.mappness();

  int get _filtersIndex => widget.offersScreenView.isByPreferencesElseAll ? 0 : 1;
  bool _hasChangeFavorites = false;

  @override
  Widget build(BuildContext context) {
    final showMapOffers = ref.read(showMapOffersProvider.notifier);

    ref.listen(showMapOffersProvider, (prev, next) {
      final objectManager = ref.watch(
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
    });

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$4x),
      child: SaudiPassScaffold(
        onBackButton: () => context.router.popForced(_hasChangeFavorites),
        title: context.l10n.saudiPassOffersPageTitle,
        body: ListenableBuilder(
          listenable: widget.offersScreenView,
          builder: (context, _) => Column(
            children: [
              ContentRow(
                onToggle: (_) => showMapOffers.fetchOffers(),
                options: ContentRowOptions(
                  actionWidget: ContentRowActionOptions(
                    toggleInitialValue: showMapOffers.toggleShowMap,
                    enabledToggle: true,
                  ),
                  title: context.l10n.showFavoritesOnMap,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
                child: SegmentTabsButton(
                  initialIndex: _filtersIndex,
                  tabsContent: [
                    TabsRowV2Content(
                      title: context.l10n.saudiPassOffersPageByPreferences,
                      onTap: widget.offersScreenView.tapByPreferences,
                    ),
                    TabsRowV2Content(
                      title: context.l10n.saudiPassOffersPageAll,
                      onTap: widget.offersScreenView.tapAll,
                    ),
                  ],
                  onIndexChanged: (index) {},
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _filtersIndex,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                      child: PrefsContentWidget(widget.offersScreenView),
                    ),
                    OffersViewWidget(
                      widget.offersScreenView,
                      onChangeOffers: () => _hasChangeFavorites = true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Marker _createMarker(Offer item, bool isRtl, bool isDark) {
    final text = item.name.breakMarkerLabel(maxCharsPerLine: 20);
    final hasArabic = text.containsArabic() || isRtl;

    return Marker(
      id: item.id,
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
          width: Markers.defaultWidth,
        ),
      ),
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
}

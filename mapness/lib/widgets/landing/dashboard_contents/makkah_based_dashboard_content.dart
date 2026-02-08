import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/landing/dashboard/dashboard_actions.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';
import 'package:mapness/widgets/landing/dashboard_offers_row.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/landing/kaaba_virtual_journey_card.dart';
import 'package:mapness/widgets/landing/place_preview_makkah.dart';
import 'package:mapness/widgets/landing/quick_action_button.dart';
import 'package:mapness/widgets/stories/lib/stories_widget.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

/// Unified dashboard content for Makkah-based themes (mekkahBase and ramadan).
///
/// These themes share the same layout and functionality, differing only in
/// visual assets (quick action icons, background images).
class MakkahBasedDashboardContent extends ConsumerWidget {
  const MakkahBasedDashboardContent({
    required this.themeMode,
    required this.themeConfig,
    super.key,
  });

  final SpecialThemeMode themeMode;
  final DashboardThemeConfig themeConfig;

  /// Returns the asset path prefix for quick action icons based on theme mode.
  String get _quickActionAssetPrefix {
    return themeMode == SpecialThemeMode.ramadan
        ? 'assets/images/ramadan_quick_actions'
        : 'assets/images/makkah_quick_actions';
  }

  String _getAssetPath(String fileName) => '$_quickActionAssetPrefix/$fileName';

  /// Checks if the Kaaba virtual journey card should be shown.
  /// All conditions (enabled, location, date) are already handled by showPilgrimFeatureProvider.
  bool _shouldShowKaabaCard(FeatureConfig? pilgrimFeature) {
    return pilgrimFeature != null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = DashboardActions(ref);
    final pilgrimFeature = ref.watch(showPilgrimFeatureProvider);
    final showKaabaCard = _shouldShowKaabaCard(pilgrimFeature);

    return Column(
      children: [
        const SizedBox(height: Spacing.$3x),
        StoriesWidget(
          titleWidget: Padding(
            padding: const EdgeInsets.only(bottom: Spacing.$3x),
            child: DashboardTitle(
              themeMode == SpecialThemeMode.ramadan
                  ? context.l10n.whatIsNewInRamadan
                  : context.l10n.whatIsNewInBalady,
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (showKaabaCard) ...[
          KaabaVirtualJourneyCard(
            onTap: () {
              Metrics.logEventAdvanced(
                MetricsConstants.kaabaTourKeys.cardTapped,
                group: MetricsConstants.kaabaTourTag,
                action: MetricAction.tap.name,
                props: {'theme': themeMode.name},
              );
              context.router.push(const GaussianSplattingRoute());
            },
          ),
          const SizedBox(height: Spacing.$4x),
        ],
        DashboardTitle(context.l10n.quickActions),
        const SizedBox(height: Spacing.$4x),
        ScrollConfiguration(
          behavior: NoGlowingScrollBehavior(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.$4x,
              vertical: Spacing.$0_5x,
            ),
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuickActionButton(
                  text: context.l10n.roadEvent,
                  icon: General32Icons.eventsFilled,
                  assetPath: _getAssetPath('road_event.png'),
                  themeMode: themeMode,
                  onTap: actions.openRoadEvent,
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.sendLocation,
                  icon: General32Icons.locationAction,
                  assetPath: _getAssetPath('send_location.png'),
                  themeMode: themeMode,
                  onTap: () => actions.openMyLocation(context),
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.freeRoam,
                  icon: TransportIcons.locationDirectionNavigator,
                  assetPath: _getAssetPath('free_roam.png'),
                  themeMode: themeMode,
                  onTap: () => actions.openFreeRoam(context),
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.parkingAction,
                  icon: General32Icons.parkingAction,
                  assetPath: _getAssetPath('parking.png'),
                  themeMode: themeMode,
                  onTap: actions.openParking,
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.snapAndSendAction,
                  icon: General32Icons.snapAndSendAction,
                  assetPath: _getAssetPath('snap_and_send.png'),
                  themeMode: themeMode,
                  onTap: actions.openSnapAndSend,
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.qibla,
                  icon: General32Icons.qiblaAction,
                  assetPath: _getAssetPath('qibla.png'),
                  themeMode: themeMode,
                  onTap: () => actions.openQibla(context),
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.quaranAction,
                  icon: General32Icons.quaranAction,
                  assetPath: _getAssetPath('quaran.png'),
                  themeMode: themeMode,
                  onTap: actions.openQuran,
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.athkarAction,
                  icon: General32Icons.athkarAction,
                  assetPath: _getAssetPath('athkar.png'),
                  themeMode: themeMode,
                  onTap: actions.openAthkar,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.$4x),
        const SizedBox(height: Spacing.$6x),
        const DashboardOffersRow(),
        const SizedBox(height: Spacing.$6x),
        if (!themeConfig.useThemedExploreBackground) ...[
          DashboardTitle(context.l10n.exploreNearby),
          const SizedBox(height: Spacing.$4x),
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/places_makkah.png'),
                matchTextDirection: true,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [PlacePreviewMakkah(), SizedBox(height: Spacing.$6x)],
            ),
          ),
        ],
        if (themeConfig.useThemedExploreBackground)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: themeConfig.exploreBackgroundGradient,
              ),
              image:
                  themeConfig.exploreBackgroundImageBuilder != null
                      ? DecorationImage(
                        image: themeConfig.exploreBackgroundImageBuilder!(),
                        matchTextDirection: true,
                        fit: BoxFit.cover,
                        alignment: AlignmentDirectional.centerEnd,
                      )
                      : null,
            ),
            child: Column(
              children: [
                DashboardTitle(context.l10n.exploreNearby),
                const SizedBox(height: Spacing.$4x),
                const PlacePreviewMakkah(),
                const SizedBox(height: Spacing.$6x),
              ],
            ),
          ),
      ],
    );
  }
}

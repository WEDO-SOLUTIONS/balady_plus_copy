import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/makkah_poi_constants.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/explore_card.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/landing/dashboard/dashboard_actions.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/landing/kaaba_virtual_journey_card.dart';
import 'package:mapness/widgets/landing/place_preview_makkah.dart';
import 'package:mapness/widgets/landing/quick_action_button.dart';
import 'package:mapness/widgets/stories/lib/stories_widget.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:sheetify/sheetify.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';

/// Unified dashboard content for Makkah-based themes (mekkahBase and ramadan).
///
/// These themes share the same layout and functionality, differing only in
/// visual assets (quick action icons, background images).
class MakkahBasedDashboardContent extends ConsumerWidget {
  const MakkahBasedDashboardContent({
    required this.themeMode,
    required this.themeConfig,
    required this.bottomSheetController,
    super.key,
  });

  final SpecialThemeMode themeMode;
  final DashboardThemeConfig themeConfig;
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  /// Returns the asset path prefix for quick action icons based on theme mode + dark.
  String _quickActionAssetPrefix({required bool isDark}) {
    if (themeMode == SpecialThemeMode.ramadan) {
      return 'assets/images/ramadan_quick_actions';
    }
    return isDark ? 'assets/images/makkah_quick_actions/dark' : 'assets/images/makkah_quick_actions';
  }

  String _getAssetPath(String fileName, {required bool isDark}) =>
      '${_quickActionAssetPrefix(isDark: isDark)}/$fileName';

  /// Checks if the Kaaba virtual journey card should be shown.
  /// All conditions (enabled, location, date) are already handled by showPilgrimFeatureProvider.
  bool _shouldShowKaabaCard(FeatureConfig? pilgrimFeature) {
    return pilgrimFeature != null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = DashboardActions(ref, bottomSheetController: bottomSheetController);
    final pilgrimFeature = ref.watch(showPilgrimFeatureProvider);
    final showKaabaCard = _shouldShowKaabaCard(pilgrimFeature);
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;

    final overlayPeak = isDark
        ? MakkahPoiConstants.darkPreviewCardOverlayColor
        : MakkahPoiConstants.previewCardOverlayColor;

    return Column(
      children: [
        // The "What's new" title is the sheet header, see `Dashboard._buildHeader`.
        const StoriesWidget(),
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
                  assetPath: _getAssetPath('road_event.png', isDark: isDark),
                  themeMode: themeMode,
                  onTap: actions.openRoadEvent,
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.sendLocation,
                  icon: General32Icons.locationAction,
                  assetPath: _getAssetPath('send_location.png', isDark: isDark),
                  themeMode: themeMode,
                  onTap: () => actions.openMyLocation(context),
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.freeRoam,
                  icon: TransportIcons.locationDirectionNavigator,
                  assetPath: _getAssetPath('free_roam.png', isDark: isDark),
                  themeMode: themeMode,
                  onTap: () => actions.openFreeRoam(context),
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.parkingAction,
                  icon: General32Icons.parkingAction,
                  assetPath: _getAssetPath('parking.png', isDark: isDark),
                  themeMode: themeMode,
                  onTap: actions.openParking,
                ),
                const SizedBox(width: Spacing.$2x),
                Consumer(
                  builder: (context, ref, child) {
                    final streamAudio = ref.watch(streamAudioProvider);
                    final isLoading = streamAudio.isLoadingChannels;
                    final hasChannels = streamAudio.hasChannels;

                    return QuickActionButton(
                      text: Directionality.of(context) == TextDirection.rtl ? 'البث الصوتي' : 'Stream Audio',
                      icon: Icons.wifi,
                      child: isLoading
                          ? SizedBox(
                              height: Spacing.$6x + Spacing.$1x,
                              width: Spacing.$6x + Spacing.$1x,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.colors.accentDefault,
                                ),
                              ),
                            )
                          : SvgPicture.asset(
                              Assets.icons.svg.audio.audioStream.keyName,
                              height: Spacing.$6x + Spacing.$1x,
                              colorFilter: ColorFilter.mode(
                                context.colors.accentDefault,
                                BlendMode.srcIn,
                              ),
                            ),
                      onTap: () async {
                        final provider = ref.read(streamAudioProvider.notifier);

                        try {
                          // Reset if needed before getting live programs
                          if (provider.needsReinitialization) {
                            await provider.reset();
                          }

                          // Always try to get channels (this will show loading state)
                          await provider.getChannels(forceRefresh: !hasChannels);

                          if (provider.filteredChannels.isNotEmpty) {
                            await provider.selectChannel(provider.filteredChannels.first);
                          } else {
                            // Show message if no channels available
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    Directionality.of(context) == TextDirection.rtl
                                        ? 'لا توجد قنوات متاحة حالياً. اضغط مرة أخرى للمحاولة.'
                                        : 'No channels available right now. Tap again to retry.',
                                  ),
                                  action: SnackBarAction(
                                    label: Directionality.of(context) == TextDirection.rtl ? 'إعادة المحاولة' : 'Retry',
                                    onPressed: () async {
                                      await provider.getChannels(forceRefresh: true);
                                    },
                                  ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          debugPrint('Dashboard: Error loading channels: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  Directionality.of(context) == TextDirection.rtl
                                      ? 'خطأ في تحميل القنوات. اضغط مرة أخرى للمحاولة.'
                                      : 'Error loading channels. Tap again to retry.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.snapAndSendAction,
                  icon: General32Icons.snapAndSendAction,
                  assetPath: _getAssetPath('snap_and_send.png', isDark: isDark),
                  themeMode: themeMode,
                  onTap: actions.openSnapAndSend,
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.qibla,
                  icon: General32Icons.qiblaAction,
                  assetPath: _getAssetPath('qibla.png', isDark: isDark),
                  themeMode: themeMode,
                  onTap: () => actions.openQibla(context),
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.quaranAction,
                  icon: General32Icons.quaranAction,
                  assetPath: _getAssetPath('quaran.png', isDark: isDark),
                  themeMode: themeMode,
                  onTap: actions.openQuran,
                ),
                const SizedBox(width: Spacing.$2x),
                QuickActionButton(
                  text: context.l10n.athkarAction,
                  icon: General32Icons.athkarAction,
                  assetPath: _getAssetPath('athkar.png', isDark: isDark),
                  themeMode: themeMode,
                  onTap: actions.openAthkar,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.$4x),
        const SizedBox(height: Spacing.$6x),
        if (!themeConfig.useThemedExploreBackground) ...[
          DashboardTitle(context.l10n.exploreNearby),
          const SizedBox(height: Spacing.$4x),
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/places_makkah.webp'),
                matchTextDirection: true,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlacePreviewMakkah(),
                SizedBox(height: Spacing.$4x),
                ExploreCard(),
                SizedBox(height: Spacing.$10x),
              ],
            ),
          ),
        ],
        if (themeConfig.useThemedExploreBackground)
          DecoratedBox(
            // Light Makkah keeps its full-bleed `places_makkah.png` background
            // here; dark Makkah relies on the Stack layers below (pattern +
            // gradient overlay), so no decoration is needed for that variant.
            decoration: BoxDecoration(
              image: themeConfig.exploreBackgroundImageBuilder != null
                  ? DecorationImage(
                      image: themeConfig.exploreBackgroundImageBuilder!(),
                      matchTextDirection: true,
                      fit: BoxFit.cover,
                      alignment: AlignmentDirectional.centerEnd,
                    )
                  : null,
            ),
            child:
                // Layer 1 (back): explore content. Stays at the bottom of the
                // stack so the gradient + pattern overlays sit on top of it.
                Column(
                  children: [
                    DashboardTitle(context.l10n.exploreNearby),
                    Stack(
                      children: [
                        // pattern
                        if (themeConfig.exploreBackgroundImageBuilder == null)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 132,
                            child: IgnorePointer(
                              child: Image(
                                image: Assets.images.dashboardBgPattern.provider(),
                                fit: BoxFit.fitHeight,
                                repeat: ImageRepeat.repeatX,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                          ),

                        // gradient
                        if (themeConfig.exploreBackgroundImageBuilder == null)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [0.5, 1.0],
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF31CDC2).withOpacity(0.74),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // body
                        const Column(
                          children: [
                            SizedBox(height: Spacing.$4x),
                            PlacePreviewMakkah(),
                            SizedBox(height: Spacing.$6x),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
          ),
      ],
    );
  }
}

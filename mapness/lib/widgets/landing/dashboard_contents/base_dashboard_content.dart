import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/debug/recommendations_feature_flag.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/explore_card.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/dashboard_feedback/feedback_banner_card_v2.dart';
import 'package:mapness/widgets/founding_day/dashboard_bg.dart';
import 'package:mapness/widgets/landing/dashboard/dashboard_actions.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/landing/drive_back_home_card.dart';
import 'package:mapness/widgets/landing/kaaba_virtual_journey_card.dart';
import 'package:mapness/widgets/landing/place_preview.dart';
import 'package:mapness/widgets/landing/quick_action_button.dart';
import 'package:mapness/widgets/stories/lib/stories_widget.dart';
import 'package:sheetify/sheetify.dart';

import '../../../features/city_event/active_city_event.dart';

class BaseDashboardContent extends ConsumerWidget {
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;
  final AnimationController fireworksController;

  const BaseDashboardContent({
    required this.themeConfig,
    required this.bottomSheetController,
    required this.fireworksController,
    super.key,
  });

  final DashboardThemeConfig themeConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = DashboardActions(ref, bottomSheetController: bottomSheetController);
    final activeEvent = ref.watch(activeCityEventProvider);
    // final isNationalDay = activeEvent?.isSaudiNationalDay ?? false;
    // final isFoundingday = activeEvent?.isFoundingDay ?? false;
    final isNationalDay = true;
    final isFoundingday = true;
    final pilgrimFeature = ref.watch(showPilgrimFeatureProvider);
    final recommendationsEnabled = ref.watch(recommendationsFeatureFlagProvider);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (isFoundingday) const FoundingDayBackground(),
        Column(
          children: [
            Column(
              children: [
                StoriesWidget(
                  titleWidget: Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.$3x),
                    child: DashboardTitle(context.l10n.whatIsNewInBalady),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.$6x),
            // 1. Feedback Banner (ساهم معنا)
            SizedBox(
              width: double.infinity,
              child: FeedbackBannerCardV2(
                path: themeConfig.feedbackBannerAssetPath,
                onTap: () async {
                  final router = ref.read(appRouterProvider);
                  ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiBanner);
                  if (bottomSheetController.closestState != ThreeStateSheet.hidden) {
                    bottomSheetController.setState(
                      ThreeStateSheet.hidden,
                      duration: const Duration(milliseconds: 1),
                    );
                  }
                  await Future<void>.delayed(const Duration(milliseconds: 32));
                  await router.push(const ContributeRoute());
                },
                gradientColors: themeConfig.feedbackBannerGradient,
                title: context.l10n.contribute,
                subtitle: context.l10n.buildBaladyTogether,
                semanticsLabel: context.l10n.a11yContributeBanner,
                imageSizeCalculator: themeConfig.imageSizeCalculator,
              ),
            ),

            const SizedBox(height: Spacing.$6x),
            if (pilgrimFeature != null) ...[
              KaabaVirtualJourneyCard(
                onTap: () {
                  Metrics.logEventAdvanced(
                    MetricsConstants.kaabaTourKeys.cardTapped,
                    group: MetricsConstants.kaabaTourTag,
                    action: MetricAction.tap.name,
                    props: const {'theme': 'base'},
                  );
                  context.router.push(const GaussianSplattingRoute());
                },
              ),
              const SizedBox(height: Spacing.$6x),
            ],

            // 2. Quick Actions (إجراءات سريعة)
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
                    if (recommendationsEnabled) ...[
                      QuickActionButton(
                        text: context.l10n.nearby,
                        icon: GeneralIcons.location,
                        onTap: () => actions.openNearby(context),
                      ),
                      const SizedBox(width: Spacing.$2x),
                    ],
                    QuickActionButton(
                      text: context.l10n.sendLocation,
                      icon: General32Icons.locationAction,
                      onTap: () => actions.openMyLocation(context),
                    ),
                    const SizedBox(width: Spacing.$2x),
                    QuickActionButton(
                      text: context.l10n.freeRoam,
                      icon: TransportIcons.newlocationDirectionNavigator,
                      onTap: () => actions.openFreeRoam(context),
                    ),
                    const SizedBox(width: Spacing.$2x),
                    QuickActionButton(
                      text: context.l10n.parkingAction,
                      icon: General32Icons.parkingAction,
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
                                        label: Directionality.of(context) == TextDirection.rtl
                                            ? 'إعادة المحاولة'
                                            : 'Retry',
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
                      onTap: actions.openSnapAndSend,
                    ),
                    const SizedBox(width: Spacing.$2x),
                    QuickActionButton(
                      text: context.l10n.qibla,
                      icon: General32Icons.qiblaAction,
                      onTap: () => actions.openQibla(context),
                    ),
                    const SizedBox(width: Spacing.$2x),
                    QuickActionButton(
                      text: context.l10n.quaranAction,
                      icon: General32Icons.quaranAction,
                      onTap: actions.openQuran,
                    ),
                    const SizedBox(width: Spacing.$2x),
                    QuickActionButton(
                      text: context.l10n.athkarAction,
                      icon: General32Icons.athkarAction,
                      onTap: actions.openAthkar,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.$4x),
            DriveBackHomeCard(bottomSheetController: bottomSheetController),
            const SizedBox(height: Spacing.$6x),
            if (!themeConfig.useThemedExploreBackground) ...[
              DashboardTitle(context.l10n.exploreNearby),
              const SizedBox(height: Spacing.$4x),
              const PlacePreview(),
              const SizedBox(height: Spacing.$4x),
              const ExploreCard(),
              const SizedBox(height: Spacing.$10x),
            ],
            if (themeConfig.useThemedExploreBackground)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: themeConfig.exploreBackgroundGradient,
                  ),
                  image: themeConfig.exploreBackgroundImageBuilder != null
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
                    const PlacePreview(),
                    const SizedBox(height: Spacing.$6x),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// Helper left here intentionally for future themed dashboard variants, if needed.

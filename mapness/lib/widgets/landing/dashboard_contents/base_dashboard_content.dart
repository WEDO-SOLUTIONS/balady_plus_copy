import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/dashboard_feedback/feedback_banner_card_v2.dart';
import 'package:mapness/widgets/founding_day/dashboard_bg.dart';
import 'package:mapness/widgets/landing/dashboard/dashboard_actions.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';
import 'package:mapness/widgets/landing/dashboard_offers_row.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/landing/drive_back_home_card.dart';
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
    final isNationalDay = activeEvent?.isSaudiNationalDay ?? false;
    final isFoundingday = activeEvent?.isFoundingDay ?? false;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (isFoundingday) const FoundingDayBackground(),
        Column(
          children: [
            const Column(
              children: [
                StoriesWidget(),
              ],
            ),
            const SizedBox(height: Spacing.$3x),
            SizedBox(
              width: double.infinity,
              child: FeedbackBannerCardV2(
                path: themeConfig.feedbackBannerAssetPath,
                onTap: () {
                  ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiBanner);
                  context.router.push(const ContributeRoute());
                },
                gradientColors: themeConfig.feedbackBannerGradient,
                title: context.l10n.contribute,
                subtitle: context.l10n.buildBaladyTogether,
                imageSizeCalculator: themeConfig.imageSizeCalculator,
              ),
            ),
            const SizedBox(height: Spacing.$6x),
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
                      text: context.l10n.sendLocation,
                      icon: General32Icons.locationAction,
                      onTap: () => actions.openMyLocation(context),
                    ),
                    const SizedBox(width: Spacing.$2x),
                    QuickActionButton(
                      text: context.l10n.freeRoam,
                      icon: TransportIcons.locationDirectionNavigator,
                      onTap: () => actions.openFreeRoam(context),
                    ),
                    const SizedBox(width: Spacing.$2x),
                    QuickActionButton(
                      text: context.l10n.parkingAction,
                      icon: General32Icons.parkingAction,
                      onTap: actions.openParking,
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
            const DriveBackHomeCard(),
            const SizedBox(height: Spacing.$6x),
            const DashboardOffersRow(),
            const SizedBox(height: Spacing.$6x),
            if (!themeConfig.useThemedExploreBackground) ...[
              DashboardTitle(context.l10n.exploreNearby),
              const SizedBox(height: Spacing.$4x),
              const PlacePreview(),
              const SizedBox(height: Spacing.$6x),
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

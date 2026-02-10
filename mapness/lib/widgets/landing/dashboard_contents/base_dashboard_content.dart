import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/dashboard_feedback/feedback_banner_card_v2.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_config.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_logo.dart';
import 'package:mapness/widgets/landing/dashboard/dashboard_actions.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';
import 'package:mapness/widgets/landing/dashboard_offers_row.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/landing/drive_back_home_card.dart';
import 'package:mapness/widgets/landing/place_preview.dart';
import 'package:mapness/widgets/landing/quick_action_button.dart';
import 'package:mapness/widgets/stories/lib/stories_widget.dart';
import 'package:sheetify/multi_state_sheet/multi_state_sheet.dart';
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
    print('amr BaseDashboardContent build');
    final actions = DashboardActions(ref);
    final activeEvent = ref.watch(activeCityEventProvider);
    final isNationalDay = activeEvent?.isSaudiNationalDay ?? false;
    // final config = CityEventConfig.fromEventType(activeEvent);
    // final eventLogo = config?.logoConfig != null && config!.hasDashboardLogo
    //     ? CityEventLogo(
    //   config: config.logoConfig!,
    //   fireworksController: fireworksController,
    //   onTap: () {
    //     print('amr activeEvent $activeEvent');
    //     if (activeEvent == CityEventType.foundingDay) {
    //       ref.read(foundingDayUrbiProvider.notifier).openThePlace();
    //     }
    //   },
    // )
    //     : null;

    return Column(
      children: [
        const SizedBox(height: Spacing.$3x),
        SizedBox(
          width: double.infinity,
          child: FeedbackBannerCardV2(
            path: themeConfig.feedbackBannerAssetPath,
            onTap: () {
              ref
                  .read(advertMetricsProvider.notifier)
                  .sendEvent(AdvertMetricsKeys.addPoiBanner);
              context.router.push(const ContributeRoute());
            },
            gradientColors: themeConfig.feedbackBannerGradient,
            title: context.l10n.contribute,
            subtitle: context.l10n.buildBaladyTogether,
          ),
        ),
        const SizedBox(height: Spacing.$6x),
        StoriesWidget(
          titleWidget: Padding(
            padding: const EdgeInsets.only(bottom: Spacing.$3x),
            child: DashboardTitle(context.l10n.whatIsNewInBalady),
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
                const PlacePreview(),
                const SizedBox(height: Spacing.$6x),
              ],
            ),
          ),
        // if (eventLogo != null)
        //   AnimatedBuilder(
        //     animation: bottomSheetController,
        //     builder: (context, snapshot) {
        //       final fraction = bottomSheetController.fraction;
        //       // Direction-agnostic visibility windows:
        //       // Opening:  0.91 → 0.96  (becomes fully invisible at >= 0.96)
        //       // Closing:  0.19 → 0.11  (becomes fully invisible at <= 0.11)
        //       const double openStart = 0.91;
        //       const double openEnd = 0.96; // fully invisible here
        //       const double closeStart = 0.19;
        //       const double closeEnd = 0.11; // fully invisible here
        //       const double eps = 1e-6;
        //
        //       // Compute shrink amount independently for both windows and take the stronger effect.
        //       final double openT = ((fraction - openStart) / (openEnd - openStart)).clamp(0.0, 1.0);
        //       final double closeT = ((closeStart - fraction) / (closeStart - closeEnd)).clamp(0.0, 1.0);
        //       final double shrink = max(openT, closeT); // 0.0..1.0
        //       double scaleValue = 1.0 - shrink; // 1.0..0.0
        //
        //       // Hard clamp to 0 when we are beyond the full-invisible bounds.
        //       if (fraction >= openEnd - eps || fraction <= closeEnd + eps) {
        //         scaleValue = 0.0;
        //       }
        //
        //       final double _baseBottom = (bottomSheetController.sheetHeight + (50 * scaleValue)).clamp(
        //         0.0,
        //         double.infinity,
        //       );
        //       return Positioned(
        //         bottom: _baseBottom,
        //         child: scaleValue <= 0.0
        //             ? const SizedBox.shrink()
        //             : Opacity(
        //           opacity: scaleValue, // fade together with scale to avoid subpixel artifacts
        //           child: Transform.scale(
        //             scale: scaleValue,
        //             alignment: Alignment.bottomCenter,
        //             child: eventLogo,
        //           ),
        //         ),
        //       );
        //     },
        //   ),
      ],
    );
  }
}

// Helper left here intentionally for future themed dashboard variants, if needed.

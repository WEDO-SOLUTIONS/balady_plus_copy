import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/app_analytics/datafinder_source_tracker.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/pages/landing/landing_page.dart';
import 'package:mapness/pages/landing/landing_state_mapper.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/bottom_menu/app_bottom_navigation_bar_item.dart';
import 'package:mapness/widgets/bottom_menu/default_icon.dart';
import 'package:mapness/widgets/bottom_menu/lazy_index_stack.dart';
import 'package:mapness/widgets/profile/profile_image/profile_image_widget.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class BottomMenuPage extends ConsumerStatefulWidget {
  const BottomMenuPage({super.key});

  @override
  ConsumerState<BottomMenuPage> createState() => _BottomMenuPageState();
}

class _BottomMenuPageState extends ConsumerState<BottomMenuPage> with TickerProviderStateMixin {
  late final landingController = MultiStateSheetController<ThreeStateSheet>(
    initialState: ThreeStateSheet.open,
    behavior: FractionSnappingBehavior(fractions: {0.0, if (Platform.isIOS) .3 else .38, 1.0}),
    stateMapper: const LandingStateMapper(),
  );

  late final routingController = MultiStateSheetController<ThreeStateSheet>(
    behavior: MultiSnappingBehavior(
      models: [
        FractionSnappingModel({0.4, 0.931}),
        ComponentsSnappingModel(componentsDescriptions: [const SnapComponentSize(component: Components.header)]),
      ],
    ),
    stateMapper: const LandingStateMapper(),
    initialState: ThreeStateSheet.open,
  );

  @override
  void initState() {
    ref.read(bottomSheetControllerProvider.notifier).state.controller = landingController;
    super.initState();
  }

  @override
  void dispose() {
    landingController.dispose();
    routingController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    // DataFinder: the bottom-menu tab sets the journey origin. Tab 0 = Explore
    // (Landing), tab 1 = Routes. Other tabs don't drive DataFinder search, so
    // leave the origin as-is.
    final tracker = ref.read(dataFinderSourceTrackerProvider.notifier);
    if (index == 0) {
      tracker.stampOrigin(DataFinderOrigin.explore);
    } else if (index == 1) {
      tracker.stampOrigin(DataFinderOrigin.routes);
    }

    final controller = switch (index) {
      0 => landingController,
      1 => routingController,
      _ => ref.read(bottomSheetControllerProvider.notifier).state.controller,
    };

    if (index > 1) {
      controller?.setState(ThreeStateSheet.open);
    }

    ref.read(bottomSheetControllerProvider.notifier).state.controller = controller;
  }

  @override
  Widget build(BuildContext context) => AutoTabsRouter.builder(
    routes: [const LandingRoute(), const RoutingPointsRoute(), MapnessServicesRoute(), const ProfileRoute()],
    onNavigate: (tab) {
      _onTabChanged(tab.activeIndex);

      // Send event to analytics when route is Selected
      if (tab.activeIndex == 1) {
        ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingRoute);
      }

      if (tab.activeIndex == 2 && tab.previousIndex != 2) {
        ref.read(appAnalyticsProvider).serviceSectionVisited();
      }
    },
    builder: (_, tabsRouter, route) {
      final controller = ref.watch(bottomSheetControllerProvider.notifier).state.controller;
      final isFoundedDay = ref.watch(activeCityEventProvider)?.isFoundingDay ?? false;
      final accentColor = isFoundedDay ? context.colors.accentSecondaryDefault : context.colors.accentDefault;
      return Column(
        children: [
          Expanded(
            child: LazyIndexedStack(
              index: route.activeIndex,
              children: tabsRouter,
            ),
          ),
          if (controller == null)
            const SizedBox.shrink()
          else
            ListenableBuilder(
              listenable: controller,
              builder: (context, child) {
                final isHidden = controller.closestState == ThreeStateSheet.hidden;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isHidden ? context.colors.backgroundSurface2 : context.colors.backgroundSurface1,
                    boxShadow: [
                      BoxShadow(
                        color: NonThemeColor.color14.withOpacity(0.05),
                        offset: const Offset(0, -2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    selectedLabelStyle: TextStyle(
                      color: context.colors.accentOnContainer,
                      fontSize: 0,
                      height: 0,
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: context.colors.foregroundDefault,
                      fontSize: 0,
                      height: 0,
                    ),
                    items: [
                      BottomNavigationBarItem(
                        icon: AppBottomNavigationBarItem(
                          selected: route.activeIndex == 0,
                          iconBuilder: (ctx, isSelected) => DefaultIcon(
                            icon: GeneralIcons.pin,
                            selected: isSelected,
                            color: isSelected ? accentColor : context.colors.foregroundSoft,
                          ),
                          label: context.l10n.nav_general,
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: AppBottomNavigationBarItem(
                          selected: route.activeIndex == 1,
                          iconBuilder: (ctx, isSelected) => DefaultIcon(
                            icon: GeneralIcons.routeStroke,
                            selected: isSelected,
                            color: isSelected ? accentColor : context.colors.foregroundSoft,
                          ),
                          label: context.l10n.nav_route,
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: AppBottomNavigationBarItem(
                          selected: route.activeIndex == 2,
                          iconBuilder: (ctx, isSelected) => DefaultIcon(
                            icon: GeneralIcons.dashboard,
                            selected: isSelected,
                            color: isSelected ? accentColor : context.colors.foregroundSoft,
                          ),
                          label: context.l10n.nav_landing,
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: AppBottomNavigationBarItem(
                          selected: route.activeIndex == 3,
                          iconBuilder: (context, isSelected) => ProfileImageWidget(
                            dimension: AvatarSize.$24,
                            isSelected: isSelected,
                          ),
                          label: context.l10n.nav_profile,
                        ),
                        label: '',
                      ),
                    ],
                    currentIndex: route.activeIndex,
                    onTap: route.setActiveIndex,
                  ),
                );
              },
            ),
        ],
      );
    },
  );
}

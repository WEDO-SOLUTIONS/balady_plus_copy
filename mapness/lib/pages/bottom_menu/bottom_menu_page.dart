import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/bottom_menu/app_bottom_navigation_bar_item.dart';
import 'package:mapness/widgets/bottom_menu/default_icon.dart';
import 'package:mapness/widgets/bottom_menu/lazy_index_stack.dart';
import 'package:mapness/widgets/profile/profile_image_widget.dart';

@RoutePage()
class BottomMenuPage extends ConsumerStatefulWidget {
  const BottomMenuPage({super.key});

  @override
  ConsumerState<BottomMenuPage> createState() => _BottomMenuScreenState();
}

class _BottomMenuScreenState extends ConsumerState<BottomMenuPage> {
  final List<PageRouteInfo<dynamic>> _buildRoutes = [
    const LandingRoute(),
    const RoutingPointsRoute(),
    const MapnessServicesRoute(),
    const ProfileRoute(),
  ];

  @override
  Widget build(BuildContext context) => AutoTabsRouter.builder(
        routes: _buildRoutes,
        builder: (_, tabsRouter, route) => Column(
          children: [
            Expanded(
              child: LazyIndexedStack(
                index: route.activeIndex,
                children: tabsRouter,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: NonThemeColor.color14.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: TextStyle(
                  color: context.color.strokeAccent,
                  fontSize: 0,
                  height: 0,
                ),
                unselectedLabelStyle: TextStyle(
                  color: context.color.textAndIconsBasePrimary,
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
                      ),
                      label: context.l10n.nav_general,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: AppBottomNavigationBarItem(
                      selected: route.activeIndex == 1,
                      iconBuilder: (ctx, isSelected) => DefaultIcon(
                        icon: GeneralIcons.route,
                        selected: isSelected,
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
                      ),
                      label: context.l10n.nav_landing,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: AppBottomNavigationBarItem(
                      selected: route.activeIndex == 3,
                      iconBuilder: (context, selected) => ProfileImageWidget(
                        dimension: 24,
                        color: selected ? context.colorsV2.accentDefault : context.colorsV2.foregroundSoft,
                      ),
                      label: context.l10n.nav_profile,
                    ),
                    label: '',
                  ),
                ],
                currentIndex: route.activeIndex,
                onTap: route.setActiveIndex,
              ),
            ),
          ],
        ),
      );
}
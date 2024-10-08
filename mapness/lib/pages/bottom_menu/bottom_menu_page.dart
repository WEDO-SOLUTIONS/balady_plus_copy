import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
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
    RoutingPointsRoute(),
    const MapnessServicesRoute(),
    const ProfileRoute(),
  ];

  @override
  Widget build(BuildContext context) => AutoTabsScaffold(
        homeIndex: 0,
        routes: _buildRoutes,
        bottomNavigationBuilder: (_, tabsRouter) => DecoratedBox(
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
            backgroundColor: Colors.white,
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
                icon: _BottomNavigationBarItem(
                  selected: tabsRouter.activeIndex == 0,
                  iconBuilder: (ctx, isSelected) => _DefaultIcon(
                    icon: GeneralIcons.pin,
                    selected: isSelected,
                  ),
                  label: context.l10n.nav_general,
                ),
                label: '',
              ),
                BottomNavigationBarItem(
                  icon: _BottomNavigationBarItem(
                    selected: tabsRouter.activeIndex == 1,
                    iconBuilder: (ctx, isSelected) => _DefaultIcon(
                      icon: GeneralIcons.route,
                      selected: isSelected,
                    ),
                    label: context.l10n.nav_route,
                  ),
                  label: '',
                ),
              BottomNavigationBarItem(
                icon: _BottomNavigationBarItem(
                  selected: tabsRouter.activeIndex == 2,
                  iconBuilder: (ctx, isSelected) => _DefaultIcon(
                    icon: GeneralIcons.dashboard,
                    selected: isSelected,
                  ),
                  label: context.l10n.nav_landing,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _BottomNavigationBarItem(
                  selected: tabsRouter.activeIndex == 3,
                  iconBuilder: (context, selected) => ProfileImageWidget(
                    dimension: 24,
                    color: selected ? context.colorsV2.accentDefault : context.colorsV2.foregroundSoft,
                  ),
                  label: context.l10n.nav_profile,
                ),
                label: '',
              ),
            ],
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
          ),
        ),
    );
}

class _BottomNavigationBarItem extends StatelessWidget {
  final bool selected;
  final Widget Function(BuildContext, bool) iconBuilder;
  final String? label;

  const _BottomNavigationBarItem({
    required this.selected,
    required this.iconBuilder,
    this.label,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          children: [
            iconBuilder.call(context, selected),
            const SizedBox(height: 2),
            _DefaultLabel(
              label: label!,
              selected: selected,
            ),
          ],
        ),
      );
}

class _DefaultIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const _DefaultIcon({
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) => Icon(
        icon,
        size: 24,
        color: selected ? context.colorsV2.accentDefault : context.colorsV2.foregroundSoft,
      );
}

class _DefaultLabel extends StatelessWidget {
  final String label;
  final bool selected;

  const _DefaultLabel({
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: context.textStyleV3.captionSmallMedium.copyWith(
          color: selected ? context.colorsV2.accentDefault : context.colorsV2.foregroundSoft,
        ),
      );
}

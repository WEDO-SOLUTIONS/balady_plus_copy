part of 'path_nav_map_controls.dart';

/// Landscape https://www.figma.com/design/59ohkX2UrM4EDS2zdw5C9r/Landscape-Mode-For-Navigation?node-id=493-24015&t=YZybI5BZ44k4JHls-0
class _LandscapeLayout extends StatelessWidget {
  final RouteSearchOptionsMessage navType;

  final ValueNotifier<PathNavState> navigationState;
  final ValueNotifier<bool> expansionNotifier;
  final ValueNotifier<bool> showControls;
  final Widget maneuverAndLimitWidget;
  final Widget compassControlWidget;

  final VoidCallback toggleExpansionNotifier;

  final VoidCallback? onUserActivity;
  final Widget pathNavFollowControlWidget;
  final EdgeInsets padding;

  const _LandscapeLayout({
    required this.navType,
    required this.navigationState,
    required this.expansionNotifier,
    required this.showControls,
    required this.maneuverAndLimitWidget,
    required this.toggleExpansionNotifier,
    required this.pathNavFollowControlWidget,
    required this.padding,
    required this.compassControlWidget,
    this.onUserActivity,
  });

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: navigationState,
        builder: (context, pathNavState, child) {
          final onTap = pathNavState == PathNavState.finished ? toggleExpansionNotifier : null;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: child,
          );
        },
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(uikit.Spacing.$4x).copyWith(top: uikit.Spacing.$3x),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      maneuverAndLimitWidget,
                      const Spacer(),
                      if (navType == RouteSearchOptionsMessage.pedestrian)
                        Padding(
                          padding: padding,
                          child: const IndoorControl(),
                        ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: showControls,
                  builder: (context, isVisible, child) => AnimatedOpacity(
                    opacity: isVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: IgnorePointer(
                      ignoring: !isVisible,
                      child: GestureDetector(
                        onTap: onUserActivity,
                        child: Column(
                          children: [
                            const TrafficParkingControl(parkingVisible: false),
                            //TODO(scroollocker): Enable when prepare release
                            // const SizedBox(height: uikit.Spacing.$2x),
                            // const DimensionContrtol(),
                            const Spacer(),
                            const ZoomControl(),
                            const Spacer(),
                            compassControlWidget,
                            uikit.Spacing.$2x.heightBox,
                            pathNavFollowControlWidget,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

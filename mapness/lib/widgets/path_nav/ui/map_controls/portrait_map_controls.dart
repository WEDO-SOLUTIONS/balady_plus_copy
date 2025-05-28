part of 'path_nav_map_controls.dart';

class _PortraitLayout extends StatelessWidget {
  final RouteSearchOptionsMessage navType;
  final ValueNotifier<double> bottomHeightNotifier;
  final ValueNotifier<PathNavState> navigationState;
  final ValueNotifier<bool> expansionNotifier;
  final ValueNotifier<bool> showControls;
  final Widget maneuverAndLimitWidget;
  final Widget compassControlWidget;
  final VoidCallback toggleExpansionNotifier;
  final VoidCallback? onRoutePressed;
  final VoidCallback? onUserActivity;
  final Widget pathNavFollowControlWidget;
  final EdgeInsets padding;

  const _PortraitLayout({
    required this.bottomHeightNotifier,
    required this.navigationState,
    required this.expansionNotifier,
    required this.maneuverAndLimitWidget,
    required this.compassControlWidget,
    required this.showControls,
    required this.pathNavFollowControlWidget,
    required this.padding,
    required this.navType,
    required this.toggleExpansionNotifier,
    this.onRoutePressed,
    this.onUserActivity,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: navigationState,
              builder: (context, state, child) {
                if (state == PathNavState.finished) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: toggleExpansionNotifier,
                    child: const SizedBox.expand(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 6, width: double.maxFinite),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: uikit.Spacing.$3x),
                  child: maneuverAndLimitWidget,
                ),
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: showControls,
                      builder: (context, isVisible, child) => AnimatedOpacity(
                            opacity: isVisible ? 1 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: IgnorePointer(
                              ignoring: !isVisible,
                              child: GestureDetector(
                                onTap: onUserActivity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: padding,
                                      child: const TrafficParkingControl(trafficVisible: false),
                                    ),
                                    const SizedBox(height: uikit.Spacing.$2x),
                                    Padding(
                                      padding: padding,
                                      child: const DimensionControl(),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: padding,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (navType == RouteSearchOptionsMessage.pedestrian)
                                            const IndoorControl()
                                          else
                                            const SizedBox.shrink(),
                                          const ZoomControl(),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: padding,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: navigationState,
                                              builder: (context, state, _) {
                                                if (state == PathNavState.finished ||
                                                    state == PathNavState.paused ||
                                                    onRoutePressed == null) {
                                                  return const SizedBox.shrink();
                                                }
                                                return RouteControl(
                                                  onTap: onRoutePressed!,
                                                );
                                              }),
                                          const Spacer(),
                                          Column(
                                            children: [
                                              compassControlWidget,
                                              uikit.Spacing.$2x.heightBox,
                                              pathNavFollowControlWidget,
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                ),
                ValueListenableBuilder(
                  valueListenable: bottomHeightNotifier,
                  builder: (context, value, _) => min(value, 120.0).heightBox,
                )
              ],
            ),
          ],
        ),
      );
}

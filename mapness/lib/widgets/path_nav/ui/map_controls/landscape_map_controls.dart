part of 'path_nav_map_controls.dart';

/// Landscape https://www.figma.com/design/59ohkX2UrM4EDS2zdw5C9r/Landscape-Mode-For-Navigation?node-id=493-24015&t=YZybI5BZ44k4JHls-0
class _LandscapeLayout extends StatelessWidget {
  final RouteSearchOptionsMessage navType;

  final ValueNotifier<PathNavState> navigationState;

  final ValueNotifier<bool> showControls;
  final Widget maneuverAndLimitWidget;
  final Widget compassControlWidget;

  final VoidCallback? onUserActivity;
  final Widget pathNavFollowControlWidget;
  final EdgeInsets padding;

  const _LandscapeLayout({
    required this.navType,
    required this.navigationState,
    required this.showControls,
    required this.maneuverAndLimitWidget,
    required this.pathNavFollowControlWidget,
    required this.padding,
    required this.compassControlWidget,
    this.onUserActivity,
  });

  @override
  Widget build(BuildContext context) {
    final stableBottomInset = MediaQuery.paddingOf(context).bottom == 0 ? uikit.Spacing.$3x : 0;
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: uikit.Spacing.$3x,
          bottom: uikit.Spacing.$3x + stableBottomInset,
          end: uikit.Spacing.$4x,
        ),
        // Landscape leaves little height: both columns drop their lowest-priority controls instead of overflowing.
        child: ValueListenableBuilder(
          valueListenable: showControls,
          builder: (context, isVisible, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: MapControlsColumn(
                    children: [
                      MapControlsItem(priority: 100, child: maneuverAndLimitWidget),
                      const MapControlsItem(
                        priority: 60,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: uikit.Spacing.$3x,
                            top: uikit.Spacing.$6x * 2 - uikit.Spacing.$2x,
                          ),
                          child: SoundControl(),
                        ),
                      ),
                      MapControlsItem(
                        priority: 30,
                        slot: MapControlsSlot.bottom,
                        child: _FadeWhenHidden(visible: isVisible, child: const RadioContextualButton()),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: onUserActivity,
                child: MapControlsColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MapControlsItem(
                      priority: 50,
                      child: _FadeWhenHidden(
                        visible: isVisible,
                        child: const TrafficParkingControl(trafficVisible: false, parkingVisible: false),
                      ),
                    ),
                    MapControlsItem(
                      priority: 45,
                      child: _FadeWhenHidden(visible: isVisible, child: const DimensionControl()),
                    ),
                    MapControlsItem(
                      priority: 60,
                      slot: MapControlsSlot.bottom,
                      child: _FadeWhenHidden(visible: isVisible, child: compassControlWidget),
                    ),
                    MapControlsItem(priority: 100, slot: MapControlsSlot.bottom, child: pathNavFollowControlWidget),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  maneuverAndLimitWidget,
                  const SizedBox(height: uikit.Spacing.$6x),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: uikit.Spacing.$3x, top: uikit.Spacing.$6x),
                    child: SoundControl(),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: uikit.Spacing.$3x, bottom: uikit.Spacing.$3x),
                    child: ValueListenableBuilder(
                      valueListenable: showControls,
                      builder: (context, isVisible, child) => AnimatedOpacity(
                        opacity: isVisible ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: IgnorePointer(
                          ignoring: !isVisible,
                          child: const RadioContextualButton(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: showControls,
              builder: (context, isVisible, child) => GestureDetector(
                onTap: onUserActivity,
                child: Column(
                  children: [
                    AnimatedOpacity(
                      opacity: isVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: IgnorePointer(
                        ignoring: !isVisible,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: uikit.Spacing.$2x,
                          children: [
                            TrafficParkingControl(trafficVisible: false, parkingVisible: false),
                            DimensionControl(),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    AnimatedOpacity(
                      opacity: isVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: IgnorePointer(
                        ignoring: !isVisible,
                        child: const ReportRoadEventMapSelectControl(),
                      ),
                    ),
                    const Spacer(),
                    AnimatedOpacity(
                      opacity: isVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: IgnorePointer(
                        ignoring: !isVisible,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            compassControlWidget,
                            uikit.Spacing.$2x.heightBox,
                          ],
                        ),
                      ),
                    ),
                    pathNavFollowControlWidget,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

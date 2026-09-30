part of 'path_nav_map_controls.dart';

class _PortraitLayout extends ConsumerStatefulWidget {
  final RouteSearchOptionsMessage navType;
  final ValueNotifier<double> bottomHeightNotifier;
  final ValueNotifier<PathNavState> navigationState;
  final ValueNotifier<bool> showControls;
  final Widget maneuverAndLimitWidget;
  final Widget compassControlWidget;
  final VoidCallback? onRoutePressed;
  final VoidCallback? onUserActivity;
  final Widget pathNavFollowControlWidget;
  final EdgeInsets padding;

  const _PortraitLayout({
    required this.bottomHeightNotifier,
    required this.navigationState,
    required this.maneuverAndLimitWidget,
    required this.compassControlWidget,
    required this.showControls,
    required this.pathNavFollowControlWidget,
    required this.padding,
    required this.navType,
    this.onRoutePressed,
    this.onUserActivity,
  });

  @override
  ConsumerState<_PortraitLayout> createState() => _PortraitLayoutState();
}

class _PortraitLayoutState extends ConsumerState<_PortraitLayout> {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 6, width: double.maxFinite),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: uikit.Spacing.$3x),
          child: widget.maneuverAndLimitWidget,
        ),
        const SizedBox(height: uikit.Spacing.$6x),
        // The space left between the maneuver card and the sheet shrinks as the sheet grows; both columns drop their
        // lowest-priority controls instead of overflowing.
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: widget.showControls,
            builder: (context, isVisible, child) => GestureDetector(
              onTap: widget.onUserActivity,
              child: Padding(
                padding: widget.padding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MapControlsColumn(
                      children: [
                        const MapControlsItem(priority: 80, child: SoundControl()),
                        if (widget.navType == RouteSearchOptionsMessage.pedestrian)
                          MapControlsItem(
                            priority: 40,
                            slot: MapControlsSlot.center,
                            child: _FadeWhenHidden(visible: isVisible, child: const IndoorControl()),
                          ),
                        MapControlsItem(
                          priority: 30,
                          slot: MapControlsSlot.bottom,
                          child: _FadeWhenHidden(visible: isVisible, child: const RadioContextualButton()),
                        ),
                        MapControlsItem(
                          priority: 70,
                          slot: MapControlsSlot.bottom,
                          child: _FadeWhenHidden(
                            visible: isVisible,
                            child: ValueListenableBuilder(
                              valueListenable: widget.navigationState,
                              builder: (context, state, _) {
                                if (state == PathNavState.finished ||
                                    state == PathNavState.paused ||
                                    widget.onRoutePressed == null) {
                                  return const SizedBox.shrink();
                                }
                                return RouteControl(onTap: widget.onRoutePressed!);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    MapControlsColumn(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MapControlsItem(
                          priority: 50,
                          child: _FadeWhenHidden(
                            visible: isVisible,
                            child: const TrafficParkingControl(trafficVisible: false),
                          ),
                        ),
                        MapControlsItem(
                          priority: 45,
                          child: _FadeWhenHidden(visible: isVisible, child: const DimensionControl()),
                        ),
                        MapControlsItem(
                          priority: 60,
                          slot: MapControlsSlot.bottom,
                          child: _FadeWhenHidden(visible: isVisible, child: widget.compassControlWidget),
                        ),
                        MapControlsItem(
                          priority: 100,
                          slot: MapControlsSlot.bottom,
                          child: widget.pathNavFollowControlWidget,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.bottomHeightNotifier,
          builder: (context, value, _) => value.heightBox,
        ),
      ],
    ),
  );
}

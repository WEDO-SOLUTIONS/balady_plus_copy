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
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 6, width: double.maxFinite),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: uikit.Spacing.$3x),
              child: widget.maneuverAndLimitWidget,
            ),
            const SizedBox(height: uikit.Spacing.$6x),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: widget.showControls,
                builder: (context, isVisible, child) => GestureDetector(
                  onTap: widget.onUserActivity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: widget.padding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SoundControl(),
                            AnimatedOpacity(
                              opacity: isVisible ? 1 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: IgnorePointer(
                                ignoring: !isVisible,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TrafficParkingControl(trafficVisible: false),
                                    SizedBox(height: uikit.Spacing.$2x),
                                    DimensionControl(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: isVisible ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: IgnorePointer(
                          ignoring: !isVisible,
                          child: Padding(
                            padding: widget.padding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (widget.navType == RouteSearchOptionsMessage.pedestrian) const IndoorControl(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: widget.padding,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AnimatedOpacity(
                              opacity: isVisible ? 1 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: IgnorePointer(
                                ignoring: !isVisible,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const RadioContextualButton(),
                                    const SizedBox(height: 10),
                                    ValueListenableBuilder(
                                      valueListenable: widget.navigationState,
                                      builder: (context, state, _) {
                                        if (state == PathNavState.finished ||
                                            state == PathNavState.paused ||
                                            widget.onRoutePressed == null) {
                                          return const SizedBox.shrink();
                                        }
                                        return RouteControl(
                                          onTap: widget.onRoutePressed!,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                AnimatedOpacity(
                                  opacity: isVisible ? 1 : 0,
                                  duration: const Duration(milliseconds: 250),
                                  child: IgnorePointer(
                                    ignoring: !isVisible,
                                    child: Column(
                                      children: [
                                        widget.compassControlWidget,
                                        uikit.Spacing.$2x.heightBox,
                                      ],
                                    ),
                                  ),
                                ),
                                widget.pathNavFollowControlWidget,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
      ],
    ),
  );
}

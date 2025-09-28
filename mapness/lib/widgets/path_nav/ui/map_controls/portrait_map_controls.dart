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
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 6, width: double.maxFinite),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: uikit.Spacing.$3x),
                child: widget.maneuverAndLimitWidget,
              ),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: widget.showControls,
                    builder: (context, isVisible, child) => AnimatedOpacity(
                          opacity: isVisible ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: IgnorePointer(
                            ignoring: !isVisible,
                            child: GestureDetector(
                              onTap: widget.onUserActivity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: widget.padding,
                                    child: const TrafficParkingControl(
                                        trafficVisible: false),
                                  ),
                                  const SizedBox(height: uikit.Spacing.$2x),
                                  Padding(
                                    padding: widget.padding,
                                    child: const DimensionControl(),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: widget.padding,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (widget.navType ==
                                            RouteSearchOptionsMessage
                                                .pedestrian)
                                          const IndoorControl()
                                        else
                                          const SizedBox.shrink(),
                                        const ZoomControl(),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: widget.padding,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          spacing: 10,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //todo: this icon must only if radio stream is not playing
                                            // so its 3aks el draggable floating button
                                            if (provider.selectedProgram ==
                                                null)
                                              GestureDetector(
                                                onTap: () async {
                                                  final provider = ref.read(
                                                      streamAudioProvider
                                                          .notifier);

                                                  // Reset if needed before getting live programs
                                                  if (provider
                                                      .needsReinitialization) {
                                                    await provider.reset();
                                                  }

                                                  // Ensure we have live programs data first
                                                  await provider.getLiveNow();
                                                  if (provider.liveNow?.programs
                                                          .isNotEmpty ==
                                                      true) {
                                                    await provider
                                                        .selectProgram(provider
                                                            .liveNow!
                                                            .programs
                                                            .first);
                                                  }
                                                },
                                                child: Container(
                                                  width: 48,
                                                  height: 48,
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: ShapeDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      begin: Alignment(
                                                          0.50, -0.00),
                                                      end:
                                                          Alignment(0.50, 1.00),
                                                      stops: [0.00, 0.0],
                                                      colors: [
                                                        Color(0xFF212222),
                                                        Color(0xFF212222)
                                                      ],
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                  alpha: 0.15)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                    shadows: const [
                                                      BoxShadow(
                                                        color:
                                                            Color(0x7F212222),
                                                        blurRadius: 16,
                                                        offset: Offset(0, 8),
                                                        spreadRadius: -8,
                                                      )
                                                    ],
                                                  ),
                                                  child: SvgPicture.asset(
                                                    Assets.icons.svg.audio
                                                        .audioStream.keyName,
                                                  ),
                                                ),
                                              ),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                    widget.navigationState,
                                                builder: (context, state, _) {
                                                  if (state ==
                                                          PathNavState
                                                              .finished ||
                                                      state ==
                                                          PathNavState.paused ||
                                                      widget.onRoutePressed ==
                                                          null) {
                                                    return const SizedBox
                                                        .shrink();
                                                  }
                                                  return RouteControl(
                                                    onTap:
                                                        widget.onRoutePressed!,
                                                  );
                                                }),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            widget.compassControlWidget,
                                            uikit.Spacing.$2x.heightBox,
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
                        )),
              ),
              ValueListenableBuilder(
                valueListenable: widget.bottomHeightNotifier,
                builder: (context, value, _) => value.heightBox,
              )
            ],
          ),
        ],
      ),
    );
  }
}

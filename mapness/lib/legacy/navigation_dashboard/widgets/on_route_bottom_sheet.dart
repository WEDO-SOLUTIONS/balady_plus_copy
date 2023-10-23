part of '../dashboard_control.dart';

///@nodoc
class OnRouteSheet extends StatefulWidget {
  ///@nodoc
  const OnRouteSheet({
    super.key,
    this.onSoundPressed,
    this.onRoutePressed,
    this.onCollapsePressed,
    this.onFinishPressed,
  });

  final void Function()? onSoundPressed;
  final void Function()? onRoutePressed;
  final void Function()? onCollapsePressed;
  final void Function()? onFinishPressed;

  @override
  State<OnRouteSheet> createState() => OnRouteSheetState();
}

///
class OnRouteSheetState extends State<OnRouteSheet>
    with TickerProviderStateMixin {
  late final DraggableScrollableController _sheetController;
  var sheetState = SheetStates.collapsed;
  late final AnimationController _fadeAnimationController;
  late final Animation<double> _fadeAnimation;
  double _maxExtent = .36;
  final ValueNotifier<double> _headerScaleSize = ValueNotifier(0.0);

  ///
  Future<void> hide() async {
    await _fadeAnimationController.animateTo(HIDDEN_STATE);
  }

  ///
  Future<void> unHide() async {
    await _fadeAnimationController.animateTo(EXPANDED_STATE);
  }

  ///
  Future<void> collapse() async {
    await _sheetController.animateTo(
      HIDDEN_STATE,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  ///
  Future<void> expand() async {
    await _sheetController.animateTo(
      EXPANDED_STATE,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _sheetController.addListener(() {
      if (_sheetController.size > 0.15) {
        sheetState = SheetStates.expanded;
      } else {
        sheetState = SheetStates.collapsed;
      }
      _headerScaleSize.value =
          (_sheetController.size - 0.15) * (1 / (_maxExtent - 0.15));
      // setState(() {
      //   print(
      //     "Shit $_headerScaleSize",
      //   );
      // });
    });
    _fadeAnimationController = AnimationController(
      value: 1.0,
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navViewModel = context.read<NavViewModel>();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: DraggableScrollableSheet(
        controller: _sheetController,
        snap: true,
        initialChildSize: 0.15,
        minChildSize: 0.15,
        maxChildSize: _maxExtent,
        snapSizes: [0.15, _maxExtent],
        builder: (BuildContext context, ScrollController scrollController) {
          print("Build!");
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    ValueListenableBuilder(
                      valueListenable: _headerScaleSize,
                      builder: (context, value, child) {
                        return AnimatedContainer(
                          height: 60,
                          width: min(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.width * (.8 + value),
                          ),
                          duration: const Duration(milliseconds: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: const Radius.circular(12.0),
                              bottomRight: Radius.circular((1 - value) * 12.0),
                              topLeft: const Radius.circular(12.0),
                              bottomLeft: Radius.circular((1 - value) * 12.0),
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: child,
                        );
                      },
                      child: StreamBuilder<NaviDashboardEvent>(
                          stream: navViewModel.dashboardControlEvents,
                          builder: (context, snapshot) {
                            var distanceValue = '?';
                            var distanceLabel = 'km';
                            if (snapshot.data?.distance != null) {
                              final distance = snapshot.data!.distance;
                              if (distance >= 1000) {
                                final kilometers = distance / 1000.0;
                                distanceValue = kilometers.toStringAsFixed(1);
                                distanceLabel = 'km';
                              } else {
                                distanceValue = distance.toStringAsFixed(0);
                                distanceLabel = 'm';
                              }
                            }

                            var durationValue = '?';
                            var durationLabel = 'min';

                            if (snapshot.data?.duration != null) {
                              final duration = snapshot.data!.duration;
                              if (duration >= 3600) {
                                final hours = snapshot.data!.duration / 3600.0;
                                durationValue = hours.toStringAsFixed(1);
                                durationLabel = 'hrs';
                              } else if (duration >= 60) {
                                final minutes = snapshot.data!.duration / 60.0;
                                durationValue = minutes.toStringAsFixed(1);
                                durationLabel = 'min';
                              } else {
                                durationValue = duration.toStringAsFixed(0);
                                durationLabel = 'sec';
                              }
                            }

                            return Row(
                              children: [
                                InkWell(
                                  onTap: widget.onCollapsePressed,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF4F6F7),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                        'assets/icons/svg/routing/ic_menu.svg'),
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: '$durationValue\n',
                                    style: MapnessTypography.l,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: durationLabel,
                                        style: MapnessTypography.xs,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: '${snapshot.data?.arrival_time}\n',
                                    style: MapnessTypography.l,
                                    children: const <TextSpan>[
                                      TextSpan(
                                        text: 'arrival',
                                        style: MapnessTypography.xs,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: '$distanceValue\n',
                                    style: MapnessTypography.l,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: distanceLabel,
                                        style: MapnessTypography.xs,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                              ],
                            );
                          }),
                    ),
                    const Spacer(),
                  ],
                ),
                MeasureSize(
                  onChange: (size) {
                    setState(() {
                      _maxExtent = (size.height + 60) /
                          MediaQuery.of(context).size.height;
                    });
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _headerScaleSize,
                    builder: (context, value, child) {
                      return AnimatedOpacity(
                        opacity: value,
                        duration: const Duration(milliseconds: 10),
                        child: child,
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Divider(
                            color: Colors.black87,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xffF4F6F7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              padding: const EdgeInsets.all(12),
                              child: ValueListenableBuilder(
                                  valueListenable: navViewModel.navSoundsState,
                                  builder: (context, soundsEnabled, _) {
                                    return Row(
                                      children: [
                                        RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            text: 'Sound Settings\n',
                                            style: MapnessTypography.m,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: soundsEnabled
                                                    ? 'Maneuvers included'
                                                    : 'Maneuvers are offу',
                                                style: MapnessTypography.s,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        FloatingActionButton.small(
                                          onPressed: widget.onSoundPressed,
                                          elevation: 0,
                                          backgroundColor: soundsEnabled
                                              ? Colors.green
                                              : Colors.red,
                                          child: Icon(
                                            soundsEnabled
                                                ? Icons.volume_up_rounded
                                                : Icons.volume_off_rounded,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                              onTap: widget.onRoutePressed,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xffF4F6F7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.route_outlined,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Viewing a Route',
                                      style: MapnessTypography.m,
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: widget.onFinishPressed,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                padding: const EdgeInsets.all(14.0),
                                child: const Center(
                                  child: Text('Complete the trip'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

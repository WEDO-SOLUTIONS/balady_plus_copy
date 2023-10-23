part of '../routing_overlay.dart';

class _RoutingBottomBar extends StatelessWidget {
  const _RoutingBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final routingViewModel = context.watch<RoutingViewModel>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1.5),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * .3,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 24,
                      right: 24,
                    ),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StreamBuilder<RouteChangedEvent>(
                            initialData:
                                routingViewModel.navLastRouteSpec.value,
                            stream: routingViewModel.routeChangedEvents,
                            builder: (context, snapshot) {
                              final gateCount = snapshot.data?.gateCount ?? 0;
                              final stairwayCount =
                                  snapshot.data?.stairwayCount ?? 0;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${snapshot.data?.duration.formatDuration() ?? '?'} ",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: Icon(
                                            Icons
                                                .do_not_disturb_on_total_silence_rounded,
                                            color: Colors.black54,
                                            size: 14,
                                          ),
                                        ),
                                        TextSpan(
                                          text: snapshot.data?.distance
                                                  .formatDistance() ??
                                              '?',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (stairwayCount != 0) ...[
                                        Text("$stairwayCount stairs "),
                                        SvgPicture.asset(
                                          "packages/dgis_map/assets/svg/ic_navi_ladder.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                      if (gateCount != 0) ...[
                                        Text("$gateCount gates "),
                                        SvgPicture.asset(
                                          "packages/dgis_map/assets/svg/ic_navi_gate.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                    ],
                                  ),
                                  const Text(
                                    "Including traffic jams",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ColoredBox(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: PedestrianBarWidget(
                                          controller: routingViewModel
                                              .mapController
                                              .naviPedestrianController,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  bottom: 56,
                  start: 20,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 64,
                        width: 64,
                        child: FloatingActionButton.large(
                          onPressed: routingViewModel.onNavigationGoTap,
                          elevation: 0,
                          backgroundColor: const Color(0xFF316E6C),
                          child:
                              ValueListenableBuilder<RouteSearchOptionsMessage>(
                            builder: (context, type, _) {
                              return SizedBox(
                                height: 32,
                                width: 32,
                                child: SvgPicture.asset(
                                  type.iconPath,
                                  color: Colors.white,
                                ),
                              );
                            },
                            valueListenable: routingViewModel.navRoutingType,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Go",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

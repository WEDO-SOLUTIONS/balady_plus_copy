part of '../routing_overlay.dart';

class _RoutingHeader extends StatefulWidget {
  const _RoutingHeader({
    super.key,
    required this.routeType,
  });

  final RouteSearchOptionsMessage routeType;

  @override
  State<_RoutingHeader> createState() => _RoutingHeaderState();
}

class _RoutingHeaderState extends State<_RoutingHeader>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.routeType.indexTab,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            begin: const Offset(0, -1.5),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
              ),
              sized: false,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7DBA5C), Color(0xFF316E6C)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: TabBar(
                            onTap: (index) {
                              routingViewModel.setRoutingType(_tabController
                                  .index
                                  .toRouteSearchOptionsMessage());
                            },
                            padding: EdgeInsets.zero,
                            controller: _tabController,
                            indicatorPadding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.zero,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.transparent,
                            isScrollable: true,
                            tabs: <Widget>[
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Tab(
                                  icon: SvgPicture.asset(
                                    RouteSearchOptionsMessage.car.iconPath,
                                    height: 24,
                                    width: 24,
                                    color: _tabController.index == 0
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 32.0,
                                  right: 16.0,
                                ),
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Tab(
                                    icon: SvgPicture.asset(
                                      RouteSearchOptionsMessage
                                          .pedestrian.iconPath,
                                      height: 24,
                                      width: 24,
                                      color: _tabController.index == 1
                                          ? Colors.white
                                          : Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
              ),
            ),
            _RoutingSearch(
              controller: routingViewModel.mapController,
              startObjectId: routingViewModel.navRoutingStartObjectId,
              finishObjectId: routingViewModel.navRoutingFinishObjectId,
              pointsChanged: routingViewModel.setRouteParams,
            ),
          ],
        ),
      ),
    );
  }
}

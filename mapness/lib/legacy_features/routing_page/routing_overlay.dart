import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:mapness/legacy_features/routing_page/extensions/number_formatters.dart';
import 'package:mapness/legacy_features/routing_page/extensions/route_search_options.dart';
import 'package:mapness/legacy_features/routing_page/models/routing_view_model.dart';
import 'package:mapness/legacy_features/routing_page/widgets/search_result_list.dart';
import 'package:mapness/legacy_features/routing_page/widgets/suggest_list.dart';
import 'package:provider/provider.dart';

import '../navigation_dashboard/widgets/mapness_typography.dart';
import '../navigation_dashboard/widgets/nav_controls_view.dart';
import 'data/nav_state.dart';
import 'data/object_info_state.dart';
import 'data/search_state.dart';
import 'models/routing_search_view_model.dart';

// import 'package:dgis_map_example/nav/widgets/public_transport/public_transport_sheet.dart';

part 'widgets/routing_bottom_bar.dart';

part 'widgets/routing_header.dart';

part 'widgets/routing_search.dart';

part 'widgets/routing_search_field.dart';

class RoutingOverlay extends ConsumerWidget {
  const RoutingOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dgisController = ref.watch(dgisControllerProvider);

    return Provider(
      create: (context) {
        dgisController!.changeFollowState();

        return RoutingViewModel(dgisController);
      },
      child: const _RoutingOverlay(),
    );
  }
}

class _RoutingLifecycleWrap extends StatefulWidget {
  const _RoutingLifecycleWrap({
    super.key,
    required this.child,
    required this.viewModel,
  });

  final Widget child;
  final RoutingViewModel viewModel;

  @override
  State<_RoutingLifecycleWrap> createState() => __RoutingLifecycleWrapState();
}

class __RoutingLifecycleWrapState extends State<_RoutingLifecycleWrap>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    Future.delayed(const Duration(milliseconds: 500), () {
      // widget.viewModel.setRouteParams();
      print("setRouteParams");
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _RoutingOverlay extends StatelessWidget {
  const _RoutingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final routingViewModel = context.watch<RoutingViewModel>();

    return _RoutingLifecycleWrap(
      viewModel: routingViewModel,
      child: WillPopScope(
        onWillPop: routingViewModel.onWillPop,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ValueListenableBuilder<NavigationState>(
              valueListenable: routingViewModel.navigationState,
              builder: (_, state, __) {
                return Positioned(
                  right: 0,
                  bottom: 0,
                  left: 0,
                  top: 0,
                  child: !state.isRunning
                      ? const SizedBox.shrink()
                      : NavControlsView(
                          controller: routingViewModel.mapController,
                          isFreeRoam: state.isFreeRoamMode,
                          onFreeRoamStop:
                              routingViewModel.onNavigationFreeRoamStop,
                        ),
                );
              },
            ),
            AnimatedBuilder(
                animation: Listenable.merge([
                  routingViewModel.navRoutingStartObjectId,
                  routingViewModel.navRoutingFinishObjectId,
                ]),
                builder: (_, __) {
                  return ValueListenableBuilder<NavigationState>(
                    valueListenable: routingViewModel.navigationState,
                    builder: (_, state, __) {
                      return state.isRunning ||
                              (routingViewModel.navRoutingStartObjectId.value ==
                                      null &&
                                  routingViewModel
                                          .navRoutingFinishObjectId.value ==
                                      null)
                          ? const SizedBox.shrink()
                          : ValueListenableBuilder(
                              valueListenable: routingViewModel.navRoutingType,
                              builder: (context, routingType, _) =>
                                  const Positioned(
                                right: 0,
                                bottom: 0,
                                left: 0,
                                top: 0,
                                child: _RoutingBottomBar(),
                              ),
                            );
                    },
                  );
                }),
            ValueListenableBuilder<NavigationState>(
              valueListenable: routingViewModel.navigationState,
              builder: (_, state, __) {
                return state.isRunning
                    ? const SizedBox.shrink()
                    : Positioned(
                        left: 0,
                        top: 0,
                        child: _RoutingHeader(
                          routeType: routingViewModel.navRoutingType.value,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

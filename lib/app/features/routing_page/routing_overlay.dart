import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/routing_page/extensions/number_formatters.dart';
import 'package:balady_plus/app/features/routing_page/extensions/route_search_options.dart';
import 'package:balady_plus/app/features/routing_page/models/routing_search_view_model.dart';
import 'package:balady_plus/app/features/routing_page/models/routing_view_model.dart';
import 'package:balady_plus/app/features/routing_page/widgets/search_result_list.dart';
import 'package:balady_plus/app/features/routing_page/widgets/suggest_list.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../map_page/presentation/mvvm/map_view_model.dart';
import '../navigation_dashboard/widgets/nav_controls_view.dart';
import 'data/nav_state.dart';
import 'data/object_info_state.dart';
import 'data/search_state.dart';

// import 'package:dgis_map_example/nav/widgets/public_transport/public_transport_sheet.dart';

part 'widgets/routing_bottom_bar.dart';

part 'widgets/routing_header.dart';

part 'widgets/routing_search.dart';

part 'widgets/routing_search_field.dart';

class RoutingOverlay extends StatelessWidget {
  const RoutingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) =>
          RoutingViewModel(context.read<MapViewModel>().controller),
      child: const _RoutingOverlay(),
    );
  }
}

class _RoutingOverlay extends StatelessWidget {
  const _RoutingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final routingViewModel = context.watch<RoutingViewModel>();

    return Stack(
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
                      onFreeRoamStop: routingViewModel.onNavigationFreeRoamStop,
                    ),
            );
          },
        ),
        ValueListenableBuilder<NavigationState>(
          valueListenable: routingViewModel.navigationState,
          builder: (_, state, __) {
            return state.isRunning
                ? const SizedBox.shrink()
                : ValueListenableBuilder(
                    valueListenable: routingViewModel.navRoutingType,
                    builder: (context, routingType, _) => Positioned(
                      right: 0,
                      bottom: 0,
                      left: 0,
                      top: 0,
                      child: _RoutingBottomBar(),
                      // routingType == RouteSearchOptionsMessage.publicTransport
                      //     ? PublicTransportSheet(
                      //         controller: mapViewModel.controller,
                      //       )
                      //     : const _RoutingBottomBar(),
                    ),
                  );
          },
        ),
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
    );
  }
}

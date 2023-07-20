import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../mvvm/map_view_model.dart';
import '../mvvm/point_view_model.dart';
import '../widgets/marker_card_widget.dart';
import '../widgets/search_map_widget.dart';
import '../../../home_page/home_exports.dart' show HomeAppBar, CircleIcon;

import 'map_screen_urbi.dart';

class HomeMap extends StatelessWidget {
  const HomeMap({super.key});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;
    return Stack(
      children: [
        const MapScreenUrbi(),
        Padding(
          padding:
          const EdgeInsets.all(Constants.semiMediumPadding),
          child: Column(
            children: [
              const HomeAppBar(),
              Constants.verticalSpaceSmall,
              ValueListenableBuilder<bool>(
                valueListenable: mapViewModel.viewHomeBottomSheet,
                builder: (_, visible, __) {
                  return visible
                      ? const Align(
                    alignment:
                    AlignmentDirectional.centerStart,
                    child: CircleIcon(
                      icon: IconPath.search,
                      iconColor: AppColor.black,
                    ),
                  )
                      : const SearchMapWidget();
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding:
            const EdgeInsets.all(Constants.semiMediumPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CircleIcon(
                  icon: IconPath.currentLocation,
                  iconColor: AppColor.white,
                  backgroundColor: AppColor.primary900Light,
                ),
                Constants.verticalSpaceSmall,
                const CircleIcon(
                  icon: IconPath.layers,
                  iconColor: AppColor.white,
                  backgroundColor: AppColor.primary900Light,
                ),
                Constants.verticalSpaceSmall,
                ValueListenableBuilder<DgisObjectIdMessage?>(
                  valueListenable: mapViewModel.selectedPointId,
                  builder: (_, selectedPoint, __) {
                    return selectedPoint == null
                        ? const SizedBox()
                        : MarkerMapWidget(
                      pointViewModel: PointViewModel(
                        controller: mapViewModel.controller,
                        point: selectedPoint,
                        webService: sl()
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

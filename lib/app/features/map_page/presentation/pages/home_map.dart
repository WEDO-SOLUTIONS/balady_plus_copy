import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:balady_plus/app/features/map_page/presentation/dialogs/map_layer_dialog.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/indoor_control_widget.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../data/data_sources/point_layers_data.dart';
import '../../data/enums/map_enums.dart';
import '../../data/model/layers.dart';
import '../../constants/constants.dart' as mapConstants;

import 'package:provider/provider.dart';
import '../../data/model/white_lands.dart';
import '../widgets/SearchMapWidget.dart';
import '../widgets/general_card_widget.dart';
import '../widgets/map_cards/lands_legends_map_card.dart';
import '../widgets/map_layer_card.dart';
import '../widgets/search_map_widget.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/utils_exports.dart'
    show AppColor, BlocStatus, CommonFunctions, IconPath;
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../mvvm/layers_gis_view_model.dart';
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
        Container(
          child: Column(
            children: [
              //    const HomeAppBar(),
              SizedBox(
                height: 16,
              ),
              const SearchMapWidget(),
              /*ValueListenableBuilder<bool>(
                  valueListenable: mapViewModel.viewHomeBottomSheet,
                  builder: (_, visible, __) {
                    return visible
                        ? Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: GestureDetector(
                              child: const CircleIcon(
                                icon: IconPath.search,
                                iconColor: AppColor.black,
                              ),
                              onTap: () {
                                mapViewModel.viewHomeBottomSheet.value = false;
                              },
                            ),
                          )
                        : const SearchMapWidget();
                  },
                ),*/
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(Constants.semiMediumPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ValueListenableBuilder<double>(
                  valueListenable: mapViewModel.bottomSheetSize,
                  builder: (_, visible, __) {
                    double bottomSize = mapViewModel.bottomSheetSize.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<bool?>(
                          valueListenable: mapViewModel.showLegend,
                          builder: (_, value, __) {
                            return value == true
                                ? const LandsLegendsMapCard()
                                : SizedBox();
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              bottom: mapViewModel.viewHomeBottomSheet.value ==
                                      true
                                  ? bottomSize
                                  : (mapViewModel.selectedInvetmentPoint.value
                                              ?.type ==
                                          "Investment"
                                      ? mapViewModel.gisSelectedLayer.cardHeight
                                          .toDouble()
                                      : 160)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder<bool?>(
                                  valueListenable: mapViewModel.showLegend,
                                  builder: (_, value, __) {
                                    return Visibility(
                                      visible:
                                          mapViewModel.showLegend != true &&
                                              mapViewModel.gisSelectedLayer ==
                                                  GISMapLayers.BSWhiteParcelS,
                                      child: GestureDetector(
                                        onTap: () {
                                          mapViewModel.showLegend.value = true;
                                          mapViewModel.showLegend
                                              .notifyListeners();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: CircleIcon(
                                            icon: mapConstants
                                                .Constants.infoCircleIcon,
                                            backgroundColor: AppColor.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              if (mapViewModel.bottomSheetSizeFraction.value <=
                                  0.75)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ValueListenableBuilder<Layers?>(
                                        valueListenable:
                                            mapViewModel.layerSelected,
                                        builder: (_, selectedPoint, __) {
                                          return GestureDetector(
                                            onTap: () => showMainLayersDialog(
                                                context, mapViewModel),
                                            child: CircleIcon(
                                              icon: mapViewModel
                                                      .gisSelectedLayer?.icon ??
                                                  mapConstants
                                                      .Constants.layerIcon,
                                              iconColor: Color(0xFF52525B),
                                              backgroundColor: AppColor.white,
                                            ),
                                          );
                                        }),
                                    Constants.verticalSpaceSmall,
                                    GestureDetector(
                                      onTap: () => mapViewModel.onLocationTap(),
                                      child: const CircleIcon(
                                        icon: IconPath.currentLocation,
                                        iconColor: AppColor.white,
                                        backgroundColor:
                                            AppColor.primary900Light,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Constants.verticalSpaceSmall,
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(
                left: Constants.semiMediumPadding,
                right: Constants.semiMediumPadding,
                bottom: Constants.semiSmallPadding),
            child: MapLayerCard(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(
                left: Constants.semiMediumPadding,
                right: Constants.semiMediumPadding,
                bottom: Constants.semiSmallPadding),
            child: ValueListenableBuilder<DgisObjectIdMessage?>(
              valueListenable: mapViewModel.selectedPointId,
              builder: (_, selectedPoint, __) {
                print(selectedPoint);
                print("heree");
                return selectedPoint == null
                    ? const SizedBox()
                    : GeneralMapCardWidget(
                        color: mapViewModel.selectedCategory.value != null
                            ? mapViewModel.selectedCategory.value!
                                .cardIconColor()
                            : Color(0xFFC8A83A),
                        icon: mapViewModel.selectedCategory.value != null
                            ? mapViewModel.selectedCategory.value!
                                .cardIconName()
                            : "",
                        onClose: () {
                          mapViewModel.showDialog();
                        },
                        pointViewModel: PointViewModel(
                            controller: mapViewModel.controller,
                            point: selectedPoint,
                            webService: sl()),
                      );
              },
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: mapViewModel.isSearchLoading,
          builder: (_, visible, __) {
            return visible
                ? Center(child: CustomCircularLoadingWidget())
                : const SizedBox();
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IndoorControl(
              indoorState: mapViewModel.indoorState,
              onLevelTaped: mapViewModel.onLevelTap,
            ),
          ),
        ),
      ],
    );
  }

  void showMainLayersDialog(
      BuildContext context, MapViewModel mapViewModel) async {
    if (mapViewModel.layers.value?.isEmpty ?? true)
      await mapViewModel.getMinLayers();
    if (mapViewModel.layers.value != null)
      BottomSheetDialog.showDraggableSheet(
        isFullHeight: false,
        context,
        child: BottomSheetWithActions(
          title: "plan_option".tr(),
          body: MapLayersDialog(mapModel: mapViewModel),
        ),
      );
    else {
      CommonFunctions.showError("server_error_1".tr());
    }
  }
}

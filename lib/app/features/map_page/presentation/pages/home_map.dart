import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:balady_plus/app/features/map_page/presentation/dialogs/map_layer_dialog.dart';
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
import '../widgets/indoor_control_widget.dart';
import '../widgets/map_cards/compliance_legends_map_card.dart';
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
  const HomeMap({super.key, required this.hideControls});

  final bool hideControls;

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

    return Stack(
      children: [
        const MapScreenUrbi(),
        if (!hideControls)
          const Column(
            children: [
              //    const HomeAppBar(),
              SizedBox(
                height: 16,
              ),
              SearchMapWidget(),
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
        if (!hideControls)
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
                          ValueListenableBuilder<bool?>(
                            valueListenable: mapViewModel.showComplianceLegend,
                            builder: (_, value, __) {
                              return value == true
                                  ? const ComplianceLegendsMapCard()
                                  : SizedBox();
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                bottom:
                                    mapViewModel.viewHomeBottomSheet.value ==
                                            true
                                        ? bottomSize
                                        : (mapViewModel.selectedInvetmentPoint
                                                    .value?.type ==
                                                "Investment"
                                            ? mapViewModel
                                                .gisSelectedLayer.cardHeight
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
                                            mapViewModel.gisSelectedLayer ==
                                                GISMapLayers.BSWhiteParcelS,
                                        child: GestureDetector(
                                          onTap: () {
                                            mapViewModel.showLegend.value =
                                                !(mapViewModel
                                                        .showLegend.value ??
                                                    false);
                                            mapViewModel.showLegend
                                                .notifyListeners();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: CircleIcon(
                                              icon: mapViewModel
                                                          .showLegend.value ==
                                                      true
                                                  ? mapConstants
                                                      .Constants.closeCircleIcon
                                                  : mapConstants
                                                      .Constants.infoCircleIcon,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                ValueListenableBuilder<bool?>(
                                    valueListenable:
                                        mapViewModel.showComplianceLegend,
                                    builder: (_, value, __) {
                                      return Visibility(
                                        visible: mapViewModel
                                                .gisSelectedLayer ==
                                            GISMapLayers
                                                .BSAimtithalBuildingsCertificateL,
                                        child: GestureDetector(
                                          onTap: () {
                                            mapViewModel.showComplianceLegend
                                                .value = !(mapViewModel
                                                    .showComplianceLegend
                                                    .value ??
                                                false);
                                            mapViewModel.showComplianceLegend
                                                .notifyListeners();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: CircleIcon(
                                              icon: mapViewModel
                                                          .showComplianceLegend
                                                          .value ==
                                                      true
                                                  ? mapConstants
                                                      .Constants.closeCircleIcon
                                                  : mapConstants
                                                      .Constants.infoCircleIcon,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                if (mapViewModel
                                        .bottomSheetSizeFraction.value <=
                                    0.75)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                                        .gisSelectedLayer
                                                        ?.icon ??
                                                    mapConstants
                                                        .Constants.layerIcon,
                                                iconColor:
                                                    AppColor.primary900Light,
                                                backgroundColor: AppColor.white,
                                              ),
                                            );
                                          }),
                                      Constants.verticalSpaceSmall,
                                      Column(
                                        children: [
                                          ValueListenableBuilder<
                                                  MapAppearanceMessage?>(
                                              valueListenable: mapViewModel
                                                  .mapAppearanceMessage,
                                              builder: (_, mapAppearanceMessage,
                                                  __) {
                                                return GestureDetector(
                                                  onTap: () => mapViewModel
                                                      .onChangeTheme(),
                                                  child: CircleIcon(
                                                    icon: mapAppearanceMessage ==
                                                            MapAppearanceMessage
                                                                .night
                                                        ? IconPath
                                                            .mapAppearnaceDay
                                                        : IconPath
                                                            .mapAppearnaceNight,
                                                    iconColor:
                                                        mapAppearanceMessage ==
                                                                MapAppearanceMessage
                                                                    .night
                                                            ? AppColor.white
                                                            : AppColor
                                                                .primary900Light,
                                                    backgroundColor:
                                                        mapAppearanceMessage ==
                                                                MapAppearanceMessage
                                                                    .night
                                                            ? AppColor
                                                                .primary900Light
                                                            : AppColor.white,
                                                  ),
                                                );
                                              }),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                mapViewModel.onLocationTap(),
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
        if (!hideControls)
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
        if (!hideControls)
          ValueListenableBuilder<bool>(
            valueListenable: mapViewModel.isSearchLoading,
            builder: (_, visible, __) {
              return visible
                  ? Center(child: CustomCircularLoadingWidget())
                  : const SizedBox();
            },
          ),
        if (!hideControls)
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
        //   dialogKeyName: DialogName.selectGISLayers,
        //  currentRouteName: "HomePage",
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

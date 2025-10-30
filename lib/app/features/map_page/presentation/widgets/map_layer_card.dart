import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_item.dart';
import 'package:balady_plus/app/features/map_page/data/enums/map_enums.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/map_cards/digging_map_card.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/resturant_card_widget.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../data/model/building_compliance_certificate.dart';
import '../../data/model/divisional_chart_boundaries.dart';
import '../../data/model/excavations.dart';
import '../../data/model/investment_details_response.dart';
import '../../data/model/investment_sites.dart';
import '../../data/model/resturant_model.dart';
import '../../data/model/white_lands.dart';
import '../mvvm/map_view_model.dart';
import '../mvvm/point_view_model.dart';
import 'event_card_widget.dart';
import 'map_cards/ImtethalMapCard_map_card.dart';
import 'map_cards/investment_map_card.dart';
import 'map_cards/land_map_card.dart';
import 'map_cards/lands_legends_map_card.dart';
import 'map_cards/oppotunity_card.dart';
import 'map_cards/rental_map_card.dart';
import 'map_cards/white_land_map_card.dart';
import 'marker_card_widget.dart';

class MapLayerCard extends StatelessWidget {
  const MapLayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

      switch (mapViewModel.gisSelectedLayer) {
        case GISMapLayers.Digging:
          return ValueListenableBuilder<Excavations?>(
            valueListenable: mapViewModel.selectedDiggingPoint,
            builder: (_, selectedPoint, __) {
              return selectedPoint == null
                  ? const SizedBox()
                  : DiggingMapCard(
                      data: mapViewModel.selectedDiggingPoint.value!,
                      onClose: () {
                        mapViewModel.showDialog();
                      });
            },
          );
        case GISMapLayers.Opportunities:
          return ValueListenableBuilder<InvestmentSites?>(
            valueListenable: mapViewModel.selectedInvetmentPoint,
            builder: (_, selectedPoint, __) {
              return mapViewModel.selectedInvetmentPoint.value != null
                  ? MapCard(
                      activityId: selectedPoint?.MAIN_ACTIVITY_NAME ?? "",
                      desc: selectedPoint?.description ?? "",
                      price: (selectedPoint?.DOCUMENTVALUE != null &&
                              selectedPoint?.DOCUMENTVALUE?.toString() != "")
                          ? (selectedPoint?.DOCUMENTVALUE.toString() ?? "")
                          : selectedPoint?.DAILYLEASECOST.toString() ?? "",
                      area: selectedPoint?.SITEAREA.toString() ?? "",
                      mainActivcity: selectedPoint?.MAIN_ACTIVITY_NAME ?? "",
                      duration: selectedPoint?.BIDENDDATE ?? "",
                      type: selectedPoint?.TYPE ?? "",
                      distance: "",
                      subMunicipality: selectedPoint?.SUBMUNICIPALITY_ID ?? "",
                      location: selectedPoint?.LOCATIONLISTSTRING,
                      entityLogo: "",
                      bidEndDate: selectedPoint?.BIDENDDATE,
                      isEntity: false,
                      onPress: () async {
                        if (selectedPoint?.TYPE == "TemporaryRental") {
                          // await mapViewModel.getTempRentalDetails(
                          //      "02-21-003709-106", "TempRental");

                          await mapViewModel.getTempRentalDetails(
                              selectedPoint!.ID!, "TempRental");
                        } else {
                          //"01-22-003709-21394"
                          await mapViewModel.getInvestmentDetails(
                              selectedPoint!.OPPORTUNITYNUMBER!, "Investment");
                        }
                      },
                      onClose: () {
                        mapViewModel.showDialog();
                      })
                  : Container();
              return mapViewModel.selectedInvetmentPoint.value != null
                  ? mapViewModel.selectedInvetmentPoint.value!.TYPE ==
                          "Investment"
                      ? InvestmentMapCard(
                          data: mapViewModel.selectedInvetmentPoint.value!,
                          onClose: () {
                            mapViewModel.showDialog();
                          })
                      : RentalMapCard(
                          data: mapViewModel.selectedInvetmentPoint.value!,
                        )
                  : Container();
            },
          );

        case GISMapLayers.BSAimtithalBuildingsCertificateL:
          return ValueListenableBuilder<BuildingComplianceCertificate?>(
            valueListenable: mapViewModel.selectedImtethalPoint,
            builder: (_, selectedPoint, __) {
              return selectedPoint == null
                  ? const SizedBox()
                  : ImtethalMapCard(
                      data: mapViewModel.selectedImtethalPoint.value!,
                      onClose: () {
                        mapViewModel.showDialog();
                      });
            },
          );

        case GISMapLayers.Resturants:
        case GISMapLayers.cityPlaces:
        case GISMapLayers.Events:
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<ResturantModel?>(
                valueListenable: mapViewModel.selectedResturantPoint,
                builder: (_, selectedPoint, __) {
                  return selectedPoint == null
                      ? const SizedBox()
                      : ResturantMapCardWidget(
                          data: mapViewModel.selectedResturantPoint.value!,
                          onClose: () {
                            mapViewModel.showDialog();
                          });
                },
              ),
              ValueListenableBuilder<SearchEventsItem?>(
                valueListenable: mapViewModel.selectedEventPoint,
                builder: (_, selectedPoint, __) {
                  return selectedPoint == null
                      ? const SizedBox()
                      : EventMapCardWidget(
                          data: mapViewModel.selectedEventPoint.value!,
                          onClose: () {
                            mapViewModel.showDialog();
                          });
                },
              )
            ],
          );

        case GISMapLayers.BSWhiteParcelS:
          return ValueListenableBuilder<WhiteLands?>(
            valueListenable: mapViewModel.selectedWhiteLands,
            builder: (_, selectedPoint, __) {
              return selectedPoint == null
                  ? const SizedBox()
                  : WhiteLandMapCard(
                      municipality: selectedPoint.MUNNAME,
                      subMunicipality: selectedPoint.STREETNAME,
                      parcelNo: selectedPoint.PARCELCODE,
                      stageNo: selectedPoint.PHASE,
                      onClose: () {
                        mapViewModel.showDialog();
                      });
            },
          );

        case GISMapLayers.CadastralParcelsLand:
          return ValueListenableBuilder<DivisionalChartBoundaries?>(
            valueListenable: mapViewModel.selectedLands,
            builder: (_, selectedPoint, __) {
              return selectedPoint == null
                  ? const SizedBox()
                  : LandMapCard(
                      municipality: "",
                      subMunicipality: "",
                      BLOCK_ID: selectedPoint.BLOCK_ID,
                      SUBDIVISIONPARCELNUMBER:
                          selectedPoint.SUBDIVISIONPARCELNUMBER,
                      SUBDIVISIONPLAN_ID: selectedPoint.SUBDIVISIONPLAN_ID,
                      onClose: () {
                        mapViewModel.showDialog();
                      });
            },
          );

        default:
          return Container();
      }
    });
  }
}

String getBidEndDate(int? value) {
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(value!);

  var format = new DateFormat("yMd");

  var dateString = format.format(date);

  return dateString;
}

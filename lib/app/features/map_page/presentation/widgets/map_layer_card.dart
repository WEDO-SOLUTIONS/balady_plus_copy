import 'package:balady_plus/app/features/map_page/data/enums/map_enums.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/map_cards/digging_map_card.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../data/model/building_compliance_certificate.dart';
import '../../data/model/excavations.dart';
import '../mvvm/map_view_model.dart';
import '../mvvm/point_view_model.dart';
import 'general_card_widget.dart';
import 'map_cards/ImtethalMapCard_map_card.dart';
import 'map_cards/investment_map_card.dart';
import 'map_cards/lands_legends_map_card.dart';
import 'map_cards/rental_map_card.dart';
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
          return ValueListenableBuilder<Excavations?>(
            valueListenable: mapViewModel.selectedDiggingPoint,
            builder: (_, selectedPoint, __) {
              return mapViewModel.selectedInvetmentPoint.value != null
                  ? mapViewModel
                              .selectedInvetmentPoint.value!.opportunityType ==
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

        default:
          return Container();
      }
    });
  }
}

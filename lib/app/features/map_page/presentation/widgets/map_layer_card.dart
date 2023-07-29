import 'package:balady_plus/app/features/map_page/data/enums/map_enums.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/map_cards/digging_map_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mvvm/map_view_model.dart';

class MapLayerCard extends StatelessWidget {
  const MapLayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

      switch (mapViewModel.gisSelectedLayer) {
        case GISMapLayers.Digging:
          return mapViewModel.selectedDiggingPoint.value != null
              ? DiggingMapCard(data: mapViewModel.selectedDiggingPoint.value!)
              : Container();
        default:
          return Container();
      }
    });
  }
}

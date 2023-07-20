import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:dgis_map/library.dart';
import 'package:provider/provider.dart';


class MapScreenUrbi extends StatelessWidget {
  const MapScreenUrbi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

    return DgisMap(
      androidUseExpensive: true,
      onMapCreated: (DgisMapController controller) async {
        await mapViewModel.initialize(controller);
      },
    );

  }
}

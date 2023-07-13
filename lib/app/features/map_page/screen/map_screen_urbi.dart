import 'package:flutter/material.dart';
import 'package:dgis_map/library.dart';

import '../constants/constants.dart';

class MapScreenUrbi extends StatelessWidget {
  const MapScreenUrbi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DgisMap(
      androidUseExpensive: true,
      onMapCreated: (DgisMapController controller) async {
        final result = await controller.initialize();
        if (result.wasInitialized) {
          await controller.loadStyles(Constants.mapStyle);
          await controller.overrideLocales(["ar-SA"]);
        }
      },
    );
  }
}

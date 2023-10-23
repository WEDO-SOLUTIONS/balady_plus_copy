import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/features/landing/layers_sheet.dart';

import 'map_control.dart';

class LayersControl extends StatelessWidget {
  const LayersControl({
    super.key,
    required this.layerState,
  });

  final GlobalKey<LayersSheetState> layerState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        layerState.currentState?.expand();
      },
      child: MapControl(
        SvgPicture.asset(
          "assets/icons/svg/ic_control_layers.svg",
          semanticsLabel: 'MinApps Screen',
          package: "mapness",
        ),
      ),
    );
  }
}

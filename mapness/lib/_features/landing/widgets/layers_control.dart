import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/app/routes/esri_layers.dart';

import '../../../shared/ui/buttons/map_button.dart';

class LayersControl extends ConsumerWidget {
  const LayersControl({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapButton(
      onTap: () {
        // var state = ref.read(layersControlsProvider);
        // ref.watch(layersControlsProvider.notifier)
        //     .update(visible: !state.layersVisible);
        EsriLayersRoute.open(context);

      },
      child: SvgPicture.asset(
        "assets/icons/svg/ic_control_layers.svg",
        semanticsLabel: 'MinApps Screen',
        package: "mapness",
      ),
    );
  }
}

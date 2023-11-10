import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';

import 'map_control.dart';

class LayersControl extends ConsumerWidget {
  const LayersControl({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapControl(
      onTap: () {
        ref
            .watch(mapControlsProvider.notifier)
            .update(MapControlsStateLayers());
      },
      child: SvgPicture.asset(
        "assets/icons/svg/ic_control_layers.svg",
        semanticsLabel: 'MinApps Screen',
        package: "mapness",
      ),
    );
  }
}

import 'package:balady_uikit/icons/app_icons.dart';
import 'package:balady_uikit/icons/baladi_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/esri_layers.dart';

import '../../../shared/ui/buttons/map_button.dart';

class LayersControl extends ConsumerWidget {
  const LayersControl({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => MapButton(
      onTap: () => EsriLayersRoute.open(context),
      child: const AppIcons(BaladyIcons.Layers));
}

import 'package:balady_uikit/core/icons/app_icons.dart';
import 'package:balady_uikit/core/icons/system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/esri_layers.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class LayersControl extends ConsumerWidget {
  const LayersControl({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => MapButton(
        onTap: () {
          Metrics.logEventAdvanced(
            MetricsConstants.exploreKeys.layersIcon,
            action: MetricAction.tap.name,
            group: MetricsConstants.exploreTag,
          );

          EsriLayersRoute.open(context);
        },
        child: const AppIcons(iconData: SystemIcons.layers),
      );
}

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/icons/app_icons.dart';
import 'package:balady_uikit/core/icons/system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class LayersControl extends ConsumerWidget {
  const LayersControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MapButton(
    onTap: () {
      Metrics.logEventAdvanced(
        MetricsConstants.exploreKeys.layersIcon,
        action: MetricAction.tap.name,
        group: MetricsConstants.exploreTag,
      );

      context.router.push(const LayersSheetRoute());
    },
    child: AppIcons(iconData: SystemIcons.layers, color: context.colors.foregroundDefault),
  );
}

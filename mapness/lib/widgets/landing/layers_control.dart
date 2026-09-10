import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/icons/app_icons.dart';
import 'package:balady_uikit/core/icons/system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/pages/landing/landing_page.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:sheetify/multi_state_sheet/state_snapping/sheet_state_mapper.dart';

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
      ref.read(bottomSheetControllerProvider).controller?.setState(ThreeStateSheet.hidden, duration: Duration.zero);
      context.router.push(const LayersSheetRoute());
    },
    semanticsLabel: context.l10n.layersOnTheMap,
    child: AppIcons(iconData: SystemIcons.layers, color: context.colors.foregroundDefault),
  );
}

import 'package:balady_uikit/balady_uikit.dart' hide MapButton;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

/// Opens [ReportRoadEventMapSelectRoute] to let the user pick a map location for
/// a new road event.
class ReportRoadEventMapSelectControl extends ConsumerWidget {
  const ReportRoadEventMapSelectControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double iconSize = 24;

    return MapButton(
      semanticsLabel: context.l10n.roadEventReportButton,
      onTap: () => _onTap(ref),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(GeneralIcons.warning, size: iconSize, color: context.colors.errorDefault),
      ),
    );
  }

  Future<void> _onTap(WidgetRef ref) async {
    await ref.read(appRouterProvider).push(const ReportRoadEventMapSelectRoute());
  }
}

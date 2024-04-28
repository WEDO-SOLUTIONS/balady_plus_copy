import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet_wrapper.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaContinue extends ConsumerWidget {
  final VoidCallback onTap;
  const EtaContinue({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eta = ref.watch(pathNavEtaProvider);
    if (eta == null) {
      return const SizedBox();
    }
    return EtaSheetWrapper(
      isExpanded: false,
      onBgTap: () {},
      child: GestureDetector(
        onTap: onTap,
        child: BaseRoadPanel(
          roadPanelModel: RoadPanelModelContinue(
            distanceChild: NaviChildModel(
              title: eta.distanceEta,
              description: eta.distanceEtaUnits.getDescription(context),
            ),
            drivingChild: NaviChildModel(
              title: eta.timeEtaUnits.getDescription(context),
              description: eta.timeEta,
            ),
            title: context.l10n.continueTrip,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mapness/entities/path_nav/models/path_nav_eta.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/path_nav/lib/eta_info_widget.dart';

class PathNavEtaWidget extends StatelessWidget {
  final PathNavEta? eta;

  const PathNavEtaWidget({
    super.key,
    required this.eta,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        EtaInfoWidget(title: eta?.distanceEta, subtitle: eta?.distanceEtaUnits),
        const SizedBox(width: 4),
        EtaInfoWidget(title: eta?.arrivalTime, subtitle: context.l10n.arrival),
        const SizedBox(width: 4),
        EtaInfoWidget(title: eta?.timeEta, subtitle: eta?.timeEtaUnits),
      ],
    );
  }
}

import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/path_nav/ui/eta_sheet_wrapper.dart';

import 'layout_size_wrapper.dart';

class EtaContinue extends ConsumerWidget {
  final VoidCallback onTap;
  final OnWidgetSizeChange onSizeChanged;
  const EtaContinue({
    required this.onTap,
    required this.onSizeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eta = ref.watch(pathNavEtaProvider);
    if (eta == null) {
      return const SizedBox();
    }

    final media = MediaQuery.of(context);
    double bottomPadding = media.padding.bottom;

    if (Platform.isAndroid) {
      bottomPadding += Spacing.$6x;
    }

    return EtaSheetWrapper(
      isExpanded: false,
      onSizeChanged: onSizeChanged,
      child: Padding(
        padding: EdgeInsets.only(
          left: Spacing.$4x,
          right: Spacing.$4x,
          bottom: bottomPadding,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: BaseRoadPanel(
            roadPanelModel: RoadPanelModelContinue(
              distanceChild: NaviChildModel(
                title: eta.distanceEta,
                description: eta.distanceEtaUnits.getDescription(context),
              ),
              drivingChild: NaviChildModel(
                title: eta.timeEta,
                description: eta.timeEtaUnits.getDescription(context),
              ),
              title: context.l10n.continueTrip,
            ),
          ),
        ),
      ),
    );
  }
}

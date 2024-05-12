import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet_wrapper.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'layout_size_wrapper.dart';

class EtaFinished extends ConsumerStatefulWidget {
  final VoidCallback onEndTripPressed;
  final VoidCallback onBuildAnotherRoutePressed;
  final OnWidgetSizeChange onSizeChanged;
  const EtaFinished({
    required this.onEndTripPressed,
    required this.onBuildAnotherRoutePressed,
    required this.onSizeChanged,
    super.key,
  });

  @override
  ConsumerState<EtaFinished> createState() => _EtaFinishedState();
}

class _EtaFinishedState extends ConsumerState<EtaFinished> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) => EtaSheetWrapper(
        isExpanded: _isExpanded,
        onSizeChanged: widget.onSizeChanged,
        child: BaseRoadPanel(
          roadPanelModel: RoadPanelModelArrived(
            enabledHeader: _isExpanded,
            title: context.l10n.youArrived,
            onTapBurger: toggle,
            buttons: [
              AppButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: NumericBase.$4x),
                buttonColorScheme: ButtonColorScheme.primary,
                primaryLabel: context.l10n.endTrip,
                onTap: widget.onEndTripPressed,
              ),
              AppButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: NumericBase.$4x),
                buttonColorScheme: ButtonColorScheme.tertiary,
                primaryLabel: context.l10n.buildAnotherRoute,
                onTap: widget.onBuildAnotherRoutePressed,
              ),
            ],
          ),
        ),
      );

  void toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

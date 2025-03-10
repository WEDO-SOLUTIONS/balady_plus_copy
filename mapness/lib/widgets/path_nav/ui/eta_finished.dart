import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/path_nav/ui/eta_sheet_wrapper.dart';

import 'layout_size_wrapper.dart';

class EtaFinished extends ConsumerStatefulWidget {
  final VoidCallback onEndTripPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onBuildAnotherRoutePressed;
  final OnWidgetSizeChange onSizeChanged;
  final ValueNotifier<bool> expansionNotifier;

  const EtaFinished({
    required this.onEndTripPressed,
    required this.onBuildAnotherRoutePressed,
    required this.onSizeChanged,
    required this.expansionNotifier,
    required this.onSearchPressed,
    super.key,
  });

  @override
  ConsumerState<EtaFinished> createState() => _EtaFinishedState();
}

class _EtaFinishedState extends ConsumerState<EtaFinished> {
  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: widget.expansionNotifier,
        builder: (context, value, child) => EtaSheetWrapper(
          isExpanded: value,
          onSizeChanged: widget.onSizeChanged,
          child: BaseRoadPanel(
            roadPanelModel: RoadPanelModelArrived(
              onSearchTap: widget.onSearchPressed,enabledHeader: value,
              title: context.l10n.youArrived,
              onTapBurger: toggle,
              buttons: [
                AppButton(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                  buttonColorScheme: ButtonColorScheme.primary,
                  primaryLabel: context.l10n.endTrip,
                  onTap: widget.onEndTripPressed,
                ),
                AppButton(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                  buttonColorScheme: ButtonColorScheme.tertiary,
                  primaryLabel: context.l10n.buildAnotherRoute,
                  onTap: widget.onBuildAnotherRoutePressed,
                ),
              ],
              onSearchTap: () {},
            ),
          ),
        ),
      );

  void toggle() {
    final _isExpanded = widget.expansionNotifier.value;
    widget.expansionNotifier.value = !_isExpanded;
  }
}

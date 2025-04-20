import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/measure_size.dart';
import 'package:mapness/widgets/path_nav/ui/eta_sheet_wrapper.dart';

class EtaFinished extends ConsumerStatefulWidget {
  final VoidCallback onEndTripPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback? onTapRoute;
  final VoidCallback onBuildAnotherRoutePressed;
  final OnWidgetSizeChange onSizeChanged;
  final ValueNotifier<bool> expansionNotifier;

  const EtaFinished({
    required this.onEndTripPressed,
    required this.onBuildAnotherRoutePressed,
    required this.onSizeChanged,
    required this.expansionNotifier,
    required this.onSearchPressed,
    this.onTapRoute,
    super.key,
  });

  @override
  ConsumerState<EtaFinished> createState() => _EtaFinishedState();
}

class _EtaFinishedState extends ConsumerState<EtaFinished> {
  @override
  Widget build(BuildContext context) {
    final landscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom + (Platform.isAndroid ? Spacing.$5x : 0.0);

    return ValueListenableBuilder(
      valueListenable: widget.expansionNotifier,
      builder: (context, isExpanded, child) => EtaSheetWrapper(
        onSizeChanged: widget.onSizeChanged,
        child: BaseRoadPanel(
          roadPanelModel: RoadPanelModelArrived(
            padding: (!landscape && !isExpanded)
                ? EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: bottomPadding)
                : EdgeInsets.only(bottom: !isExpanded ? bottomPadding : 0.0),
            isLeadingIconAvailable: !landscape,
            onSearchTap: widget.onSearchPressed,
            enabledHeader: isExpanded,
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
            onTapRoute: widget.onTapRoute,
          ),
        ),
      ),
    );
  }

  void toggle() {
    final _isExpanded = widget.expansionNotifier.value;
    widget.expansionNotifier.value = !_isExpanded;
  }
}

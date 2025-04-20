import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/complience_building_legend.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/traffic_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';

class NaviSearchSheetControls extends ConsumerStatefulWidget {
  final uikit.StatefulBottomSheetController scrollController;

  const NaviSearchSheetControls(
    this.scrollController, {
    super.key,
  });

  @override
  ConsumerState<NaviSearchSheetControls> createState() => _NaviSearchSheetControlsState();
}

class _NaviSearchSheetControlsState extends ConsumerState<NaviSearchSheetControls> {
  late ValueNotifier<double> _interpolationNotifier;

  @override
  void initState() {
    super.initState();
    _interpolationNotifier = ValueNotifier(widget.scrollController.interpolation);
    widget.scrollController.addListener(update);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(update);
    _interpolationNotifier.dispose();
    super.dispose();
  }

  void update() {
    _interpolationNotifier.value = widget.scrollController.interpolation;
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<double>(
        valueListenable: _interpolationNotifier,
        builder: (context, interpolation, __) => SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Expanded(
                  child: OverflowBox(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: uikit.Spacing.$3x,
                        top: uikit.Spacing.$3x,
                        right: uikit.Spacing.$3x,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const LayersControl(),
                            const SizedBox(height: uikit.Spacing.$2x),
                            const TrafficControl(),
                            const Spacer(),
                            const ZoomControl(),
                            const Spacer(),
                            const CompassControl(),
                            const SizedBox(height: uikit.Spacing.$2x),
                            ComplianceBuildingLegend(),
                            const SizedBox(height: uikit.Spacing.$2x),
                            const FollowControl(),
                            uikit.Spacing.$4x.heightBox,
                            SizedBox(
                              height: widget.scrollController.state == uikit.ThreeStateBottomSheet.hidden
                                  ? uikit.Spacing.$3x * (1 - interpolation)
                                  : 0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

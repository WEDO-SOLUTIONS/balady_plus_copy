import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/complience_building_legend.dart';
import 'package:mapness/_features/landing/widgets/eta_sharing_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class MapDashboardControls extends ConsumerStatefulWidget {
  final uikit.BottomSheetScrollController scrollController;

  const MapDashboardControls(
    this.scrollController, {
    super.key,
  });

  @override
  ConsumerState<MapDashboardControls> createState() => _MapDashboardControlsState();
}

class _MapDashboardControlsState extends ConsumerState<MapDashboardControls> {
  late double _bottomPadding;
  late final ValueNotifier<uikit.ThreeStateBottomSheet> _notifierStateType;


  @override
  void initState() {
    super.initState();
    _bottomPadding = widget.scrollController.sheetHeight;
    _notifierStateType = ValueNotifier(widget.scrollController.state);

    widget.scrollController.addListener(update);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(update);
    super.dispose();
  }

  void update() {
    if (widget.scrollController.state != _notifierStateType.value && widget.scrollController.interpolation == 0) {
      setState(() {
        _notifierStateType.value =  widget.scrollController.state;
        _bottomPadding = widget.scrollController.sheetHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hideControls = widget.scrollController.state == uikit.ThreeStateBottomSheet.open &&
        widget.scrollController.interpolation > 0.5;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: IgnorePointer(
        ignoring: hideControls,
        child: SafeArea(
          bottom: false,
          child: Visibility(
            visible: !hideControls,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Expanded(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: widget.scrollController.viewportHeight > _bottomPadding + 200 ? 1 : 0,
                      child: OverflowBox(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: uikit.Spacing.$3x,
                            top: uikit.Spacing.$3x,
                            right: uikit.Spacing.$3x,
                            bottom: _bottomPadding,
                          ),
                          child: Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  IndoorControl(),
                                  Spacer(),
                                  EtaSharingControl(),
                                ],
                              ),
                              const Spacer(),
                              Column(
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
                                        ? 56 * (1 - widget.scrollController.interpolation)
                                        : 0,
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }
}

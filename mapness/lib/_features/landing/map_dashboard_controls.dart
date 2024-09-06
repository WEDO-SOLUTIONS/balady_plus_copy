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
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class MapDashboardControls extends ConsumerStatefulWidget {
  final uikit.StatefulBottomSheetController scrollController;

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
  final int _quickFilters = 64;
  final int _paddingWithBottomSheet = 12;

  @override
  void initState() {
    super.initState();
    _notifierStateType = ValueNotifier(widget.scrollController.state);
    widget.scrollController.addListener(_update);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (widget.scrollController.state != _notifierStateType.value && widget.scrollController.interpolation == 0) {
      _notifierStateType.value = widget.scrollController.state;

      setState(() {
        if (widget.scrollController.state == uikit.ThreeStateBottomSheet.hidden) {
          _bottomPadding = widget.scrollController.sheetHeight + _quickFilters;
        } else {
          _bottomPadding = widget.scrollController.sheetHeight + _paddingWithBottomSheet;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool visibleControls = widget.scrollController.state == uikit.ThreeStateBottomSheet.expanded;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        bottom: false,
        child: Visibility(
          visible: !visibleControls,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Expanded(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              const IndoorControl(),
                              const Spacer(),
                              const EtaSharingControl(),
                              uikit.Spacing.$4x.heightBox,
                              SizedBox(
                                height: widget.scrollController.state == uikit.ThreeStateBottomSheet.hidden
                                    ? 56 * (1 - widget.scrollController.interpolation)
                                    : 0,
                              )
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
                              if (widget.scrollController.state == uikit.ThreeStateBottomSheet.hidden)
                                const ZoomControl(),
                              const Spacer(),
                              const CompassControl(),
                              const SizedBox(height: uikit.Spacing.$2x),
                              ComplianceBuildingLegend(),
                              const SizedBox(height: uikit.Spacing.$2x),
                              const FollowControl(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

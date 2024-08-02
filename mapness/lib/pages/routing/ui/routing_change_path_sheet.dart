import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

typedef ConfirmReorder = void Function(List<RouteParamsPoint?> points, List<String> labels);

/// This widget is used to change the path order. We use here the [ABRoute] widget to show the points
///
/// We have to pass a lot of parameters to this widget because we need to manipulate
/// the data locally and then send it back to the parent widget
class ChangePathSheet extends StatefulWidget {
  final ConfirmReorder onConfirm;
  final void Function(int) onTap;
  final List<RouteParamsPoint?> points;

  final List<String> labels;
  final VoidCallback onClose;
  final BuildContext externalContext;
  const ChangePathSheet({
    required this.onConfirm,
    required this.onTap,
    required this.points,
    required this.labels,
    required this.onClose,
    required this.externalContext,
    super.key,
  });

  @override
  State<ChangePathSheet> createState() => _ChangePathSheetState();
}

class _ChangePathSheetState extends State<ChangePathSheet> {
  final pointsModels = <ABRouteModel>[];
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.points.length; i++) {
      final labelForMyLocation = widget.labels[i] == widget.externalContext.l10n.myLocation;
      final icon = labelForMyLocation
          ? widget.externalContext.isLTR
              ? TransportIcons.locationFullLTR
              : TransportIcons.locationFullLTR
          : GeneralIcons.bulletCircleSolid;
      final color =
          i == 0 ? widget.externalContext.colorsV2.successActive : widget.externalContext.colorsV2.accentActive;
      pointsModels.add(
        ABRouteModel(title: widget.labels[i], icon: Icon(icon, color: color)),
      );
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const SheetDragger(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.externalContext.l10n.pathChanging,
                    style: widget.externalContext.textStyle.heading2,
                  ),
                  const SizedBox(width: 12),
                  AppButton.close(onTap: widget.onClose),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ABRoute(
                items: pointsModels,
                onReorder: (oldIndex, newIndex) {
                  _onReorder(oldIndex, newIndex);

                  var newIndex_ = newIndex;

                  if (oldIndex < newIndex_) {
                    newIndex_ -= 1;
                  }
                  _swap(pointsModels, oldIndex, newIndex_);
                  setState(() {});
                },
                onTap: (int) {},
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.primary,
                      onTap: () {
                        widget.onConfirm(widget.points, widget.labels);
                      },
                      primaryLabel: widget.externalContext.l10n.set,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  void _onReorder(int oldIndex, int newIndex) {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.onReorder,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );
    var newIndex_ = newIndex;

    if (oldIndex < newIndex_) {
      newIndex_ -= 1;
    }
    setState(() {
      _swap(widget.points, oldIndex, newIndex_);
      _swap(widget.labels, oldIndex, newIndex_);
    });
  }

  void _swap(List items, int oldIndex, int newIndex) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }
}

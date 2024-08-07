import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_point.dart';
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
  final VoidCallback onTap;
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
  final points = <RouteParamsPoint?>[];
  final labels = <String>[];
  @override
  void initState() {
    super.initState();
    points
      ..clear()
      ..addAll(widget.points);
    labels
      ..clear()
      ..addAll(widget.labels);
    _updatePoints();
  }

  void _updatePoints() {
    pointsModels.clear();
    for (int i = 0; i < points.length; i++) {
      final labelForMyLocation = labels[i] == widget.externalContext.l10n.myLocation;
      final icon = labelForMyLocation
          ? widget.externalContext.isLTR
              ? TransportIcons.locationFullLTR
              : TransportIcons.locationFullLTR
          : GeneralIcons.bulletCircleSolid;
      final color =
          i == 0 ? widget.externalContext.colorsV2.successActive : widget.externalContext.colorsV2.accentActive;
      pointsModels.add(
        ABRouteModel(title: labels[i], icon: Icon(icon, color: color)),
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
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$2x),
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
              padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
              child: ABRoute(
                items: pointsModels,
                onReorder: _onReorder,
                onTap: _onTap,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(
                top: Spacing.$2x,
                bottom: Spacing.$3x,
                left: Spacing.$4x,
                right: Spacing.$4x,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.primary,
                      onTap: () {
                        widget.onConfirm(
                          points,
                          pointsModels.map((e) => e.title).toList(),
                        );
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

  /// On reordering the list, swap the items in the list
  void _onReorder(int oldIndex, int newIndex) {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.onReorder,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );
    var newIndex_ = newIndex;

    /// According to the [ReorderableListView] documentation
    /// https://api.flutter.dev/flutter/material/ReorderableListView-class.html
    if (oldIndex < newIndex_) {
      newIndex_ -= 1;
    }

    setState(() {
      _swap(points, oldIndex, newIndex_);
      _swap(pointsModels, oldIndex, newIndex_);
      _swap(labels, oldIndex, newIndex_);
    });
  }

  /// Swap the items in the list
  /// According to the [ReorderableListView] documentation
  /// https://api.flutter.dev/flutter/material/ReorderableListView-class.html
  void _swap(List items, int oldIndex, int newIndex) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }

  /// On tap of the ABRoute widget, show the search route screen
  ///
  /// Here we can change the location of the points
  Future<void> _onTap(int index) async {
    Metrics.logEventAdvanced(MetricsConstants.routesKeys.changeLocation,
        group: MetricsConstants.routesTag,
        action: MetricAction.tap.toString(),
        props: {
          'isMyLocation': labels[index] == context.l10n.myLocation,
        });

    // Callback from the parent widget on tap
    widget.onTap();

    final isMyLocation = labels[index] == context.l10n.myLocation;

    // Show the search route screen and get new value from it
    final value = await RoutingSearchRoute(
      placeholder: index == 0 ? context.l10n.from : context.l10n.to,
      showMyLocation: isMyLocation,
    ).push(context);

    if (value != null && value is RoutePoint) {
      final newPoint = RouteParamsPoint(
        latitude: value.latitude!,
        longitude: value.longitude!,
        objectId: value.objectId,
        entranceId: value.entranceId,
        levelId: value.levelId,
      );
      points[index] = newPoint;
      labels[index] = value.title(context.l10n) ?? labels[index];
      _updatePoints();

      // Don't use setState in [_updatePoints] because it will cause an error during the initState
      setState(() {});
    }
  }
}

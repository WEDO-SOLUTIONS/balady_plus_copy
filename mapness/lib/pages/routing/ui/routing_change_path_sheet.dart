import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

typedef ConfirmReorder = void Function(List<RouteParamsPointWithLabel> points);

/// This widget is used to change the path order. We use here the [ABRoute] widget to show the points
///
/// We have to pass a lot of parameters to this widget because we need to manipulate
/// the data locally and then send it back to the parent widget
class ChangePathSheet extends StatefulWidget {
  final ConfirmReorder onConfirm;
  final VoidCallback onTap;
  final List<RouteParamsPointWithLabel> points;
  final VoidCallback onClose;
  final BuildContext externalContext;
  final GeoPointMessage? myLocation;
  const ChangePathSheet({
    required this.onConfirm,
    required this.onTap,
    required this.points,
    required this.onClose,
    required this.externalContext,
    required this.myLocation,
    super.key,
  });

  @override
  State<ChangePathSheet> createState() => _ChangePathSheetState();
}

class _ChangePathSheetState extends State<ChangePathSheet> {
  final pointsModels = <ABRouteModel>[];
  late final List<RouteParamsPointWithLabel> points;
  @override
  void initState() {
    super.initState();
    points = widget.points;
    _updatePoints();
  }

  // Update [pointsModels] list with the new values from [points] and [labels]
  void _updatePoints() {
    // In async gap we have to check if the widget is mounted to use the context
    if (!widget.externalContext.mounted) {
      return;
    }
    pointsModels.clear();
    final ctx = widget.externalContext;
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final labelForMyLocation = point.label == ctx.l10n.myLocation;

      pointsModels.add(
        ABRouteModel(
          title: point.label,
          isMyLocation: labelForMyLocation,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetDragger(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
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
                startPointSubtitle: context.l10n.startPosition,
                arrivalPointSubtitle: context.l10n.placeOfArrival,
                onReorder: _onReorder,
                onTap: _onTap,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.$3x,
                horizontal: Spacing.$4x,
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  buttonColorScheme: ButtonColorScheme.accentSecondary,
                  size: ButtonSize.large,
                  onTap: () {
                    widget.onConfirm(points);
                  },
                  primaryLabel: widget.externalContext.l10n.set,
                ),
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

    /// According to the [ReorderableListView] documentation
    /// https://api.flutter.dev/flutter/material/ReorderableListView-class.html
    final currentIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;

    setState(() {
      _swap(points, oldIndex, currentIndex);
      _swap(pointsModels, oldIndex, currentIndex);
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
    // In async gap we have to check if the widget is mounted to use the context
    if (!widget.externalContext.mounted) {
      return;
    }
    final l10n = widget.externalContext.l10n;
    Metrics.logEventAdvanced(MetricsConstants.routesKeys.changeLocation,
        group: MetricsConstants.routesTag,
        action: MetricAction.tap.toString(),
        props: {
          'isMyLocation': points[index].label == l10n.myLocation,
        });

    // Callback from the parent widget on tap
    widget.onTap();

    final isMyLocation = points[index].label == l10n.myLocation;
    final isContainsMyLocation = points.map((e) => e.label).contains(l10n.myLocation);

    // Show the search route screen and get new value from it
    final value = await context.router.push(
      RoutingSearchSheetRoute(
        placeholder: index == 0 ? l10n.from : l10n.to,
        showMyLocation: !isMyLocation && !isContainsMyLocation,
      ),
    );

    if (value != null && value is RoutePoint) {
      var latitude = value.latitude;
      var longitude = value.longitude;
      if (value is RoutePointMyLocation && widget.myLocation != null) {
        latitude = widget.myLocation!.latitude;
        longitude = widget.myLocation!.longitude;
      }
      if (longitude != null && latitude != null) {
        final newPoint = RouteParamsPointWithLabel(
          value: RouteParamsPoint(
            latitude: latitude,
            longitude: longitude,
            objectId: value.objectId,
            entranceId: value.entranceId,
            levelId: value.levelId,
          ),
          label: value.title(l10n) ?? points[index].label,
        );
        points[index] = newPoint;
        _updatePoints();

        // Don't use setState in [_updatePoints] because it will cause an error during the initState
        setState(() {});
      }
    }
  }
}

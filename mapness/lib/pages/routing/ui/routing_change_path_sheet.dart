import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';

typedef ConfirmReorder = void Function(List<RouteParamsPointWithLabel> points);

/// This widget is used to change the path order. We use here the [ABRoute] widget to show the points
///
/// We have to pass a lot of parameters to this widget because we need to manipulate
/// the data locally and then send it back to the parent widget
class ChangePathSheet extends ConsumerStatefulWidget {
  final ConfirmReorder onConfirm;
  final VoidCallback onTap;
  final List<RouteParamsPointWithLabel> points;
  final VoidCallback onClose;
  final BuildContext externalContext;
  final GeoPointMessage? myLocation;
  final RouteSearchOptionsMessage navType;

  const ChangePathSheet({
    required this.onConfirm,
    required this.onTap,
    required this.points,
    required this.onClose,
    required this.externalContext,
    required this.myLocation,
    required this.navType,
    super.key,
  });

  @override
  ConsumerState<ChangePathSheet> createState() => _ChangePathSheetState();
}

class _ChangePathSheetState extends ConsumerState<ChangePathSheet> {
  final pointsModels = <ABRouteModel>[];
  late final List<RouteParamsPointWithLabel> points;

  int? _etaSeconds;
  int _etaRequestId = 0;

  int get intermediatePointCount {
    final count = pointsModels.length - 2;
    return count.clamp(0, count);
  }

  @override
  void initState() {
    super.initState();
    // a new list is needed to compare to initial point count on close confirmation
    points = List.of(widget.points);
    _updatePoints();
    _loadEta();
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
      final labelForMyLocation = _isMyLocation(ctx.l10n, point);

      pointsModels.add(ABRouteModel(title: point.label, isMyLocation: labelForMyLocation));
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SheetDragger(),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: Spacing.$4x, end: Spacing.$3x),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.externalContext.l10n.pathChanging,
                style: widget.externalContext.textStyle.heading2.copyWith(color: context.colors.foregroundDefault),
              ),
              const SizedBox(width: 12),
              AppButton.close(onTap: () => _onClose(context)),
            ],
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
            child: SingleChildScrollView(
              child: ABRoute(
                stopByTitle: context.l10n.addStop,
                items: pointsModels,
                startPointSubtitle: context.l10n.startPosition,
                arrivalPointSubtitle: context.l10n.placeOfArrival,
                onReorder: _onReorder,
                onTap: _onTap,
                onDeletePressed: _onDeletePressed,
                onAddPointPressed: _onAddPointPressed(context.colors),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$1x, horizontal: Spacing.$4x),
          child: SizedBox(
            width: double.infinity,
            child: AppButton(
              buttonColorScheme: ButtonColorScheme.accentSecondary,
              size: ButtonSize.large,
              onTap: () {
                widget.onConfirm(points);
              },
              primaryLabel: _buildRouteLabel,
            ),
          ),
        ),
      ],
    ),
  );

  String get _buildRouteLabel {
    final l10n = widget.externalContext.l10n;
    final label = l10n.buildRoute;
    final eta = _etaSeconds;

    if (eta == null) {
      return label;
    }

    return '$label · ${eta.formatDurationShort(l10n)}';
  }

  Future<void> _loadEta() async {
    final requestId = ++_etaRequestId;
    final myLocation = widget.myLocation;
    final resolved = points
        .map(
          (point) =>
              point.value ??
              (myLocation == null
                  ? null
                  : RouteParamsPoint(latitude: myLocation.latitude, longitude: myLocation.longitude)),
        )
        .toList();

    if (resolved.length < 2 || resolved.any((point) => point == null)) {
      _setEta(null, requestId);
      return;
    }

    final controller = ref.read(dgisControllerProvider).value;
    if (controller == null) {
      _setEta(null, requestId);
      return;
    }

    try {
      final result = await controller.findRoute(
        options: widget.navType,
        startPoint: resolved.first!.routeSearchPointMessage,
        finishPoint: resolved.last!.routeSearchPointMessage,
        intermediatePoints: resolved
            .sublist(1, resolved.length - 1)
            .map((point) => point!.routeSearchPointMessage)
            .toList(),
      );

      final durations = result.routes.map((route) => route.duration);
      _setEta(durations.isEmpty ? null : durations.reduce((a, b) => a < b ? a : b).round(), requestId);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      _setEta(null, requestId);
    }
  }

  void _setEta(int? seconds, int requestId) {
    if (!mounted || requestId != _etaRequestId || _etaSeconds == seconds) {
      return;
    }

    setState(() {
      _etaSeconds = seconds;
    });
  }

  void _onClose(BuildContext context) {
    if (points.length != widget.points.length) {
      _showCloseConfirmationDialog(context);
    } else {
      widget.onClose();
    }
  }

  VoidCallback? _onAddPointPressed(AppColorsThemeV3 colors) {
    if (intermediatePointCount >= 10) {
      return null;
    }

    final icon = StopNumbersIcons.fromIndex(intermediatePointCount + 1);
    if (icon == null) {
      return null;
    }

    return () => _selectPoint(
      affixIcon: BaladyInputAffixIcon(icon: icon, iconColor: colors.extra01Default),
    );
  }

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
    _loadEta();
  }

  /// Swap the items in the list
  /// According to the [ReorderableListView] documentation
  /// https://api.flutter.dev/flutter/material/ReorderableListView-class.html
  void _swap(List items, int oldIndex, int newIndex) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }

  bool _isMyLocation(AppLocalizations l10n, RouteParamsPointWithLabel point) => point.label == l10n.myLocation;

  bool _containsMyLocation(AppLocalizations l10n) => points.map((e) => e.label).contains(l10n.myLocation);

  /// On tap of the ABRoute widget, show the search route screen
  ///
  /// Here we can change the location of the points
  Future<void> _onTap(int index) => _selectPoint(index: index);

  // When index is passed the corresponding point will be updated or added as
  // intermediate point otherwise.
  Future<void> _selectPoint({int? index, BaladyInputAffixIcon? affixIcon}) async {
    // In async gap we have to check if the widget is mounted to use the context
    if (!widget.externalContext.mounted) {
      return;
    }
    final l10n = widget.externalContext.l10n;

    if (index != null) {
      final isMyLocation = _isMyLocation(l10n, points[index]);
      Metrics.logEventAdvanced(
        MetricsConstants.routesKeys.changeLocation,
        group: MetricsConstants.routesTag,
        action: MetricAction.tap.toString(),
        props: {'isMyLocation': isMyLocation},
      );
    }

    // Callback from the parent widget on tap
    widget.onTap();

    final placeholder = switch (index) {
      0 => l10n.from,
      null => l10n.intermediatePoint,
      _ => l10n.to,
    };

    // Show the search route screen and get new value from it
    final value = await context.router.push(
      RoutingSearchSheetRoute(
        placeholder: placeholder,
        affixIcon: affixIcon,
        showMyLocation: !_containsMyLocation(l10n),
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
        final label = index != null ? points[index].label : l10n.intermediatePointNumberedName(points.length);

        final newPoint = RouteParamsPointWithLabel(
          value: RouteParamsPoint(
            latitude: latitude,
            longitude: longitude,
            objectId: value.objectId,
            entranceId: value.entranceId,
            levelId: value.levelId,
          ),
          label: value.title(l10n) ?? label,
        );

        // SDK doesn't allow to add the same point twice
        // ignore: always_put_control_body_on_new_line
        if (points.contains(newPoint)) return;

        if (index != null) {
          points[index] = newPoint;
        } else {
          points.insert(points.length - 1, newPoint);
        }
        _updatePoints();

        // Don't use setState in [_updatePoints] because it will cause an error during the initState
        setState(() {});
        _loadEta();
      }
    }
  }

  ValueChanged<int>? get _onDeletePressed {
    // disable point removal if there are only two points or less
    if (points.length < 3) {
      return null;
    }

    return (index) {
      points.removeAt(index);
      _updatePoints();

      // Don't use setState in [_updatePoints] because it will cause an error during the initState
      setState(() {});
      _loadEta();
    };
  }

  Future<void> _showCloseConfirmationDialog(BuildContext context) async {
    final action = Platform.isIOS ? _showIOSCloseConfirmationDialog : _showAndroidCloseConfirmationDialog;
    return action(
      context: context,
      title: context.l10n.routeChangeConfirmationDialogTitle,
      content: context.l10n.routeChangeConfirmationDialogContent,
      confirmText: context.l10n.routeChangeConfirmationDialogConfirmText,
      onConfirm: (dialogContext) {
        Navigator.of(dialogContext).pop();
        widget.onClose();
      },
      cancelText: context.l10n.cancel,
      onCancel: (dialogContext) => Navigator.of(dialogContext).pop(),
    );
  }

  Future<void> _showIOSCloseConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required ValueChanged<BuildContext> onConfirm,
    required String cancelText,
    required ValueChanged<BuildContext> onCancel,
  }) => showCupertinoDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(onPressed: () => onConfirm(dialogContext), child: Text(confirmText)),
        CupertinoDialogAction(isDefaultAction: true, onPressed: () => onCancel(dialogContext), child: Text(cancelText)),
      ],
    ),
  );

  Future<void> _showAndroidCloseConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required ValueChanged<BuildContext> onConfirm,
    required String cancelText,
    required ValueChanged<BuildContext> onCancel,
  }) => showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: () => onCancel(dialogContext), child: Text(cancelText)),
        TextButton(onPressed: () => onConfirm(dialogContext), child: Text(confirmText)),
      ],
    ),
  );
}

part of 'dashboard_control.dart';

/// The various components of [DashboardControl] widget.
enum DashboardSheet {
  /// Corresponds [OnRouteBottomSheet] layer with data from native sdk on route change.
  onResultSheet,

  /// Corresponds [OnResultBottomSheet] layer with end-ride event info .
  onRouteSheet,

  /// Corresponds [OnContinueBottomSheet] layer.
  onContinueSheet,
}

/// The various state options for [DashboardControl] layers.
enum SheetStates {
  /// [DashboardControl] layer is totally invisible.
  /// corresponds to [HIDDEN_STATE] value 0.0;
  hidden,

  /// [DashboardControl] layer is partially visible.
  /// corresponds to controller value 0.15;
  collapsed,

  /// [DashboardControl] layer is visible and fully expanded.
  /// corresponds to [EXPANDED_STATE] value 1.0;
  expanded,
}

/// Enables control over a single [DashboardControl]'s expanded/collapsed/hidden states.
///
/// The controller's [unHide], [hide], [show], [expand] and [collapse] methods cause the
/// the [DashboardControl] to rebuild, so they may not be called from
/// a build method.
class DashboardControlController {
  /// @nodoc
  DashboardControlController.withSheetKeys(
      List<GlobalKey<State<StatefulWidget>>> sheetKeys)
      : sheetKeys = {
          for (var key in DashboardSheet.values)
            key: sheetKeys[DashboardSheet.values.indexOf(key)]
        };

  /// used for access to particular layers of [DashboardControl]
  late Map<DashboardSheet, GlobalKey<State<StatefulWidget>>> sheetKeys;

  /// make [OnResultBottomSheet] totally invisible
  Future<void> hideResultBottomSheet() async =>
      (sheetKeys[DashboardSheet.onResultSheet]!.currentState
              as OnResultBottomSheetState)
          .hide();

  /// make [OnResultBottomSheet] fully visible
  Future<void> showResultBottomSheet({bool closable = true}) async {
    await _collapseRouteBottomSheet();
    _setResultBottomSheetClosable(closable);
    await (sheetKeys[DashboardSheet.onResultSheet]!.currentState
            as OnResultBottomSheetState)
        .expand();
  }

  void _setResultBottomSheetClosable(bool closable) {
    (sheetKeys[DashboardSheet.onResultSheet]!.currentState
            as OnResultBottomSheetState)
        // ignore: invalid_use_of_protected_member
        .setState(() {
      (sheetKeys[DashboardSheet.onResultSheet]!.currentState
              as OnResultBottomSheetState)
          .closable = closable;
    });
  }

  Future<void> _hideRouteBottomSheet() async =>
      (sheetKeys[DashboardSheet.onRouteSheet]!.currentState
              as OnRouteSheetState)
          .hide();

  Future<void> _unHideRouteBottomSheet() async =>
      (sheetKeys[DashboardSheet.onRouteSheet]!.currentState
              as OnRouteSheetState)
          .unHide();

  Future<void> _collapseRouteBottomSheet() async =>
      (sheetKeys[DashboardSheet.onRouteSheet]!.currentState
              as OnRouteSheetState)
          .collapse();

  /// toggle [OnRouteBottomSheet]'s collapsed state
  Future<void> changeStateRouteBottomSheet() async {
    final onRouter = sheetKeys[DashboardSheet.onRouteSheet]!.currentState
        as OnRouteSheetState;
    if (onRouter.sheetState == SheetStates.collapsed) {
      await _expandRouteBottomSheet();
    } else {
      await _collapseRouteBottomSheet();
    }
  }

  Future<void> _expandRouteBottomSheet() async =>
      (sheetKeys[DashboardSheet.onRouteSheet]!.currentState
              as OnRouteSheetState)
          .expand();

  /// make [OnContinueBottomSheet] state fully visible and expanded
  Future<void> expandContinueSheet() async {
    await _collapseRouteBottomSheet();
    await _hideRouteBottomSheet();
    await (sheetKeys[DashboardSheet.onContinueSheet]!.currentState
            as OnContinueBottomSheetState)
        .expand();
  }

  /// make [OnContinueBottomSheet] state totally invisible
  Future<void> hideContinueSheet() async {
    await (sheetKeys[DashboardSheet.onContinueSheet]!.currentState
            as OnContinueBottomSheetState)
        .hide();
    await _unHideRouteBottomSheet();
    await _expandRouteBottomSheet();
  }
}

import 'package:flutter/material.dart';

/// Ниже использованы наработки из [DraggableScrollableSheet]
abstract class DgisDraggableScrollableListener {
  bool get hasOffset;

  /// поле необходимо, чтобы снаружи можно было управлять позицией скролла
  late DgisScrollPosition position;

  void applyUserOffset(double delta);

  void goIdle({bool byUser = false});

  void goBallistic(double velocity);
}

class DgisScrollController extends ScrollController {
  DgisScrollController(this._listener);

  final DgisDraggableScrollableListener _listener;

  @override
  DgisScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) =>
      DgisScrollPosition(
        listener: _listener,
        physics: physics,
        context: context,
        oldPosition: oldPosition,
      );
}

class DgisScrollPosition extends ScrollPositionWithSingleContext {
  DgisScrollPosition({
    required DgisDraggableScrollableListener listener,
    required super.physics,
    required super.context,
    double super.initialPixels,
    super.keepScrollOffset,
    super.oldPosition,
    super.debugLabel,
  }) : _listener = listener {
    _listener.position = this;
  }

  bool get _listShouldScroll => pixels > 0.0;

  final DgisDraggableScrollableListener _listener;

  bool _goIdleByUser = false;

  @override
  // ignore: prefer_expression_function_bodies
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    // We need to provide some extra extent if we haven't yet reached the max or
    // min extents. Otherwise, a list with fewer children than the extent of
    // the available space will get stuck.
    return super.applyContentDimensions(
      minScrollExtent - 0.1,
      maxScrollExtent + 0.1,
    );
  }

  @override
  void applyUserOffset(double delta) {
    if (!_listShouldScroll && (_listener.hasOffset || delta >= 0)) {
      _listener.applyUserOffset(delta);
    } else {
      super.applyUserOffset(delta);
    }
    _goIdleByUser = true;
  }

  @override
  void goBallistic(double velocity) {
    if (_listener.hasOffset) {
      super.goBallistic(0);
      _listener.goBallistic(velocity);
    } else {
      super.goBallistic(velocity);
    }
    _goIdleByUser = true;
  }

  @override
  void goIdle() {
    super.goIdle();
    _listener.goIdle(byUser: _goIdleByUser);
    _goIdleByUser = false;
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet_theme.dart';
import 'package:mapness/shared/ui/bottom_sheet/lib/scroll_listeners.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/disable_overscroll_behavior.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/vertival_scroll_listener.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/widget_size_notifier.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

// Map controls builder type
typedef MapControlsBuilder =
    Widget Function(
      BuildContext context,
      ValueNotifier<double> bottomSheetHeight,
      double biggestHeight,
      double smallestHeight,
    );

// keep growable order
enum Expansion {
  /// does not visible at all
  hidden,

  /// visible only small part
  collapsed,

  /// visible middle part
  middle,

  /// take all available space
  expanded,

  /// for full hide photo
  fullHidePhoto,
}

extension ExpansionUtils on Expansion {
  Expansion next(ScrollDirection direction) {
    switch (this) {
      case Expansion.hidden:
        return direction == ScrollDirection.up ? Expansion.collapsed : Expansion.hidden;
      case Expansion.collapsed:
        return direction == ScrollDirection.up ? Expansion.middle : Expansion.hidden;
      case Expansion.middle:
        return direction == ScrollDirection.up ? Expansion.expanded : Expansion.collapsed;
      case Expansion.fullHidePhoto:
      case Expansion.expanded:
        return direction == ScrollDirection.up ? Expansion.expanded : Expansion.collapsed;
    }
  }

  Expansion getNextExpansion(ScrollDirection direction, Set<Expansion> availableExpansions) {
    Expansion nextExpansion = this;
    do {
      final expansion = nextExpansion.next(direction);

      if (expansion.index == nextExpansion.index) {
        break;
      }
      if (availableExpansions.contains(expansion)) {
        nextExpansion = expansion;
      } else {
        break;
      }
    } while (!availableExpansions.contains(nextExpansion));

    return nextExpansion;
  }
}

enum ScrollDirection { up, down, idle }

class DgisBottomSheet extends StatefulWidget {
  DgisBottomSheet({
    required this.initialExpansion,
    required this.availableExpansions,
    this.collapsedHeight,
    this.body,
    this.actions,
    this.scrollableBody,
    this.middleHeight,
    this.onExpansionChanged,
    this.onVisibleHeightChanged,
    this.printDebugLogs = false,
    this.showHandle = false,
    this.showBarrier = true,
    super.key,
    this.scrollHeader,
    this.hiddenHeight = 0,
    this.controller,
    this.mapControlsBuilder,
    this.borderRadius,
    this.scrollBehavior = const DisabledOverscrollScrollBehavior(),
  }) : assert(
         !availableExpansions.contains(Expansion.collapsed) || collapsedHeight != null && collapsedHeight > 0,
         'You should provide collapsedHeight Expansion.collapsed which should be greater than 0',
       ),
       assert(
         !availableExpansions.contains(Expansion.middle) || middleHeight != null && middleHeight > 0,
         'You should provide middleHeight Expansion.middle which should be greater than 0',
       ),
       assert(
         !availableExpansions.contains(Expansion.collapsed) ||
             !availableExpansions.contains(Expansion.middle) ||
             collapsedHeight! < middleHeight!,
         'CollapsedHeight should be less than middleHeight',
       ),
       assert(body != null || scrollableBody != null, 'You must provide body or scrollableBody'),
       assert(body == null || scrollableBody == null, "You can't provide both body and scrollableBody simultaneously"),
       assert(availableExpansions.isNotEmpty, "AvailableExpansions can't be empty");

  /// Height of the bottom sheet when [Expansion.middle] provided in [availableExpansions]
  /// You can use it to set the height of the bottom sheet on you screen
  final double? middleHeight;
  final double? collapsedHeight;
  final double hiddenHeight;
  final WidgetBuilder? body;
  final DgisBottomSheetController? controller;
  final MapControlsBuilder? mapControlsBuilder;

  /// Appears when bottom sheet is expanded. Pin to the bottom when body scrolls.
  /// Usually contains buttons.
  final Widget? actions;

  /// Widgets that will be displayed at the top, above the scrollable area and handle. I.e. hanlde or buttons.
  /// Dragging not cause body to scroll.
  /// Not supposed to be used for dynamicaly shaped widgets, like map controlls. Use [scrollableBody] with slivers for that.
  final Widget? scrollHeader;
  final ScrollableWidgetBuilder? scrollableBody;
  final Expansion initialExpansion;

  /// shows handle (drag indicator) above bottom sheet
  final bool showHandle;

  /// show barrier (background) when bottom sheet is expanded. May increase fps when backgound is map
  final bool showBarrier;

  /// Set what states is available
  final Set<Expansion> availableExpansions;
  final void Function(Expansion expansion, {bool byUser})? onExpansionChanged;
  final ValueChanged<double>? onVisibleHeightChanged;
  final bool printDebugLogs;
  final ScrollBehavior scrollBehavior;

  /// Set clipper for the scrollable body for design view
  final BorderRadiusGeometry? borderRadius;

  @override
  State<DgisBottomSheet> createState() => _DgisBottomSheetState();
}

class DgisBottomSheetController {
  bool _isAttached = false;
  Expansion? _currentExpansion;

  Expansion? get currentExpansion => _currentExpansion;

  Function(Expansion expansion)? _onAnimate;

  /// for now only one field, so may be replaced with setter, but in future it is planned to add more
  // ignore: use_setters_to_change_properties
  void _link({Function(Expansion expansion)? onAnimate}) {
    _onAnimate = onAnimate;
    _isAttached = true;
  }

  void animateTo(Expansion expansion) {
    assert(_isAttached, 'Controller should be attached to any dgissheet');
    _onAnimate?.call(expansion);
  }

  void dispose() {
    _isAttached = false;
  }
}

class _DgisBottomSheetState extends State<DgisBottomSheet>
    with TickerProviderStateMixin
    implements DgisDraggableScrollableListener {
  static const _velocityFlingThreshold = 1000;
  static const _deltaThreshold = 100;
  final ValueNotifier<double> _bottomSheetHeightListener = ValueNotifier(0);

  double _visibleHeight = 0;

  /// used to make actions appear smooooothly
  double _actionsVisibleHeight = 0;

  @override
  late DgisScrollPosition position;

  double get _backgroundOpacity {
    late double preMaxVisibleHeight;

    if (widget.availableExpansions.length == 1) {
      if (widget.availableExpansions.contains(Expansion.expanded)) {
        return 1;
      } else {
        return 0;
      }
    }

    if (widget.availableExpansions.contains(Expansion.expanded)) {
      if (widget.availableExpansions.contains(Expansion.middle)) {
        preMaxVisibleHeight = widget.middleHeight!;
      } else if (widget.availableExpansions.contains(Expansion.collapsed)) {
        preMaxVisibleHeight = widget.collapsedHeight!;
      } else {
        preMaxVisibleHeight = 0;
      }
    } else {
      return 0;
    }
    _printDebugLog(
      'Calculating background opacity: _visibleHeight=$_visibleHeight, _maxVisibleHeight=$_maxVisibleHeight, preMaxVisibleHeight=$preMaxVisibleHeight',
    );
    return max(0, min(_visibleHeight, _maxVisibleHeight) - preMaxVisibleHeight) /
        (_maxVisibleHeight - preMaxVisibleHeight);
  }

  double _screenHeight = 0;

  double _bodyHeight = 0;

  double get _bottomSheetHeight => _bodyHeight + (widget.showHandle ? 4 : 0);

  double get _maxVisibleHeight {
    var maxVisibleHeight = 0.0;
    if (widget.availableExpansions.contains(Expansion.expanded)) {
      maxVisibleHeight = _screenHeight + 4;
    } else if (widget.availableExpansions.contains(Expansion.middle)) {
      maxVisibleHeight = widget.middleHeight!;
    } else if (widget.availableExpansions.contains(Expansion.collapsed)) {
      maxVisibleHeight = widget.collapsedHeight!;
    } else {
      maxVisibleHeight = _minVisibleHeight;
    }

    return min(maxVisibleHeight, _bottomSheetHeight);
  }

  double get actionsHeight {
    /// I guess that it is possible to find function avoid if's and just map double to proper
    /// numbers. But I was a bit lazy for this
    ///
    /// if less than hidden always return zero
    if (_visibleHeight <= widget.hiddenHeight) {
      return _actionsVisibleHeight;
    }

    /// minimal height of sheet except hidden
    final minStageHeigth = [
      widget.collapsedHeight,
      widget.middleHeight,
      _maxVisibleHeight,
    ].whereNotNull().fold(double.infinity, min);

    /// if greater then nearest available dimension return action height
    if (_visibleHeight >= minStageHeigth) {
      return 0;
    }

    /// if between hidden and min height - interpolate to get smooooothhhh appearance
    return lerpDouble(_actionsVisibleHeight, 0, _visibleHeight / minStageHeigth) ?? 0;
  }

  double get _minVisibleHeight {
    if (widget.availableExpansions.contains(Expansion.hidden)) {
      return widget.hiddenHeight;
    } else if (widget.availableExpansions.contains(Expansion.collapsed)) {
      return widget.collapsedHeight!;
    } else if (widget.availableExpansions.contains(Expansion.middle)) {
      return widget.middleHeight!;
    } else {
      return _maxVisibleHeight;
    }
  }

  AnimationController? _animationController;
  bool _hasActiveAnimation = false;

  void _stopActiveAnimation() {
    if (!_hasActiveAnimation) {
      return;
    }
    final controller = _animationController;
    if (controller != null && controller.isAnimating) {
      controller.stop();
    }
    _hasActiveAnimation = false;
  }

  late DgisScrollController _scrollController;

  @override
  bool get hasOffset => _visibleHeight != _maxVisibleHeight;

  Expansion _expansion = Expansion.hidden;

  Expansion get expansion => _expansion;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _scrollController = DgisScrollController(this);

    assert(
      widget.availableExpansions.contains(widget.initialExpansion),
      'initialExpansion should contains in availableExpansions',
    );

    _scrollController.addListener(() {
      // Calculate if we scroll up for more than 10 pixels
      if (_scrollController.position.pixels > 10) {
        if (_expansion == Expansion.expanded) {
          widget.onExpansionChanged?.call(Expansion.fullHidePhoto, byUser: true);
        }
      } else {
        if (_expansion == Expansion.fullHidePhoto) {
          widget.onExpansionChanged?.call(Expansion.expanded, byUser: true);
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant DgisBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    _printDebugLog('didUpdateWidget');
    _printDebugLog(widget.availableExpansions.toString());
    _printDebugLog(_expansion.toString());

    /// expose callbacks to controller
    widget.controller?._link(onAnimate: setExpansion);

    // Обновляем Expansion только если изменилось что-то связанное с ним
    if (widget.middleHeight == oldWidget.middleHeight &&
        widget.collapsedHeight == oldWidget.collapsedHeight &&
        setsEqual(widget.availableExpansions, oldWidget.availableExpansions)) {
      return;
    }

    if (!widget.availableExpansions.contains(_expansion)) {
      _printDebugLog('availableExpansions not contains current expansion -> update it');
      _stopActiveAnimation();
      setExpansion(_closestExpansionByVisibleHeight(_visibleHeight));
    } else if (_visibleHeightByExpansion(_expansion, oldWidget) != _visibleHeightByExpansion(_expansion)) {
      _printDebugLog('height for current expansion changed -> update it');
      _stopActiveAnimation();
      setExpansion(_expansion);
    }
  }

  @override
  void dispose() {
    _hasActiveAnimation = false;
    _animationController?.dispose();
    _bottomSheetHeightListener.dispose();
    super.dispose();
  }

  static const theme = DgisBottomSheetTheme.defaultTheme;

  @override
  Widget build(BuildContext context) {
    assert(
      _hasActiveAnimation || _visibleHeight >= 0 && _visibleHeight <= _maxVisibleHeight,
      'Visible height=$_visibleHeight should be between 0 and _maxVisibleHeight=$_maxVisibleHeight',
    );

    return Stack(
      children: [
        if (widget.mapControlsBuilder != null)
          widget.mapControlsBuilder!.call(context, _bottomSheetHeightListener, _maxVisibleHeight, _minVisibleHeight),
        Material(
          type: MaterialType.transparency,
          child: ScrollConfiguration(
            behavior: widget.scrollBehavior,
            child: PopScope(
              onPopInvokedWithResult: onPopInvokedWithResult,
              child: Stack(
                children: [
                  if (widget.showBarrier)
                    IgnorePointer(
                      ignoring: _backgroundOpacity == 0,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.availableExpansions.contains(Expansion.hidden)) {
                            // logger.info(
                            //   'On barrier tapped -> hide bottom sheet',
                            //   tags: [LogTag.bottomSheet],
                            // );
                            setExpansion(Expansion.hidden, byUser: true);
                          }
                        },
                        child: Opacity(
                          opacity: _backgroundOpacity,
                          child: Container(color: theme.expandedBackgroundColor),
                        ),
                      ),
                    ),
                  SafeArea(
                    bottom: false,
                    child: LayoutBuilder(
                      builder: (_, constrains) {
                        final newScreenHeight = constrains.maxHeight;
                        if (newScreenHeight != _screenHeight) {
                          _screenHeight = newScreenHeight;
                          _printDebugLog('_screenHeight=$_screenHeight');
                          _printDebugLog('_maxVisibleHeight=$_maxVisibleHeight');

                          _visibleHeight = min(_visibleHeight, _maxVisibleHeight);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            widget.onVisibleHeightChanged?.call(_visibleHeight);
                          });
                          _stopActiveAnimation();
                        }

                        return Stack(
                          children: [
                            Positioned(
                              top: _initialized ? _maxVisibleHeight - _visibleHeight : _screenHeight,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: _screenHeight,
                                alignment: Alignment.bottomCenter,
                                child: _content(),
                              ),
                            ),
                            if (widget.actions != null)
                              Positioned(
                                top: _initialized ? _maxVisibleHeight - _visibleHeight + actionsHeight : _screenHeight,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: _screenHeight,
                                  alignment: Alignment.bottomCenter,
                                  child: WidgetSizeNotifier(
                                    onSizeChanged: (value) => _actionsVisibleHeight = value.height,
                                    child: widget.actions!,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _content() => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      if (widget.showHandle)
        _wrappedWithVerticalScrollListener(
          child: const Padding(padding: EdgeInsets.only(bottom: 4), child: SheetDragger()),
        ),
      Flexible(
        child: Builder(
          builder: (context) => WidgetSizeNotifier(
            onSizeChanged: (size) {
              _bodyHeight = size.height;

              _printDebugLog('onSizeChanged: _bodyHeight=$_bodyHeight');

              if (_initialized) {
                setExpansion(_expansion, animate: false);
              } else {
                _initialized = true;
                setExpansion(widget.initialExpansion);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.scrollHeader != null) _wrappedWithVerticalScrollListener(child: widget.scrollHeader!),
                Expanded(
                  child: ClipRRect(
                    borderRadius: widget.borderRadius ?? BorderRadius.zero,
                    child: widget.scrollableBody == null
                        ? SingleChildScrollView(controller: _scrollController, child: widget.body!(context))
                        : widget.scrollableBody!(context, _scrollController),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // if (widget.actions != null) widget.actions!,
    ],
  );

  Widget _wrappedWithVerticalScrollListener({required Widget child}) => VerticalScrollListener(
    onVerticalDragUpdate: (details) {
      applyUserOffset(details.delta.dy);
    },

    onVerticalDragEnd: (_) => goIdle(byUser: true),
    // ignore: sized_box_for_whitespace
    child: Container(
      width: double.infinity,
      child: Center(child: child),
    ),
  );

  @override
  void applyUserOffset(double delta, {double? scrollOffset}) {
    if (_hasActiveAnimation || widget.availableExpansions.length == 1) {
      return;
    }
    _printDebugLog('_applyUserOffset: Scroll delta = $delta');
    if (delta == 0) {
      return;
    }
    if (delta < 0) {
      _printDebugLog('Scrolling up');
      //Скролим снизу вверх

      if (_visibleHeight < _maxVisibleHeight) {
        _printDebugLog('Scrolling up outer scroll');
        //Скролим внешний скрол вверх
        setState(() {
          _visibleHeight = min(_visibleHeight - delta, _maxVisibleHeight);
          widget.onVisibleHeightChanged?.call(_visibleHeight);
          _printDebugLog('_applyUserOffset new _visibleHeight=$_visibleHeight');
        });
      } else {
        widget.onExpansionChanged?.call(Expansion.fullHidePhoto, byUser: true);
      }
    } else {
      _printDebugLog('Scrolling down');
      //Скролим сверху вниз
      //Скролим внешний скрол вниз
      _printDebugLog('Scroll down outer scroll');
      setState(() {
        _visibleHeight = max(_visibleHeight - delta, _minVisibleHeight);
        widget.onVisibleHeightChanged?.call(_visibleHeight);
        _printDebugLog('_applyUserOffset new _visibleHeight=$_visibleHeight');
      });
    }
  }

  @override
  void goIdle({bool byUser = false}) {
    _printDebugLog('_goIdle. byUser=$byUser');

    Future.delayed(Duration.zero, () {
      if (!_initialized) {
        _printDebugLog('_goIdle. !_initialized -> ignore');
        return;
      }

      if (_hasActiveAnimation) {
        _printDebugLog('_goIdle. hasActiveAnimation -> ignore');
        return;
      }
      setExpansion(_closestExpansionByVisibleHeight(_visibleHeight), byUser: byUser);
    });
  }

  @override
  void goBallistic(double velocity) {
    _printDebugLog('goBallistic: velocity=$velocity');

    if (velocity.abs() < _velocityFlingThreshold) {
      return;
    }

    final nextExpansion = _getNextExpansionForFling(velocity);

    if (nextExpansion != null) {
      setExpansion(nextExpansion, byUser: true);
    }
  }

  Expansion? _getNextExpansionForFling(double velocity) {
    Expansion? expansion;
    final closestExpansion = _closestExpansionByVisibleHeight(_visibleHeight);
    final visibleHeightOfClosestExpansion = _visibleHeightByExpansion(closestExpansion);

    bool upDirection;

    /// флинг вверх
    if (velocity > _velocityFlingThreshold) {
      upDirection = true;
    } else if (velocity < -_velocityFlingThreshold) {
      upDirection = false;
    } else {
      return null;
    }

    if (upDirection && visibleHeightOfClosestExpansion > _visibleHeight) {
      expansion = closestExpansion;
    } else if (!upDirection && visibleHeightOfClosestExpansion < _visibleHeight) {
      expansion = closestExpansion;
    }

    if (expansion == null) {
      var orderedExpansions = Expansion.values;
      if (!upDirection) {
        orderedExpansions = orderedExpansions.reversed.toList();
      }

      for (var i = orderedExpansions.indexOf(closestExpansion) + 1; i < orderedExpansions.length; i++) {
        final candidate = orderedExpansions[i];
        if (widget.availableExpansions.contains(candidate)) {
          expansion = candidate;
          break;
        }
      }
    }

    return expansion;
  }

  Expansion _closestExpansionByVisibleHeight(double visibleHeight) {
    final heights = <MapEntry<Expansion, double>>[];
    for (final expansion in widget.availableExpansions) {
      heights.add(MapEntry(expansion, _visibleHeightByExpansion(expansion)));
    }

    final visibleHeightByExpansion = _visibleHeightByExpansion(_expansion);
    final _delta = (visibleHeightByExpansion - visibleHeight).abs();
    Expansion result;
    if (_delta > _deltaThreshold) {
      if (visibleHeight > visibleHeightByExpansion) {
        heights.sort((h1, h2) => h1.value.compareTo(h2.value));
        final firstWhere = heights.firstWhere((element) => element.value > visibleHeightByExpansion);
        result = firstWhere.key;
      } else {
        heights.sort((h1, h2) => h2.value.compareTo(h1.value));
        final firstWhere = heights.firstWhere((element) => element.value < visibleHeightByExpansion);
        result = firstWhere.key;
      }
    } else {
      result = _expansion;
    }
    return result;
  }

  void _printDebugLog(String text) {
    if (kDebugMode && widget.printDebugLogs) {
      logger.log(text);
    }
  }

  double _visibleHeightByExpansion(Expansion expansion, [DgisBottomSheet? widget]) {
    widget ??= this.widget;
    var visibleHeight = 0.0;
    switch (expansion) {
      case Expansion.fullHidePhoto:
      case Expansion.expanded:
        visibleHeight = _maxVisibleHeight;
      case Expansion.middle:
        visibleHeight = widget.middleHeight!;
      case Expansion.collapsed:
        visibleHeight = widget.collapsedHeight!;
      case Expansion.hidden:
        visibleHeight = widget.hiddenHeight;
    }

    return min(visibleHeight, _maxVisibleHeight);
  }

  Future<void> setExpansion(Expansion expansion, {bool animate = true, bool byUser = false}) async {
    assert(
      expansion == Expansion.hidden || widget.availableExpansions.contains(expansion),
      'You can set expansion witch is available or Expansion.hidden',
    );

    _printDebugLog('setExpansion: expansion=$expansion, animate=$animate, byUser=$byUser');

    final visibleHeight = _visibleHeightByExpansion(expansion);

    // если желаемая высота совпадает с текущей, нам не нужно запускать никаких анимаций
    if (_visibleHeight == visibleHeight) {
      _printDebugLog('_visibleHeight == visibleHeight -> just update expansion if needed');
      // но не забываем обновить expansion если оно изменилось
      // попадаем сюда когда юзер вручную подвинул bottom sheet
      // и не нужно доскраливать до близжайшего значения expansion
      // самый частый случай - expanded
      // другие реальны, но крайне мало вероятны
      if (_expansion != expansion) {
        _printDebugLog('setExpansion. update _expansion with setState and return');
        setState(() {
          _expansion = expansion;
        });
        _notifyExpansion(expansion, byUser: byUser);
      }
      return;
    }

    if (animate) {
      _printDebugLog('Run expansion animation from $_visibleHeight to $visibleHeight');
      _animationController?.dispose();
      // TODO: добавить физику (Curve и Duration)
      final animationController = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
      _animationController = animationController;

      var visibleHeightAnimationIntervalBegin = 0.0;

      _printDebugLog('setExpansion. position.pixels=${position.pixels}');

      _hasActiveAnimation = true;

      // если bottom sheet развёрнут и внутренний список не на начальной позиции
      // нужно сначала проскролить внутненний список а только потом bottom sheet
      if (_visibleHeight == _maxVisibleHeight && expansion != Expansion.expanded && position.pixels > 0) {
        _printDebugLog('setExpansion. First start with scrollableBodyPixelsAnimation');
        final visibleHeightDelta = _visibleHeight - visibleHeight;

        visibleHeightAnimationIntervalBegin = position.pixels / (position.pixels + visibleHeightDelta);

        // TODO: здесь нужно сделать как в телеге,
        // когда в чате отсролил очень далеко
        // и возвращаешься назад по клику в кнопку "вниз"
        // там происходит резкий скачёк близко к началу чата
        // и потом плавная анимация подскроливания, выглядит отлично
        final scrollableBodyPixelsAnimation = Tween<double>(begin: position.pixels, end: 0).animate(
          CurvedAnimation(parent: animationController, curve: Interval(0, visibleHeightAnimationIntervalBegin)),
        );

        scrollableBodyPixelsAnimation.addListener(() {
          position.jumpTo(scrollableBodyPixelsAnimation.value);
        });
      }

      _printDebugLog('create visibleHeightAnimation with end visibleHeight=$visibleHeight');

      final visibleHeightAnimation = Tween<double>(begin: _visibleHeight, end: visibleHeight).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(visibleHeightAnimationIntervalBegin, 1, curve: Curves.ease),
        ),
      );
      visibleHeightAnimation.addListener(() {
        setState(() {
          _visibleHeight = visibleHeightAnimation.value;
          widget.onVisibleHeightChanged?.call(_visibleHeight);
        });
      });

      await animationController.forward().whenComplete(() {
        _printDebugLog(
          'animation complete, _visibleHeight=$_visibleHeight, visibleHeightAnimation=${visibleHeightAnimation.isCompleted}',
        );
        setState(() {
          _hasActiveAnimation = false;
        });
      });
    } else {
      if (expansion != Expansion.expanded && position.pixels != 0) {
        position.jumpTo(0);
      }
      setState(() {
        _visibleHeight = visibleHeight;
        widget.onVisibleHeightChanged?.call(_visibleHeight);
      });
    }

    // TODO: поддержать полное закрытие

    // не забываем обновить expansion
    setState(() {
      _expansion = expansion;
    });
    _notifyExpansion(expansion, byUser: byUser);
  }

  /// Если возможно - свернёт [DgisBottomSheet] до самого нижнего состояния и вернёт false
  /// Если сворачивать некуда - возвращаем true
  ///
  /// По умолчанию этот метод вызывается из [PopScope] в корне [DgisBottomSheet]
  /// т.е. если сворачивать данный метод возвращает true,
  /// то будет закрыт текущий роут
  ///
  /// Если [PopScope] есть выше по дереву, например в корне экрана,
  /// необходимо сначала вызвать этот метод для текущего [DgisBottomSheet]
  /// и только после, если метод вернул true, выполнять свою логику

  bool isFirstOpen = false;

  Future<void> onPopInvokedWithResult(didPop, Object? result) async {
    final lowestAvailableExpansion = _lowestAvailableExpansion();
    if (_expansion == lowestAvailableExpansion) {
      if (result != null) {
        context.router.pop(result);
      }
    } else {
      /// Пришлось сделать такую реализацию, на новом боттом щите Дани это уйдет.
      /// [PopScope] вызывает метод при запуске скрина,что нарушает логику и pop срабатывает два раза, и выходит с экрана
      if (isFirstOpen) {
        await setExpansion(lowestAvailableExpansion, byUser: true);
      } else {
        isFirstOpen = true;
      }
    }
  }

  Expansion _lowestAvailableExpansion() {
    for (final expansion in Expansion.values) {
      if (widget.availableExpansions.contains(expansion)) {
        return expansion;
      }
    }
    throw UnimplementedError('This line should be unreachable');
  }

  void _notifyExpansion(Expansion expansion, {required bool byUser}) {
    widget.onExpansionChanged?.call(expansion, byUser: byUser);
    widget.controller?._currentExpansion = expansion;
    _bottomSheetHeightListener.value = _visibleHeightByExpansion(expansion);
  }
}

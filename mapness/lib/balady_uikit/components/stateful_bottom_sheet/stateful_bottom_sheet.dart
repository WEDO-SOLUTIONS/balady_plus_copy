import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/dragger_contrainer.dart';
import 'package:balady_uikit/src/common/snapping_simulation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/bottom_sheet_animate_components/bottom_sheet_state_notifier.dart';
import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/models/stateful_sheet_delegate.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:urbi_utils/urbi_utils.dart';

import 'bottom_sheet_snapping/bottom_sheet_state_mapper.dart';

// TODO(flutter-upgrade/3.38.5): remove this folder (mapness/lib/balady_uikit/components/stateful_bottom_sheet)
// completely when is code is available through balady_uikit dependency package

part 'bottom_sheet_snapping/behaviors/bottom_sheet_snapping_behavior.dart';
part 'render_stateful_bottom_sheet.dart';
part 'stateful_bottom_sheet_controller.dart';

/// A customizable and animated stateful bottom sheet widget.
///
/// The `StatefulBottomSheet` allows you to create a dynamic bottom sheet with support
/// for snapping behavior, headers, footers, and interactive content.
///
/// ### Key Features:
/// - Configurable snapping and scrolling behavior.
/// - Customizable header, footer, and content.
/// - Animations for opening and transitioning between states.
/// - Integration with a controller for external state management.
class StatefulBottomSheet<StateType> extends StatefulWidget {
  /// Widget that is shown at the top of the the bottom sheet
  /// and can be expand to take all available space outside the bottom sheet.
  ///
  /// This widget shrinks as the bottom sheet height increases and is drawn behind other widgets.
  ///
  /// ### Example:
  /// ```dart
  /// outside: const MapControls()
  /// ```
  final Widget? outside;

  /// Offsets top header relative to the height of the bottom sheet.
  ///
  /// Positive values create spacing above the header, while negative values move it underneath the sheet.
  final StatefulSheetDelegate<double>? topHeaderOffset;

  /// Widget that will be displayed on top of the bottom sheet header.
  ///
  /// It is drawn at the bottom layer of the bottom sheet widgets
  /// and is obscured by any other widget as the sheet fully opens.
  final Widget? topHeader;

  /// Unscrollable widget fixed at the top of the bottom sheet content.
  ///
  /// It is drawn at the the top of every other widget.
  /// This header remains visible regardless of the sheet's height.
  final Widget? header;

  /// Widget that could be a part of the header or drawn at the end of the bottom sheet, obscuring content.
  ///
  /// Placement can be adjusted using [footerInsideHeaderLayer].
  final Widget? footer;

  /// List of widgets that represent the main content (body) of the bottom sheet,
  /// and would be displayed inside [SliverList].
  final List<Widget>? content;

  /// Sliver widget that will be placed before [SliverList] body at the same layer as content
  final Widget? sliverBeforeContent;

  /// Determine if the dragger line of the bottom sheet should be visible.
  ///
  /// It will be drawn on the header layer
  ///
  /// Dragger widget has height of the `24 pixels`
  final bool displayDragger;

  /// Determine if the footer should be placed inside the header layer or the original footer layer.
  ///
  /// If `true` places the footer at the end of the header layer.
  /// Defaults to `false`
  final bool footerInsideHeaderLayer;

  /// Defines how much circular [BorderRadius] should be applied to the header and the start of the bottom sheet.
  ///
  /// Only effects the top left and top right corners of bottom sheet.
  final double cornerRadius;

  /// Custom [ScrollController] used to controll state of this bottom sheet instaince
  /// and get the information of the current state of it.
  ///
  /// It's also used to control the behavior of the multiple scroll viewports inside the bottom sheet.
  final StatefulBottomSheetController<StateType> scrollController;

  /// Defines if the bottom sheet should be animated to the initial state
  final bool animateOpening;

  /// Color that will be bottom sheet filled with.
  final Color? backgroundColor;

  /// Color that safe area or bottom padding before bottom sheet be filled with.
  ///
  /// If you are using [SafeArea] and [TextField]s inside [StatefulBottomSheet] and keyboard may appear in.
  /// Make sure that you set `maintainBottomViewPadding: true` inside [SafeArea] widget.
  final Color? safeAreaColor;

  /// Background color of the default dragger widget.
  final Color? draggerColor;

  /// Delegate to calculate the background fill color behind the bottom sheet page.
  ///
  /// Return `null` then the background fill color is not needed.
  final StatefulSheetDelegate<Color?>? backgroundColorDelegate;

  /// Defines if [outside] widget should be drawn behind or on top of background fill color,
  /// which is described by [backgroundColorDelegate]
  final bool drawOutsideWidgetBehindBackground;

  /// Defines if [outside] widget should be layout within the available space outside the bottom sheet and [topHeader].
  ///
  /// if 'true' will take less space base on the size [topHeader] widget.
  ///
  /// if 'false' will ignore [topHeader] on the layout stage.
  final bool offsetOutsideWidgetByTopheader;

  /// Delegate to calculate the opacity of the [outside] widget based on the current state of the bottom sheet.
  final StatefulSheetDelegate<double>? outsideOpacityDelegate;

  /// If `true` the bottom sheet content should size itself to avoid the onscreen keyboard
  /// whose height is defined by the ambient [MediaQuery]'s [MediaQueryData.viewInsets] bottom property.
  ///
  /// This will affect viewport constraints and pixel offsets for all bottom sheet states.
  ///
  /// If you are using [SafeArea] and [TextField]s inside [StatefulBottomSheet] and keyboard may appear in.
  /// Make sure that you set `maintainBottomViewPadding: false` inside [SafeArea] widget
  /// to prevent safe area appear at top of keyboard.
  ///
  /// Otherwise, set `maintainBottomViewPadding: true`.
  final bool resizeToAvoidBottomPadding;

  /// Defines if the content should be kept behind the footer and not cut by it.
  final bool keepContentBehindFooter;

  /// How the widgets should respond to user input.
  ///
  /// For example, determines how the widget continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions via the physics provided from
  /// the ambient [ScrollConfiguration].
  ///
  /// If an explicit [ScrollBehavior] is provided to
  /// [Scrollable.scrollBehavior], the [ScrollPhysics] provided by that behavior
  /// will take precedence after [Scrollable.physics].
  ///
  /// The physics can be changed dynamically, but new physics will only take
  /// effect if the _class_ of the provided object changes. Merely constructing
  /// a new instance with a different configuration is insufficient to cause the
  /// physics to be reapplied. (This is because the final object used is
  /// generated dynamically, which can be relatively expensive, and it would be
  /// inefficient to speculatively create this object each frame to see if the
  /// physics should be updated.)
  ///
  /// See also:
  ///
  ///  * [AlwaysScrollableScrollPhysics], which can be used to indicate that the
  ///    scrollable should react to scroll requests (and possible overscroll)
  ///    even if the scrollable's contents fit without scrolling being necessary.
  final ScrollPhysics? physics;

  /// The amount of padding to apply to the [content] list.
  final EdgeInsets? contentPadding;

  const StatefulBottomSheet({
    required this.scrollController,
    this.physics,
    this.outsideOpacityDelegate,
    this.outside,
    this.content,
    this.topHeaderOffset,
    this.topHeader,
    this.header,
    this.footer,
    this.sliverBeforeContent,
    this.contentPadding,
    this.backgroundColorDelegate,
    this.cornerRadius = RadiusBorder.xl,
    this.animateOpening = true,
    this.displayDragger = true,
    this.footerInsideHeaderLayer = false,
    this.drawOutsideWidgetBehindBackground = false,
    this.offsetOutsideWidgetByTopheader = true,
    this.resizeToAvoidBottomPadding = false,
    this.keepContentBehindFooter = false,
    this.backgroundColor,
    this.safeAreaColor,
    this.draggerColor,
    super.key,
  });

  @override
  State<StatefulBottomSheet<StateType>> createState() => _StatefulSheetState<StateType>();
}

class _StatefulSheetState<StateType> extends State<StatefulBottomSheet<StateType>> with TickerProviderStateMixin {
  final EdgeInsetsGeometry bodyPadding = const EdgeInsets.all(Spacing.$2x);

  late final StatefulBottomSheetController<StateType> controller;
  late BorderRadius borderRadius = BorderRadius.vertical(top: Radius.circular(widget.cornerRadius));

  @override
  void initState() {
    super.initState();
    controller = widget.scrollController;
    controller
      .._extent.isAnimatingOpen = widget.animateOpening
      .._initAnimation(this);

    if (widget.animateOpening) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        controller.open();
      });
    }
  }

  @override
  void didUpdateWidget(StatefulBottomSheet<StateType> oldWidget) {
    if (widget.cornerRadius != oldWidget.cornerRadius) {
      borderRadius = BorderRadius.vertical(top: Radius.circular(widget.cornerRadius));
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final border = SmoothRectangleBorder(borderRadius: borderRadius);
    final sliverContent = widget.sliverBeforeContent;
    final widgetContent = widget.content;

    final topHeader = widget.topHeader != null
        ? GestureDetector(
            onVerticalDragStart: (details) => controller._dragStart(details, context),
            onVerticalDragUpdate: (details) => controller._dragHeader(details, context),
            onVerticalDragEnd: (details) => controller._forceHeight(details, context),
            child: widget.topHeader,
          )
        : null;

    final header = GestureDetector(
      onVerticalDragStart: (details) => controller._dragStart(details, context),
      onVerticalDragUpdate: (details) => controller._dragHeader(details, context),
      onVerticalDragEnd: (details) => controller._forceHeight(details, context),
      child: SmoothClipRRect(
        borderRadius: borderRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.displayDragger) DraggerContainer(color: widget.draggerColor),
            if (widget.header != null) widget.header!,
            if (widget.footerInsideHeaderLayer && widget.footer != null) widget.footer!,
          ],
        ),
      ),
    );

    final content = Scrollable(
      controller: controller,
      physics: widget.physics,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        overscroll: false,
        physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
        scrollbars: false,
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      viewportBuilder: (context, offset) => Viewport(
        offset: offset,
        slivers: [
          if (sliverContent != null) sliverContent,
          if (widgetContent != null)
            SliverPadding(
              padding: widget.contentPadding ?? EdgeInsets.zero,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => widgetContent[index],
                  childCount: widgetContent.length,
                ),
              ),
            ),
        ],
      ),
    );

    final footer = widget.footerInsideHeaderLayer || widget.footer == null
        ? null
        : GestureDetector(
            onVerticalDragStart: (details) => controller._dragStart(details, context),
            onVerticalDragUpdate: (details) => controller._dragHeader(details, context),
            onVerticalDragEnd: (details) => controller._forceHeight(details, context),
            child: widget.footer,
          );

    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: _BottomSheetNotifierContainer<StateType>(
          controller: controller,
          child: Builder(
            builder: (context) {
              final viewBottomPadding = switch (widget.resizeToAvoidBottomPadding) {
                true => MediaQuery.viewInsetsOf(context).bottom,
                _ => 0.0,
              };

              return _StatefulBottomSheetWidget<StateType>(
                scrollController: controller,
                viewBottomPadding: viewBottomPadding,
                safeAreaColor: widget.safeAreaColor,
                topHeaderOffset: widget.topHeaderOffset,
                drawOutsideWidgetBehindBackgroundFill: widget.drawOutsideWidgetBehindBackground,
                offsetOutsideWidgetByTopheader: widget.offsetOutsideWidgetByTopheader,
                outsideOpacityDelegate: widget.outsideOpacityDelegate,
                backgroundColor: widget.backgroundColor ?? context.colors.backgroundSurface1,
                backgroundColorDelegate: widget.backgroundColorDelegate,
                keepContentBehindFooter: widget.keepContentBehindFooter,
                borderRadius: borderRadius,
                shaper: border,
                outside: widget.outside,
                topHeader: topHeader,
                footer: footer,
                header: header,
                content: content,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() async => controller._extent.stateMapper.shouldPopOn(controller);
}

class _BottomSheetNotifierContainer<StateType> extends StatefulWidget {
  final StatefulBottomSheetController<StateType> controller;
  final Widget child;

  const _BottomSheetNotifierContainer({required this.controller, required this.child});

  @override
  State<_BottomSheetNotifierContainer<StateType>> createState() => __BottomSheetNotifierContainerState<StateType>();
}

class __BottomSheetNotifierContainerState<StateType> extends State<_BottomSheetNotifierContainer<StateType>> {
  late final StateType initialState;

  @override
  Widget build(BuildContext context) => BottomSheetStateNotifier<StateType>(
    state: widget.controller.isEnabled ? widget.controller.state : initialState,
    stateInterpolation: widget.controller.interpolation,
    child: widget.child,
  );

  @override
  void didUpdateWidget(covariant _BottomSheetNotifierContainer<StateType> oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(updateState);
      widget.controller.addListener(updateState);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(updateState);
    initialState = widget.controller._extent.stateMapper.state(widget.controller._extent.initialState);
  }

  void updateState() {
    if (mounted && !(context as ComponentElement).dirty) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateState);
    super.dispose();
  }
}

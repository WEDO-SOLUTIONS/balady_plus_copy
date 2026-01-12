part of 'package:mapness/balady_uikit/components/stateful_bottom_sheet/stateful_bottom_sheet.dart';

enum _StatefulBottomSheetSlot { topHeader, header, content, footer, outside }

/// A widget that creates a scrollable and dynamic layout for the [StatefulBottomSheet].
///
/// This widget uses a [SlottedMultiChildRenderObjectWidget] to manage different slots like
/// `top`, `header`, `footer`, `content`, and `outside`. Each slot is represented by a child widget.
class _StatefulBottomSheetWidget<StateType>
    extends SlottedMultiChildRenderObjectWidget<_StatefulBottomSheetSlot, RenderBox> {
  /// The controller managing the state and behavior of the bottom sheet.
  final StatefulBottomSheetController<StateType> scrollController;

  /// Child widgets for the various slots in the bottom sheet.
  final Widget? outside;
  final Widget? topHeader;
  final Widget? header;
  final Widget? content;
  final Widget? footer;

  /// Offset for positioning the `topHeader` relative to the bottom sheet.
  final StatefulSheetDelegate<double>? topHeaderOffset;

  /// Background color of the bottom sheet.
  final Color backgroundColor;

  /// Color for the safe area padding at the bottom of the sheet.
  final Color? safeAreaColor;

  /// The border radius for the top corners of the bottom sheet.
  final BorderRadius borderRadius;

  /// Defines the shape of the bottom sheet using a custom [SmoothRectangleBorder].
  final SmoothRectangleBorder shaper;

  /// Delegate to dynamically calculate the background color based on state of controller.
  final StatefulSheetDelegate<Color?>? backgroundColorDelegate;

  /// Delegate to calculate the opacity of the [outside] widget based on state of controller.
  final StatefulSheetDelegate<double>? outsideOpacityDelegate;

  /// Determines if the [outside] widget should be drawn behind the background fill color.
  final bool drawOutsideWidgetBehindBackgroundFill;

  /// Determines if the layout of the [outside] widget should account for the [topHeader].
  final bool offsetOutsideWidgetByTopheader;

  /// Padding for the bottom of the viewport to accommodate UI elements like keyboard.
  final double? viewBottomPadding;

  /// Determines if the content should be kept behind the footer and not cut by it.
  final bool keepContentBehindFooter;

  const _StatefulBottomSheetWidget({
    required this.scrollController,
    required this.backgroundColor,
    required this.borderRadius,
    required this.shaper,
    this.topHeaderOffset,
    this.topHeader,
    this.header,
    this.content,
    this.footer,
    this.outside,
    this.backgroundColorDelegate,
    this.outsideOpacityDelegate,
    this.safeAreaColor,
    this.viewBottomPadding,
    this.drawOutsideWidgetBehindBackgroundFill = false,
    this.offsetOutsideWidgetByTopheader = true,
    this.keepContentBehindFooter = false,
  });

  @override
  Widget? childForSlot(_StatefulBottomSheetSlot slot) => switch (slot) {
    _StatefulBottomSheetSlot.topHeader => topHeader,
    _StatefulBottomSheetSlot.header => header,
    _StatefulBottomSheetSlot.content => content,
    _StatefulBottomSheetSlot.footer => footer,
    _StatefulBottomSheetSlot.outside => outside,
  };

  @override
  Iterable<_StatefulBottomSheetSlot> get slots => _StatefulBottomSheetSlot.values;

  @override
  SlottedContainerRenderObjectMixin<_StatefulBottomSheetSlot, RenderBox> createRenderObject(BuildContext context) =>
      _RenderStatefulBottomSheet(
        scrollController: scrollController,
        topHeaderOffset: topHeaderOffset,
        backgroundColorDelegate: backgroundColorDelegate,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        safeAreaColor: safeAreaColor,
        shaper: shaper,
        drawOutsideWidgetBehindBackgroundFill: drawOutsideWidgetBehindBackgroundFill,
        offsetOutsideWidgetByTopheader: offsetOutsideWidgetByTopheader,
        outsideOpacityDelegate: outsideOpacityDelegate,
        viewBottomPadding: viewBottomPadding,
        keepContentBehindFooter: keepContentBehindFooter,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderStatefulBottomSheet<StateType> renderObject) {
    renderObject
      ..scrollController = scrollController
      ..topHeaderOffset = topHeaderOffset
      ..backgroundColorDelegate = backgroundColorDelegate
      ..backgroundColor = backgroundColor
      ..borderRadius = borderRadius
      ..safeAreaColor = safeAreaColor
      ..shaper = shaper
      ..drawOutsideWidgetBehindBackgroundFill = drawOutsideWidgetBehindBackgroundFill
      ..offsetOutsideWidgetByTopheader = offsetOutsideWidgetByTopheader
      ..outsideOpacityDelegate = outsideOpacityDelegate
      ..viewBottomPadding = viewBottomPadding
      ..keepContentBehindFooter = keepContentBehindFooter;

    super.updateRenderObject(context, renderObject);
  }
}

/// A custom render object for managing the layout and rendering of the [StatefulBottomSheet].
///
/// This render object handles complex layout scenarios such as scrolling content, animating
/// the height of the bottom sheet, and adjusting for safe area padding.
class _RenderStatefulBottomSheet<StateType> extends RenderBox
    with SlottedContainerRenderObjectMixin<_StatefulBottomSheetSlot, RenderBox> {
  StatefulBottomSheetController<StateType> scrollController;
  StatefulSheetDelegate<Color?>? backgroundColorDelegate;
  StatefulSheetDelegate<double>? outsideOpacityDelegate;
  StatefulSheetDelegate<double>? topHeaderOffset;
  Color backgroundColor;
  Color? safeAreaColor;
  BorderRadius borderRadius;
  SmoothRectangleBorder shaper;
  bool drawOutsideWidgetBehindBackgroundFill;
  bool offsetOutsideWidgetByTopheader;

  double draggedSheetOffset = 0.0;
  double? topHeaderOffsetValue;

  int outsideOpacity = 255;

  double? _viewBottomPadding;

  bool keepContentBehindFooter;

  double get viewBottomPadding => _viewBottomPadding ?? 0.0;

  set viewBottomPadding(double? value) {
    if (_viewBottomPadding != value) {
      _viewBottomPadding = value;
      markNeedsLayout();
    }
  }

  _RenderStatefulBottomSheet({
    required this.scrollController,
    required this.borderRadius,
    required this.shaper,
    required this.backgroundColor,
    this.topHeaderOffset,
    this.safeAreaColor,
    this.backgroundColorDelegate,
    this.outsideOpacityDelegate,
    this.drawOutsideWidgetBehindBackgroundFill = false,
    this.offsetOutsideWidgetByTopheader = true,
    this.keepContentBehindFooter = false,
    double? viewBottomPadding,
  }) : draggedSheetOffset = scrollController._extent.offset,
       _viewBottomPadding = viewBottomPadding,
       topHeaderOffsetValue = topHeaderOffset?.getStaticValue();

  // Slot getters for accessing child render objects.
  RenderBox? get topHeader => childForSlot(_StatefulBottomSheetSlot.topHeader);

  RenderBox? get header => childForSlot(_StatefulBottomSheetSlot.header);

  RenderBox? get content => childForSlot(_StatefulBottomSheetSlot.content);

  RenderBox? get footer => childForSlot(_StatefulBottomSheetSlot.footer);

  RenderBox? get outside => childForSlot(_StatefulBottomSheetSlot.outside);

  double get bottomSheetHeightExtent => math.max(0.0, constraints.maxHeight - draggedSheetOffset - viewBottomPadding);

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    final _topHeader = topHeader;
    final _header = header;
    final _content = content;
    final _footer = footer;
    final _outside = outside;

    return <RenderBox>[
      if (_header != null) _header,
      if (_footer != null) _footer,
      if (_content != null) _content,
      if (_topHeader != null) _topHeader,
      if (_outside != null) _outside,
    ];
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      content != null ? math.max(content!.getMinIntrinsicWidth(height), 0) : 0.0;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      content != null ? math.max(content!.getMaxIntrinsicWidth(height), 0) : 0.0;

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(0, content!.getMinIntrinsicHeight(width) + (header?.getMinIntrinsicHeight(width) ?? 0.0));

  @override
  double computeMaxIntrinsicHeight(double width) => computeMinIntrinsicHeight(width);

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    scrollController.addListener(onSheetHeightChanges);
  }

  @override
  void detach() {
    scrollController.removeListener(onSheetHeightChanges);
    super.detach();
  }

  void onSheetHeightChanges() {
    /// Skip frame and reset marker for the current notification.
    if (scrollController._doNotMarkNeedsLayout) {
      scrollController._doNotMarkNeedsLayout = false;
      return;
    }
    final currentOffset = scrollController._extent.offset;
    final maxOffset = constraints.maxHeight;
    final isOpening = scrollController._extent.isAnimatingOpen;

    // Update dragged sheet offset based on the offset from controller's extent.
    if (currentOffset != draggedSheetOffset && (isOpening || currentOffset <= maxOffset)) {
      if (hasSize && !scrollController._extent.isPreformingResize) {
        markNeedsLayout();
      }
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => Size(constraints.maxWidth, constraints.maxHeight);

  @override
  void performResize() {
    scrollController._extent.isPreformingResize = true;
    scrollController._maxHeight = constraints.maxHeight - viewBottomPadding;
    super.performResize();
  }

  @override
  void performLayout() {
    // Calculate available space for the bottom sheet.
    final constraints = this.constraints;

    final avaliableHeight = constraints.maxHeight - viewBottomPadding;

    /// Updates the `lastMaxOffset` of the scroll controller's extent behavior to the current `maxOffset`.
    ///
    /// This is used to keep track of the safe maximum offset value is valid or not.
    scrollController._extent.behavior.lastMaxOffset = scrollController._extent.maxOffset;

    if (scrollController._extent.availablePixels == kStartOfTheViewport || viewBottomPadding > kStartOfTheViewport) {
      scrollController._maxHeight = avaliableHeight;
    }

    if (!scrollController.isEnabled) {
      draggedSheetOffset = avaliableHeight;
    } else {
      draggedSheetOffset = scrollController._extent.offset;
    }

    /// Flag that is false then bottom sheet is animating open state.
    /// This is necessary for enabling/disabling clipping by the height
    /// of the header for minimum displayed height of the bottom sheet.
    /// Then this flag is set to false, disable clipping and bottom sheet
    /// can go outside of bounding box of the viewport.
    final shiftByHeader = !scrollController._extent.isAnimatingOpen && scrollController._extent.behavior.clipByHeader;

    // Layout header
    final headerLayoutExtend = _layoutChild(header, constraints)?.height ?? kStartOfTheViewport;

    draggedSheetOffset = clampDouble(
      draggedSheetOffset,
      kStartOfTheViewport,
      avaliableHeight - (shiftByHeader ? headerLayoutExtend : kStartOfTheViewport),
    );

    var bottomSheetFreeSpace = clampDouble(
      bottomSheetHeightExtent,
      (shiftByHeader ? headerLayoutExtend : kStartOfTheViewport),
      avaliableHeight,
    );
    assert(bottomSheetFreeSpace >= kStartOfTheViewport, 'Max height should not be negative');

    /// footerLayoutExtend
    final footerLayoutExtend = _layoutChild(footer, constraints)?.height ?? kStartOfTheViewport;

    var bottomSheetContentSpace = math.max(
      kStartOfTheViewport,
      bottomSheetFreeSpace - headerLayoutExtend - (keepContentBehindFooter ? kStartOfTheViewport : footerLayoutExtend),
    );

    /// Layout overflow header
    final topLayoutExtend = _layoutChild(topHeader, constraints)?.height ?? kStartOfTheViewport;

    /// Layout bottom sheet content sliver list
    var contentLayoutExtend =
        _layoutChild(content, constraints, height: bottomSheetContentSpace)?.height ?? kStartOfTheViewport;

    /// Update components height layout
    final sheetOffsetAfterUpdatingComponentSizes =
        scrollController._updateComponents(
          headerHeight: headerLayoutExtend,
          contentHeight: contentLayoutExtend,
          footerHeight: footerLayoutExtend,
          topHeaderHeight: topLayoutExtend,
        ) ??
        draggedSheetOffset;

    /// Relayout the content because the offset of the bottom sheet changed by updated components.
    if (sheetOffsetAfterUpdatingComponentSizes != draggedSheetOffset) {
      draggedSheetOffset = sheetOffsetAfterUpdatingComponentSizes;

      /// The drag offset is been corrected by the current state of the sheet, so we need to recalculate the the free space and content space.
      bottomSheetFreeSpace = clampDouble(
        bottomSheetHeightExtent,
        (shiftByHeader ? headerLayoutExtend : kStartOfTheViewport),
        avaliableHeight,
      );
      assert(bottomSheetFreeSpace >= kStartOfTheViewport, 'Max height should not be negative');

      bottomSheetContentSpace = math.max(
        kStartOfTheViewport,
        bottomSheetFreeSpace -
            headerLayoutExtend -
            (keepContentBehindFooter ? kStartOfTheViewport : footerLayoutExtend),
      );

      contentLayoutExtend =
          _layoutChild(content, constraints, height: bottomSheetContentSpace)?.height ?? kStartOfTheViewport;
    }

    /// If the bottom sheet is should be open instantly, we need to recalculate the height of the sheet
    /// based on the widgets sizes which were layouted and enable bottom sheet to it to be drawn at the first frame.
    if (!scrollController.isEnabled && !scrollController._extent.isAnimatingOpen) {
      draggedSheetOffset = clampDouble(
        scrollController._calculateInitialPositionAndSetEnabled(),
        kStartOfTheViewport,
        avaliableHeight - (shiftByHeader ? headerLayoutExtend : kStartOfTheViewport),
      );

      /// The drag offset is been corrected by the current state of the sheet, so we need to recalculate the the free space and content space.
      bottomSheetFreeSpace = clampDouble(
        bottomSheetHeightExtent,
        (shiftByHeader ? headerLayoutExtend : kStartOfTheViewport),
        avaliableHeight,
      );
      assert(bottomSheetFreeSpace >= kStartOfTheViewport, 'Max height should not be negative');

      bottomSheetContentSpace = math.max(
        kStartOfTheViewport,
        bottomSheetFreeSpace -
            headerLayoutExtend -
            (keepContentBehindFooter ? kStartOfTheViewport : footerLayoutExtend),
      );

      /// Relayout the content because the height the content occupies has changed.
      contentLayoutExtend =
          _layoutChild(content, constraints, height: bottomSheetContentSpace)?.height ?? kStartOfTheViewport;
    }

    if (scrollController.needsSetupBehavior) {
      scrollController._extent.behavior.setup(scrollController._extent);
    }

    final footerOffsetPositionAbsolute = math.min(bottomSheetFreeSpace - headerLayoutExtend, footerLayoutExtend);
    final offsetBottomSheetFromTop = draggedSheetOffset;
    // We make it to not call the delegate function if the value is already set.
    // It improves performance and avoid unnecessary calls.
    final topOffset = topHeaderOffsetValue ?? topHeaderOffset?.getValue(scrollController) ?? kStartOfTheViewport;

    /// Layout outside widget
    final opacity = outsideOpacityDelegate?.getValue(scrollController);
    if (opacity != null) {
      outsideOpacity = Color.getAlphaFromOpacity(opacity.clamp(0, 1));
    }
    if (outsideOpacity > 0) {
      final outsideSize =
          (offsetBottomSheetFromTop - (offsetOutsideWidgetByTopheader ? topLayoutExtend : kStartOfTheViewport)).clamp(
            kStartOfTheViewport,
            avaliableHeight,
          );
      final _ = _layoutChild(outside, constraints, height: outsideSize);
      _positionChild(outside, constraints, kStartOfTheViewport);
    }

    /// Setup children's offsets
    _positionChild(content, constraints, offsetBottomSheetFromTop + headerLayoutExtend);
    _positionChild(
      topHeader,
      constraints,
      math.max(kStartOfTheViewport, offsetBottomSheetFromTop - topLayoutExtend - topOffset),
    );
    _positionChild(header, constraints, offsetBottomSheetFromTop);
    _positionChild(footer, constraints, avaliableHeight - footerOffsetPositionAbsolute);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    scrollController._extent.isPreformingResize = false;
    final _scrollController = scrollController;

    if (!_scrollController.isEnabled) {
      super.paint(context, offset);
      return;
    }

    final painter = Paint()
      ..color = backgroundColor
      ..isAntiAlias = true;

    void doPaint(RenderBox? child, PaintingContext context, Offset offset) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    /// A `Path` object used to clip sheet layer and background.
    final Path path = shaper.getPath(
      borderRadius.toRRect(
        Rect.fromLTWH(kStartOfTheViewport, draggedSheetOffset, constraints.maxWidth, bottomSheetHeightExtent),
      ),
    );

    void paintOutsideWidget() {
      context.pushLayer(
        OpacityLayer()..alpha = outsideOpacity,
        (context, offset) => doPaint(outside, context, offset),
        offset,
      );
    }

    void paintBottomSheet(PaintingContext context, Offset offset) {
      /// Paint the background of the bottom sheet.
      context.canvas.drawPath(path.shift(offset), painter);
      doPaint(content, context, offset);
      doPaint(header, context, offset);
      doPaint(footer, context, offset);
    }

    /// Paint the outside widget behind the background fill color.
    final paintOutside = outsideOpacity > 0;
    if (drawOutsideWidgetBehindBackgroundFill && paintOutside) {
      paintOutsideWidget();
    }

    /// Draw background color from the background tilt delegate.
    final fillTiltColor = backgroundColorDelegate?.getValue(_scrollController);
    if (fillTiltColor != null) {
      final backgroundPainter = Paint()..color = fillTiltColor;
      context.canvas.drawPaint(backgroundPainter);
    }

    /// Paint the outside widget above the background fill color.
    if (!drawOutsideWidgetBehindBackgroundFill && paintOutside) {
      paintOutsideWidget();
    }

    /// Paint the top header widget above the background fill color.
    doPaint(topHeader, context, offset);

    layer = context.pushClipPath(
      needsCompositing,
      offset,
      Rect.fromLTWH(offset.dx, draggedSheetOffset, constraints.maxWidth, bottomSheetHeightExtent),
      path,
      paintBottomSheet,
      oldLayer: layer as ClipPathLayer?,
    );

    /// Paint the safe area padding at the bottom of the sheet.
    if (safeAreaColor != null) {
      painter.color = safeAreaColor!;
    }

    context.canvas.drawRect(
      Rect.fromLTWH(
        offset.dx,
        constraints.maxHeight - viewBottomPadding + offset.dy,
        constraints.maxWidth,
        kBottomNavigationBarHeight,
      ),
      painter,
    );
  }

  @override
  bool hitTestSelf(Offset position) => false;

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (!scrollController.isEnabled || !hasSize) {
      return super.hitTestChildren(result, position: position);
    }

    for (final child in children) {
      /// If the outside widget is not visible then skip it.
      if (child == outside && outsideOpacity == 0) {
        continue;
      }
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final isHit = child.hitTest(result, position: position - parentData.offset);
      if (isHit) {
        return isHit;
      }
    }
    return false;
  }

  Size? _layoutChild(RenderBox? child, BoxConstraints constraints, {double? height}) {
    if (child == null) {
      return null;
    }
    child.layout(constraints.copyWith(minHeight: 0, maxHeight: height ?? constraints.maxHeight), parentUsesSize: true);
    return child.size;
  }

  void _positionChild(RenderBox? child, BoxConstraints constraints, double offset) {
    if (child == null) {
      return;
    }

    final leftPadding = (constraints.maxWidth - child.size.width) / 2;
    (child.parentData as BoxParentData?)?.offset = Offset(leftPadding, offset);
  }
}

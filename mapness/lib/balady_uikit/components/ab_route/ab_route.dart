import 'package:balady_uikit/balady_uikit.dart' hide StopNumbersIcons;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapness/balady_uikit/animations/animated_decorated_box.dart';
import 'package:mapness/balady_uikit/core/icons/stop_numbers_icons.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'ab_route_add_point.dart';

part 'ab_route_model.dart';

part 'ab_route_row_decoration.dart';

// TODO(Loskutov): dots between rows work like sht

/// A widget for displaying a list of items with drag-and-drop reordering functionality.
///
/// Use [ABRoute] to display a list of items that can be reordered by dragging.
/// The widget provides callbacks for handling reordering and tapping on individual items.
///
/// The [items] parameter specifies the list of items to be displayed.
/// The [onReorder] parameter is a callback function that is called when an item is reordered.
/// The [onTap] parameter is a callback function that is called when an item is tapped.
/// See also:
/// * [Figma Design] (https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=3679-14798&mode=design&t=CY2RzKrEkP3ClO2q-0), design specs
class ABRoute extends StatefulWidget {
  final List<ABRouteModel> items;
  final ReorderCallback onReorder;
  final Function(int) onTap;
  final ValueChanged<int>? onDeletePressed;
  final Color? backgroundColor;
  final String? startPointSubtitle;
  final String? arrivalPointSubtitle;
  final VoidCallback? onAddPointPressed;

  const ABRoute({
    required this.items,
    required this.onReorder,
    required this.onTap,
    this.onDeletePressed,
    this.startPointSubtitle,
    this.arrivalPointSubtitle,
    this.backgroundColor,
    this.onAddPointPressed,
    super.key,
  });

  @override
  State<ABRoute> createState() => _ABRouteState();
}

class _ABRouteState extends State<ABRoute> {
  bool isReordering = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.backgroundColor ??
        (isReordering ? context.colors.backgroundSurface5 : context.colors.backgroundSurface1);

    final children = <Widget>[];
    for (var i = 0; i < widget.items.length; i++) {
      final isLast = i == widget.items.length - 1;
      children.add(
        _ABElement(
          key: ValueKey(widget.items[i].title),
          backgroundColor: color,
          index: i,
          item: widget.items[i],
          onTap: () => widget.onTap(i),
          onDeletePressed: widget.onDeletePressed == null ? null : () => widget.onDeletePressed?.call(i),
          isDragged: false,
          isLast: isLast,
          subtitle: isLast
              ? widget.arrivalPointSubtitle
              : i == 0
                  ? widget.startPointSubtitle
                  : null,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.l),
        child: AnimatedDecoratedBox(
          duration: Durations.medium1,
          decoration: BoxDecoration(color: color),
          child: _ABDottedPathContainer(
            color: context.colors.foregroundDisabled,
            hasFirstSubtitle: widget.startPointSubtitle != null,
            hasLastSubtitle: widget.arrivalPointSubtitle != null,
            points: widget.items.length,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ReorderableListView(
                    shrinkWrap: true,
                    buildDefaultDragHandles: false,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (i, j) => widget.onReorder(i, j),
                    onReorderStart: (_) => setState(() => isReordering = true),
                    onReorderEnd: (_) => setState(() => isReordering = false),
                    proxyDecorator: (child, index, animation) {
                      final isLast = index == widget.items.length - 1;

                      // ProxyDecorator doesn't use current [Directionality] so we need to wrap it with [Directionality]
                      return Directionality(
                        textDirection: Directionality.of(context),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: Shadows.s,
                            color: context.colors.foregroundSurfacePush,
                            borderRadius: BorderRadius.circular(RadiusBorder.ml),
                          ),
                          child: _ABElement(
                            key: ValueKey(widget.items[index].title),
                            index: index,
                            item: widget.items[index],
                            onTap: () => widget.onTap(index),
                            backgroundColor: color,
                            isDragged: true,
                            isLast: isLast,
                            subtitle: isLast
                                ? widget.arrivalPointSubtitle
                                : index == 0
                                    ? widget.startPointSubtitle
                                    : null,
                          ),
                        ),
                      );
                    },
                    children: children,
                  ),
                ),
                _AbRouteAddPoint(widget.onAddPointPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// This widget represents a single item in the list. We use it to manage icon, text, and drag handle.
///
/// Also we don't have to show divider on dragged item and last item.
/// Size of the icon is 22 because it expand the row height, text alignment is top and layout become wrong.
class _ABElement extends StatelessWidget {
  final ABRouteModel item;
  final VoidCallback onTap;
  final bool isDragged;
  final int index;
  final bool isLast;
  final String? subtitle;
  final Color backgroundColor;
  final VoidCallback? onDeletePressed;

  const _ABElement({
    required this.item,
    required this.onTap,
    required this.isDragged,
    required this.index,
    required this.isLast,
    required this.backgroundColor,
    this.subtitle,
    this.onDeletePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget;

    if (index == 0 || isLast) {
      final color = isLast ? context.colors.extra01Default : context.colors.accentDefault;
      final isLTR = Directionality.of(context) == TextDirection.ltr;
      final icon = item.isMyLocation
          ? (isLTR ? TransportIcons.locationFullLTR : TransportIcons.locationFullRTL)
          : GeneralIcons.bulletCircleSolid;

      iconWidget = Icon(icon, color: color, size: 24);
    } else {
      iconWidget = Icon(StopNumbersIcons.fromIndex(index), color: context.colors.extra01Default, size: 24);
    }

    return AnimatedSize(
      duration: Durations.short3,
      child: AnimatedSwitcher(
        key: ValueKey(item.title),
        duration: Durations.medium2,
        child: _ABRouteRowDecoration(
          key: ValueKey(item.title + (subtitle ?? '')),
          onTap: onTap,
          onDeletePressed: onDeletePressed,
          leading: AnimatedDecoratedBox(
            duration: Durations.medium1,
            decoration: BoxDecoration(color: backgroundColor),
            child: AnimatedSwitcher(
              key: ValueKey(item.title),
              duration: Durations.medium1,
              child: iconWidget,
            ),
          ),
          title: item.title,
          index: index,
          isDividerEnabled: true,
        ),
      ),
    );
  }
}

class _ABDottedPathContainer extends SingleChildRenderObjectWidget {
  final Color color;
  final bool hasFirstSubtitle;
  final bool hasLastSubtitle;
  final int points;

  const _ABDottedPathContainer({
    required Widget child,
    required this.color,
    this.hasFirstSubtitle = true,
    this.hasLastSubtitle = true,
    this.points = 2,
    Key? key,
  }) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderABDottedPathContainer(
        color,
        hasFirstSubtitle: hasFirstSubtitle,
        hasLastSubtitle: hasLastSubtitle,
        points: points,
      );

  @override
  void updateRenderObject(BuildContext context, covariant _RenderABDottedPathContainer renderObject) {
    renderObject
      ..color = color
      ..hasFirstSubtitle = hasFirstSubtitle
      ..hasLastSubtitle = hasLastSubtitle
      ..points = points
      ..markNeedsPaint();
    super.updateRenderObject(context, renderObject);
  }
}

class _RenderABDottedPathContainer extends RenderProxyBox {
  Color color;
  bool hasFirstSubtitle;
  bool hasLastSubtitle;
  int points;

  _RenderABDottedPathContainer(
    this.color, {
    this.hasFirstSubtitle = true,
    this.hasLastSubtitle = true,
    this.points = 2,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double dotSpacing = 6;
    const double dotRadius = 1;

    for (double y = 52 - (hasFirstSubtitle ? 0 : 12);
        y <= size.height - 48 + (hasLastSubtitle ? 0 : 12);
        y += dotSpacing + dotRadius * 2) {
      if (points == 2 || (y <= size.height / 2 - 14 || y >= size.height / 2 + 14)) {
        canvas.drawCircle(Offset(28 + offset.dx, y + offset.dy), dotRadius, paint);
      }
    }
    super.paint(context, offset);
  }
}

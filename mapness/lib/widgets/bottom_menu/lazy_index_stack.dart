import 'package:flutter/material.dart';

/// A lazy-loading [IndexedStack] that only builds widgets when they are visible.
///
/// Unlike a regular [IndexedStack], this widget delays the construction
/// of its children until they are displayed. This can be useful for
/// optimizing memory and performance when dealing with a large number of widgets.
///
/// Example usage:
/// ```dart
/// LazyIndexedStack(
///   index: selectedIndex,
///   children: [
///     FirstPage(),
///     SecondPage(),
///     ThirdPage(),
///   ],
/// )
/// ```
class LazyIndexedStack extends StatefulWidget {
  /// Creates a [LazyIndexedStack].
  ///
  /// The [index] property determines which child is visible.
  /// The [children] list provides the widgets to be displayed.
  const LazyIndexedStack({
    Key? key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.index = 0,
    this.children = const [],
  }) : super(key: key);

  /// The alignment of the child within the [IndexedStack].
  ///
  /// Defaults to [AlignmentDirectional.topStart].
  final AlignmentGeometry alignment;

  /// The text direction to use for resolving [AlignmentDirectional] values.
  final TextDirection? textDirection;

  /// Defines how the non-visible children are sized.
  ///
  /// Defaults to [StackFit.loose].
  final StackFit sizing;

  /// The index of the child to display.
  ///
  /// Defaults to `0`.
  final int index;

  /// The list of child widgets.
  ///
  /// Only the widget at the current [index] will be built and displayed.
  final List<Widget> children;

  @override
  _LazyIndexedStackState createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  /// Tracks which children have already been activated (built).
  late List<bool> _activated = _initializeActivatedList();

  /// Initializes the activation list for the children.
  ///
  /// The child at the current [index] is marked as activated.
  List<bool> _initializeActivatedList() => List<bool>.generate(widget.children.length, (i) => i == widget.index);

  @override
  void didUpdateWidget(covariant LazyIndexedStack oldWidget) {
    // Reinitialize the activation list if the number of children changes.
    if (oldWidget.children.length != widget.children.length) {
      _activated = _initializeActivatedList();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // Mark the current index as activated.
    _activated[widget.index] = true;

    // Build the children, using [SizedBox.shrink] for inactive children.
    final children = List.generate(
      _activated.length,
      (i) => _activated[i] ? widget.children[i] : const SizedBox.shrink(),
    );

    return IndexedStack(
      alignment: widget.alignment,
      sizing: widget.sizing,
      textDirection: widget.textDirection,
      index: widget.index,
      children: children,
    );
  }
}

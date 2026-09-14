import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that applies padding to avoid system intrusions such as the
/// system status bar, notches, and the system navigation bar.
///
/// This widget is working similarly to [SafeArea], but does not remove view padding
/// from the [MediaQuery] of the [child]. Instead, it applies padding to the
/// [child] based on the [MediaQuery.padding] and the specified [minimum] padding.
class SafeAreaPadding extends StatelessWidget {
  /// Creates a widget that avoids operating system interfaces.
  ///
  /// The [left], [top], [right], [bottom], and [minimum] arguments must not be
  /// null.
  const SafeAreaPadding({
    required this.child,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
    super.key,
  });

  /// Whether to avoid system intrusions on the left.
  final bool left;

  /// Whether to avoid system intrusions at the top of the screen, typically the
  /// system status bar.
  final bool top;

  /// Whether to avoid system intrusions on the right.
  final bool right;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  final bool bottom;

  /// This minimum padding to apply.
  ///
  /// The greater of the minimum insets and the media padding will be applied.
  final EdgeInsets minimum;

  /// Specifies whether the [SafeAreaPadding] should maintain the bottom
  /// [MediaQueryData.viewPadding] instead of the bottom [MediaQueryData.padding],
  /// defaults to false.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// SafeArea, the padding can be maintained below the obstruction rather than
  /// being consumed. This can be helpful in cases where your layout contains
  /// flexible widgets, which could visibly move when opening a software
  /// keyboard due to the change in the padding value. Setting this to true will
  /// avoid the UI shift.
  final bool maintainBottomViewPadding;

  /// The widget below this widget in the tree.
  ///
  /// The padding on the [MediaQuery] for the [child] will be suitably adjusted
  /// to zero out any sides that were avoided by this widget.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context), 'SafeAreaPadding needs a MediaQuery ancestor');
    EdgeInsets padding = MediaQuery.paddingOf(context);
    // Bottom padding has been consumed - i.e. by the keyboard
    if (maintainBottomViewPadding) {
      padding = padding.copyWith(bottom: MediaQuery.viewPaddingOf(context).bottom);
    }

    return Padding(
      padding: EdgeInsets.only(
        left: max(left ? padding.left : 0.0, minimum.left),
        top: max(top ? padding.top : 0.0, minimum.top),
        right: max(right ? padding.right : 0.0, minimum.right),
        bottom: max(bottom ? padding.bottom : 0.0, minimum.bottom),
      ),
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('left', value: left, ifTrue: 'avoid left padding'))
      ..add(FlagProperty('top', value: top, ifTrue: 'avoid top padding'))
      ..add(FlagProperty('right', value: right, ifTrue: 'avoid right padding'))
      ..add(FlagProperty('bottom', value: bottom, ifTrue: 'avoid bottom padding'));
  }
}

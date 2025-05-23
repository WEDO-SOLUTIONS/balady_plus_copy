import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

/// A widget that wraps a child widget with a tap handler.
/// This is a temporary solution to the issue of the tap handler not working properly in the [InkWell] widget.
/// We want to show splash and tap effects when the user taps on the widget.
///
/// Here we workarounded the issue by using [InkWell] and [InkRipple] widgets.
class SearchTapHandler extends StatelessWidget {
  final Color? splashColor;
  final Widget child;
  final VoidCallback onTap;

  const SearchTapHandler({required this.child, required this.onTap, super.key, this.splashColor});

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        splashColor: splashColor ?? context.color.surfaceContrastLow,
        splashFactory: InkRipple.splashFactory,
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          onTap();
        },
        child: child,
      );
}

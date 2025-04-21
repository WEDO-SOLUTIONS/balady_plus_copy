import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// A widget that displays a fullscreen loading indicator.
class FullscreenLoadingIndicator extends StatelessWidget {
  /// The title of the loading indicator.
  ///
  /// By default, it is set to "loading".
  final String? title;

  /// Whether to display the title or not.
  final bool isDisplayTitle;

  /// The color of the loading indicator.
  final Color? color;

  /// The background color
  final Color backgroundColor;

  const FullscreenLoadingIndicator({
    super.key,
    this.title,
    this.color,
    this.backgroundColor = Colors.white,
    this.isDisplayTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final loadingTitle = title ?? context.l10n.loading;
    return Material(
      color: backgroundColor,
      child: Center(
        child: Loading.large(
          title: loadingTitle,
          orientation: Axis.vertical,
          isDisplayTitle: isDisplayTitle,
          color: color ?? context.color.strokeAccent,
          backgroundColor: context.color.strokeAccent.withOpacity(0.1),
        ),
      ),
    );
  }
}

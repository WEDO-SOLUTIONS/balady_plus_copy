import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/layouts/spacing.dart';
import 'package:flutter/material.dart';

enum LoaderSize { small, medium, large }

enum LoaderStyle { accent, neutral, error, accentSecondary, white }

extension LoaderSizeExt on LoaderSize {
  double get size => switch (this) {
        LoaderSize.small => 24.0,
        LoaderSize.medium => 36.0,
        LoaderSize.large => 48.0,
      };

  double get strokeWidth => size / 10;
}

extension LoaderStyleExt on LoaderStyle {
  Color foregroundColor(BuildContext context) => switch (this) {
        LoaderStyle.accent => context.colors.accentDefault,
        LoaderStyle.neutral => context.colors.neutralDefault,
        LoaderStyle.accentSecondary => context.colors.accentSecondaryDefault,
        LoaderStyle.error => context.colors.errorDefault,
        LoaderStyle.white => context.colors.staticWhite,
      };
}

/// A [Loading] component for showcasing a loading indicator.
///
/// A widget displaying a loading indicator with optional title.
/// The widget supports styles (Light and Dark) sizes (Small or Medium) and orientation (Horizontal or Vertical).
///
/// See also:
/// * [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-–-Components-Library?type=design&node-id=2641-4249&mode=design), design specs
class Loading extends StatelessWidget {
  final String? title;
  final bool isDisplayTitle;
  final Axis orientation;
  final LoaderSize size;
  final Brightness style;
  final LoaderStyle? loaderStyle;
  final Color? color;
  final Color? backgroundColor;
  final double? value;
  final TextStyle? titleTextStyle;

  const Loading({
    this.title,
    this.orientation = Axis.horizontal,
    this.size = LoaderSize.small,
    this.style = Brightness.dark,
    this.isDisplayTitle = true,
    super.key,
    this.color,
    this.backgroundColor,
    this.value,
    this.titleTextStyle,
    this.loaderStyle,
  });

  factory Loading.small({
    String? title,
    Axis orientation = Axis.horizontal,
    bool isDisplayTitle = true,
    Brightness style = Brightness.dark,
    Key? key,
    Color? color,
    Color? backgroundColor,
    double? value,
    TextStyle? titleTextStyle,
    LoaderStyle? loaderStyle,
  }) =>
      Loading(
        title: title,
        orientation: orientation,
        isDisplayTitle: isDisplayTitle,
        style: style,
        key: key,
        color: color,
        backgroundColor: backgroundColor,
        value: value,
        titleTextStyle: titleTextStyle,
        loaderStyle: loaderStyle,
      );

  factory Loading.medium({
    String? title,
    Axis orientation = Axis.horizontal,
    bool isDisplayTitle = true,
    Brightness style = Brightness.dark,
    Key? key,
    Color? color,
    Color? backgroundColor,
    double? value,
    TextStyle? titleTextStyle,
    LoaderStyle? loaderStyle,
  }) =>
      Loading(
        title: title,
        orientation: orientation,
        isDisplayTitle: isDisplayTitle,
        style: style,
        size: LoaderSize.medium,
        key: key,
        color: color,
        backgroundColor: backgroundColor,
        value: value,
        titleTextStyle: titleTextStyle,
        loaderStyle: loaderStyle,
      );

  factory Loading.large({
    String? title,
    Axis orientation = Axis.horizontal,
    bool isDisplayTitle = true,
    Brightness style = Brightness.dark,
    Key? key,
    Color? color,
    Color? backgroundColor,
    double? value,
    TextStyle? titleTextStyle,
    LoaderStyle? loaderStyle,
  }) =>
      Loading(
        title: title,
        orientation: orientation,
        isDisplayTitle: isDisplayTitle,
        style: style,
        size: LoaderSize.large,
        key: key,
        color: color,
        backgroundColor: backgroundColor,
        value: value,
        titleTextStyle: titleTextStyle,
        loaderStyle: loaderStyle,
      );

  Color textColorFromStyle(BuildContext context) {
    if (style == Brightness.light) {
      return context.colors.staticWhite;
    }

    return context.colors.foregroundMuted;
  }

  Color valueColorFromStyle(BuildContext context) {
    if (loaderStyle != null) {
      return loaderStyle!.foregroundColor(context);
    }
    if (style == Brightness.light) {
      return context.colors.staticWhite;
    }

    return context.colors.accentDefault;
  }

  @override
  Widget build(BuildContext context) {
    final _title = title;

    final _titleTextStyle = titleTextStyle ?? context.textStyles.buttonL;

    final children = [
      SizedBox(
        height: size.size,
        width: size.size,
        child: CircularProgressIndicator(
          color: color ?? valueColorFromStyle(context),
          backgroundColor: backgroundColor ?? Colors.transparent,
          strokeWidth: size.strokeWidth,
          value: value,
          strokeCap: StrokeCap.round,
        ),
      ),
      if (isDisplayTitle && _title != null) ...[
        const SizedBox(
          height: Spacing.$3x,
          width: Spacing.$4x,
        ),
        Text(
          _title,
          style: _titleTextStyle.copyWith(
            color: textColorFromStyle(context),
          ),
        )
      ],
    ];

    if (orientation == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

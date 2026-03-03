library buttons;

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/typedef/app_typedef.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:balady_uikit/src/common/state_colors.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'utils/button_ext.dart';

class AppButton extends StatefulWidget {
  final ButtonState buttonState;
  final ButtonType buttonType;
  final String? primaryLabel;
  final String? secondaryLabel;
  final IconData? primaryIcon;
  final IconData? secondaryIcon;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? innerPadding;

  final ButtonSize size;
  final ButtonColorScheme buttonColorScheme;

  final OnTap? onTap;
  final Color? color;
  final Color? textColor;
  final WidgetStatesController? materialStatesController;

  final Color? iconColor;

  const AppButton({
    required ButtonColorScheme buttonColorScheme,
    required this.onTap,
    this.buttonType = ButtonType.primary,
    this.padding,
    this.size = ButtonSize.medium,
    this.primaryLabel,
    this.secondaryLabel,
    this.primaryIcon,
    this.secondaryIcon,
    this.trailing,
    this.color,
    this.textColor,
    ButtonState buttonState = ButtonState.defaultState,
    this.materialStatesController,
    this.innerPadding,
    this.iconColor,
    super.key,
  })  : buttonState = buttonState == ButtonState.normal ? ButtonState.defaultState : buttonState,
        buttonColorScheme = buttonColorScheme == ButtonColorScheme.primary
            ? ButtonColorScheme.accent
            : buttonColorScheme == ButtonColorScheme.secondary
                ? ButtonColorScheme.accentSecondary
                : buttonColorScheme == ButtonColorScheme.tertiary
                    ? ButtonColorScheme.neutral
                    : buttonColorScheme == ButtonColorScheme.warning
                        ? ButtonColorScheme.error
                        : buttonColorScheme == ButtonColorScheme.onColor
                            ? ButtonColorScheme.accentSecondary
                            : buttonColorScheme;

  const AppButton.close({
    required this.onTap,
    this.buttonType = ButtonType.secondary,
    this.textColor,
    this.color,
    ButtonColorScheme buttonColorScheme = ButtonColorScheme.neutral,
    this.size = ButtonSize.small,
    this.primaryLabel,
    this.secondaryLabel,
    this.primaryIcon = SystemIcons.close,
    this.secondaryIcon,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: Spacing.$2x),
    ButtonState buttonState = ButtonState.defaultState,
    this.materialStatesController,
    this.innerPadding,
    this.iconColor,
    super.key,
  })  : buttonState = buttonState == ButtonState.normal ? ButtonState.defaultState : buttonState,
        buttonColorScheme = buttonColorScheme == ButtonColorScheme.primary
            ? ButtonColorScheme.accent
            : buttonColorScheme == ButtonColorScheme.secondary
                ? ButtonColorScheme.accentSecondary
                : buttonColorScheme == ButtonColorScheme.tertiary
                    ? ButtonColorScheme.accentSecondary
                    : buttonColorScheme == ButtonColorScheme.warning
                        ? ButtonColorScheme.error
                        : buttonColorScheme == ButtonColorScheme.onColor
                            ? ButtonColorScheme.neutral
                            : buttonColorScheme;

  @override
  State<AppButton> createState() => _AppButtonState();

  bool get isPressedOrDefault => buttonState == ButtonState.pressed || buttonState == ButtonState.defaultState;
}

class _AppButtonState extends State<AppButton> {
  ButtonState _currentState = ButtonState.defaultState;

  @override
  void initState() {
    _currentState = widget.buttonState;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    if (widget.buttonState != oldWidget.buttonState) {
      _currentState = widget.buttonState;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final _primaryLabel = widget.primaryLabel;
    final _secondaryLabel = widget.secondaryLabel;
    final _primaryIcon = widget.primaryIcon;
    final _secondaryIcon = widget.secondaryIcon;
    final _trailing = widget.trailing;

    final colors = widget.buttonColorScheme.colors(
      type: widget.buttonType,
      context: context,
    );
    final colorSet = switch (_currentState) {
      ButtonState.defaultState => colors.defaultValue,
      ButtonState.loading => colors.loading,
      ButtonState.disabled => colors.disabled,
      ButtonState.pressed => colors.pressed,
      _ => colors.defaultValue,
    };
    final loaderStyle = switch (widget.buttonColorScheme) {
      ButtonColorScheme.accent => LoaderStyle.accent,
      ButtonColorScheme.accentSecondary => LoaderStyle.accentSecondary,
      ButtonColorScheme.error => LoaderStyle.error,
      ButtonColorScheme.neutral => LoaderStyle.neutral,
      _ => LoaderStyle.accent,
    };

    final _isDisabled = widget.buttonState == ButtonState.disabled;

    final primaryIcon = widget.iconColor ?? colorSet.foreground;
    final primaryLabelStyle = widget.size.fontStyle(context).copyWith(
          color: widget.textColor ?? colorSet.foreground,
        );
    final secondaryLabelStyle = widget.size.fontStyle(context).copyWith(color: colorSet.foreground);
    final secondaryIconColor = widget.iconColor ?? colorSet.foreground;

    final children = <Widget>[
      if (_primaryIcon != null) Icon(_primaryIcon, color: primaryIcon),
      if (_primaryLabel != null && _primaryLabel.isNotEmpty == true)
        Text(
          _primaryLabel,
          maxLines: 1,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: primaryLabelStyle,
        ),
      if (_secondaryLabel != null && _secondaryLabel.isNotEmpty == true)
        Text(
          _secondaryLabel,
          maxLines: 1,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: secondaryLabelStyle,
        ),
      if (_secondaryIcon != null) Icon(_secondaryIcon, color: secondaryIconColor),
      if (_trailing != null) Opacity(opacity: _isDisabled ? 0 : 1, child: _trailing),
    ].insertBetween(Spacing.$1_5x.widthBox).toList();

    final _isLoading = widget.buttonState == ButtonState.loading;

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Material(
        key: const Key('buttons_material'),
        clipBehavior: Clip.hardEdge,
        shape: smoothBorder(widget.size.radius),
        color: widget.color ?? colorSet.background,
        child: InkWell(
          key: const Key('buttons_inkwell'),
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onFocusChange: (value) => onFocusChanged(hasFocus: value),
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onTap: widget.isPressedOrDefault ? widget.onTap : null,
          child: Container(
            key: const Key('buttons_container'),
            constraints: BoxConstraints(
              minHeight: widget.size.height,
              minWidth: widget.size.height,
              maxHeight: widget.size.height,
            ),
            padding: widget.innerPadding,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // We need to use Opacity to hide the buttons but keep width of the buttons the same as it was
                Opacity(
                  key: const Key('buttons_opacity'),
                  opacity: _isLoading ? 0 : 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
                if (_isLoading)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Loading.small(
                        color: colorSet.foreground,
                        loaderStyle: loaderStyle,
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onFocusChanged({required bool hasFocus}) {
    if (widget.isPressedOrDefault) {
      setState(() => _currentState = hasFocus ? ButtonState.pressed : ButtonState.defaultState);
    }
  }

  void onTapDown(_) {
    if (widget.isPressedOrDefault) {
      setState(() {
        _currentState = ButtonState.pressed;
      });
    }
  }

  void onTapUp(_) {
    if (widget.isPressedOrDefault) {
      setState(() {
        _currentState = ButtonState.defaultState;
      });
    }
  }
}

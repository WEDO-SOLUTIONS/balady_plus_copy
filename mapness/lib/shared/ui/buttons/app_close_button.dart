import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class AppCloseButton extends StatelessWidget {
  const AppCloseButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
        child: Ink(
          decoration: BoxDecoration(
            color: context.color.surfaceBasePrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: context.colors.neutralOnContainer,
              ),
            ),
          ),
        ),
      );
}

class CustomCloseButton extends StatelessWidget {
  final EdgeInsets? padding;
  const CustomCloseButton({super.key, this.onClose, this.padding = const EdgeInsets.only(bottom: Spacing.$4x)});

  final Function()? onClose;
  static const borderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? const EdgeInsets.only(bottom: Spacing.$4x),
        child: Material(
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onClose,
            child: SizedBox(
              height: Spacing.$10x,
              width: Spacing.$10x,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusBorder.m),
                  color: context.colors.neutralContainerDefault.withOpacity(.12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.$2x),
                  child: SystemIcons.close.icon(color: context.color.textAndIconsBaseSecondary),
                ),
              ),
            ),
          ),
        ),
      );
}

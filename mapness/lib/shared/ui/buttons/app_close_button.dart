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
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: NonThemeColor.color58,
              ),
            ),
          ),
        ),
      );
}

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key, this.onClose});

  final Function()? onClose;
  static const borderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: Spacing.$4x),
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
                  color: context.colorsV3.neutralContainerDefault.withOpacity(0.12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.$2x),
                  child: SystemIcons.close.icon(color: context.colorsV3.neutralOnContainer),
                ),
              ),
            ),
          ),
        ),
      );
}

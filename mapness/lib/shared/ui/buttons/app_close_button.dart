import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class AppCloseButton extends StatelessWidget {
  const AppCloseButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  // Transparent Material: the default (theme-white) rectangle peeks out of
  // the Ink's rounded corners on dark surfaces.
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: Ink(
      decoration: BoxDecoration(color: context.colors.backgroundSurface1, borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.close, color: context.colors.neutralOnContainer),
        ),
      ),
    ),
  );
}

class CustomCloseButton extends StatelessWidget {
  final EdgeInsets? padding;
  const CustomCloseButton({super.key, this.onClose, this.padding});

  final Function()? onClose;
  static const borderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding ?? const EdgeInsets.only(bottom: Spacing.$4x),
    child: AppButton.close(padding: EdgeInsets.zero, primaryIcon: SystemIcons.closeSmall, onTap: onClose),
  );
}

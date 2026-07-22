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
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface1,
        borderRadius: BorderRadius.circular(8),
        // Figma "Elements / wrapper" shadow — keeps the button visible on
        // near-white sheet backgrounds (surface2).
        boxShadow: const [
          BoxShadow(color: Color(0x0D101828), offset: Offset(0, 1), blurRadius: 3),
          BoxShadow(color: Color(0x0D101828), offset: Offset(0, 1), blurRadius: 2),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        // Figma "Elements / wrapper": 44px square, design-system cross in
        // foreground/default — not the thin grey Material glyph.
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(SystemIcons.close, size: 24, color: context.colors.foregroundDefault),
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
